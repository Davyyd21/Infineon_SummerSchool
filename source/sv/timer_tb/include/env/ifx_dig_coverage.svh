/*
 * Disclosure: Copyright (C) Infineon Technologies AG.
 * This code belongs to Infineon Technologies AG and must not be redistributed
 * or made publicly available without prior written consent of the owner.
 */

task collect_coverage();

  fork

    // Coverage-ul este eșantionat după fiecare scriere într-un registru.
    forever begin
      @(reg_write_e);

      // Permitem taskului update_reg_variables() să actualizeze variabilele.
      #1step;

      if(configured_mode == PWM_MODE) begin
        dcov_00_pwm_configuration.sample();
      end

      if(configured_mode == COUNTER_MODE ||
         configured_mode == TIMER_MODE) begin

        dcov_01_input_selection_modes.sample();
        dcov_02_trigger_selection.sample();
        dcov_03_output_function.sample();
      end
    end

  join

endtask


// Verifică fiecare selecție de intrare în Counter și Timer.
covergroup dcov_01_input_selection_modes with function sample();

  option.name         = "dcov_01_input_selection_modes";
  option.per_instance = 1;

  INPUT_SELECTION_cp: coverpoint configured_input_select_b {
    bins SOFTWARE_INPUT      = {0};
    bins EXTERNAL_INPUTS[15] = {[1:15]};
  }

  MODE_cp: coverpoint configured_mode {
    bins COUNTER = {COUNTER_MODE};
    bins TIMER   = {TIMER_MODE};

    ignore_bins OTHER_MODES = {PWM_MODE, 2'b11};
  }

  INPUT_SELECTION_x_MODE_crs: cross INPUT_SELECTION_cp, MODE_cp;

endgroup


// Verifică tipurile de trigger în Counter și Timer.
covergroup dcov_02_trigger_selection with function sample();

  option.name         = "dcov_02_trigger_selection";
  option.per_instance = 1;

  TRIGGER_cp: coverpoint configured_trigger_selection {
    bins RISING_EDGE  = {0};
    bins FALLING_EDGE = {1};
    bins ANY_EDGE     = {2};

    ignore_bins NO_TRIGGER = {3};
  }

  MODE_cp: coverpoint configured_mode {
    bins COUNTER = {COUNTER_MODE};
    bins TIMER   = {TIMER_MODE};

    ignore_bins OTHER_MODES = {PWM_MODE, 2'b11};
  }

  TRIGGER_x_MODE_crs: cross TRIGGER_cp, MODE_cp;

endgroup


// Verifică dacă au fost folosite atât PULSE, cât și TOGGLE.
covergroup dcov_03_output_function with function sample();

  option.name         = "dcov_03_output_function";
  option.per_instance = 1;

  OUT_FUNCTION_cp: coverpoint regblock.get_field_value("CNT_TIMER_MODE0","out_function") 
    {
      bins PULSE  = {0};
      bins TOGGLE = {1};
    }

  MODE_cp: coverpoint configured_mode 
  {
    bins COUNTER = {COUNTER_MODE};
    bins TIMER   = {TIMER_MODE};

    ignore_bins OTHER_MODES = {PWM_MODE, 2'b11};
  }

  OUT_FUNCTION_x_MODE_crs: cross OUT_FUNCTION_cp, MODE_cp;

endgroup


// Coverage pentru configurația PWM.
covergroup dcov_00_pwm_configuration with function sample();

  option.name         = "dcov_00_pwm_configuration";
  option.per_instance = 1;

  PWM_FREQ_cp: coverpoint configured_pwm_frequency {
    bins FREQ_100_HZ = {100};
    bins FREQ_200_HZ = {200};
    bins FREQ_320_HZ = {320};
    bins FREQ_400_HZ = {400};
  }

  PWM_DUTY_cp: coverpoint regblock.get_field_value("PWM_MODE","duty_cycle") 
    {
      bins DUTY_0        = {0};
      bins DUTY_100      = {1023};
      bins DUTY_INTV[10] = {[1:1022]};
    }

  PWM_FREQ_x_DUTY_crs: cross PWM_FREQ_cp, PWM_DUTY_cp;

endgroup