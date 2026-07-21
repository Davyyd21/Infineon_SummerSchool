/*
 * Disclosure: Copyright (C) Infineon Technologies AG.
 * This code belongs to Infineon Technologies AG and must not be redistributed
 * or made publicly available without prior written consent of the owner.
 */

class ifx_dig_counter_mode_test extends ifx_dig_testbase;

  `uvm_component_utils(ifx_dig_counter_mode_test)

  rand logic[3:0] select_input;
  rand logic out_function;
  rand logic[1:0] select_trigger;
  rand logic[1:0] select_capture_event;
  rand logic[9:0] target_value;
  mode_t op_mode = COUNTER_MODE;

  constraint select_input_c {
    select_input inside {[1:15]};
  }

  function new(string name = "ifx_dig_counter_mode_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    // TODO DAY2: Add infomessage for this phase
    `uvm_info(get_full_name(), ">>>>> COUNTER_MODE BUILD_PHASE starts <<<<<", UVM_NONE)
  endfunction : build_phase

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    `uvm_info(get_full_name(), "=== RUN PHASE STARTING ===", UVM_NONE)
  endtask

  task main_phase(uvm_phase phase);

    phase.raise_objection(this);

    if(!this.randomize())
      `uvm_error(get_name(), "ERROR: Randomize failed!")

    // TODO DAY3: Refactor reset driving logic to use drive_reset task
    // TODO DAY4: Refactor test logic to use the write_reg_fields and read_reg tasks for register accesses
    `uvm_info("COUNTER_MODE_TEST", "Release reset", UVM_NONE)

    // dig_env.p_dig_cfg.dig_vif.rstn_i = 0;
    // `WAIT_NS(10)
    // dig_env.p_dig_cfg.dig_vif.rstn_i = 1;

    drive_reset(10, TIME_LENGTH);

    `WAIT_MS(1)

    // MODE0
    `uvm_info("COUNTER_MODE_TEST", "Configure COUNTER MODE", UVM_NONE)

    // select input 1 + toggle output
    this.select_input = 1;

    write_reg_fields("CNT_TIMER_MODE0", {"input_sel", "trigger_sel", "out_function", "capture_sel"}, {this.select_input, this.select_trigger, this.out_function, this.select_capture_event});
    read_reg("CNT_TIMER_MODE0");
    // MODE1
    target_value = 5;

    `uvm_info("COUNTER_MODE_TEST", "Configure COUNTER MODE", UVM_NONE)

    // set target value
    write_reg_fields("CNT_TIMER_MODE1", {"target_value"}, {target_value});

    read_reg("CNT_TIMER_MODE1");

    // set counter mode - use regs function
    `uvm_info("COUNTER_MODE_TEST", "Change to COUNTER MODE", UVM_NONE)

    write_reg_fields("CTRL0", {"mode"}, {op_mode}, .read_after_write(1));

    // TODO DAY3: Add stimulus to toggle the selected input 10 times with a period of 100ns
   // drive_input_pulses(this.select_input, 10, 50);

    // TODO DAY4: Refactor the stimulus to toggle the selected input using a dedicated pin toggle sequence
    pin_toggle_seq.selected_pin = this.select_input;
    pin_toggle_seq.num_of_toggles = 10;
    pin_toggle_seq.half_period_ns = 50;
    pin_toggle_seq.start(dig_env.pin_sequencer);

    `WAIT_MS(20)

    phase.drop_objection(this);

  endtask

endclass