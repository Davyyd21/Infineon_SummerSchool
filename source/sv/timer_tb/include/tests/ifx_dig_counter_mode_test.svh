/*
 * Disclosure: Copyright (C) Infineon Technologies AG.
 * This code belongs to Infineon Technologies AG and must not be redistributed
 * or made publicly available without prior written consent of the owner.
 */

class ifx_dig_counter_mode_test extends ifx_dig_testbase;

  `uvm_component_utils(ifx_dig_counter_mode_test)

  rand logic [3:0] select_input;
  rand logic       out_function;
  rand logic [1:0] select_trigger;
  rand logic [1:0] select_capture_event;
  rand logic [9:0] target_value;

  function new(
    string name = "ifx_dig_counter_mode_test",
    uvm_component parent = null
  );
    super.new(name, parent);
  endfunction


  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    `uvm_info(get_full_name(),">>>>> COUNTER_MODE BUILD_PHASE starts <<<<<",UVM_NONE)
  endfunction : build_phase


  task run_phase(uvm_phase phase);
    super.run_phase(phase);

    `uvm_info(get_full_name(),"=== RUN PHASE STARTING ===",UVM_NONE)
  endtask


  task main_phase(uvm_phase phase);

    mode_t tested_modes[2];

    phase.raise_objection(this);

    tested_modes[0] = COUNTER_MODE;
    tested_modes[1] = TIMER_MODE;

    `uvm_info("COUNTER_MODE_TEST","Apply reset",UVM_NONE)

    drive_reset(10, TIME_LENGTH);

    `WAIT_MS(1)

    // Testăm COUNTER_MODE și TIMER_MODE.
    foreach(tested_modes[mode_idx]) begin

      `uvm_info("COUNTER_MODE_TEST",$sformatf("Testing mode %0d",tested_modes[mode_idx]),UVM_NONE)

      write_reg_fields("CTRL0",{"mode"},{tested_modes[mode_idx]},.read_after_write(1));

      // Testăm software input și toate cele 15 intrări externe.
      for(int input_idx = 0; input_idx <= 15; input_idx++) begin

        select_input         = input_idx;
        select_trigger       = input_idx % 3;
        out_function         = input_idx % 2;
        select_capture_event = 0;
        target_value         = 2;

        `uvm_info("COUNTER_MODE_TEST",$sformatf("Mode=%0d input=%0d trigger=%0d output_function=%0d",tested_modes[mode_idx],select_input,select_trigger,out_function),UVM_NONE)

        write_reg_fields("CNT_TIMER_MODE0",{"input_sel","trigger_sel","out_function","capture_sel"},{select_input,select_trigger,out_function,select_capture_event});

        write_reg_fields("CNT_TIMER_MODE1",{"target_value"},{target_value});

        // Oferim timp coverage-ului să eșantioneze configurația.
        `WAIT_NS(100)

        if(input_idx == 0) begin

          // Pentru input_sel = 0 este folosit software trigger-ul.
          write_reg_fields("COMMAND",{"sw_trigger"},{1});

          `WAIT_NS(100)

          write_reg_fields("COMMAND",{"sw_trigger"},{0});

          `WAIT_NS(100)

          write_reg_fields("COMMAND",{"sw_trigger"},{1});

          `WAIT_NS(100)

          write_reg_fields("COMMAND",{"sw_trigger"},{0});

        end else begin

          // Pentru input_sel 1...15 folosim secvența de toggle.
          pin_toggle_seq.selected_pin    = input_idx;
          pin_toggle_seq.num_of_toggles = 3;
          pin_toggle_seq.half_period_ns  = 50;

          pin_toggle_seq.start(dig_env.pin_sequencer);

        end

        `WAIT_NS(200)

      end
    end

    `WAIT_MS(1)

    phase.drop_objection(this);

  endtask

endclass