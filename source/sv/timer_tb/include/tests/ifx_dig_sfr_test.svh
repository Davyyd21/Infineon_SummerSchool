class ifx_dig_sfr_test extends ifx_dig_testbase;

  `uvm_component_utils(ifx_dig_sfr_test)

  logic [15:0] patterns[] = {16'h0000,16'hFFFF,16'hAAAA,16'h5555};

  function new(string name = "ifx_dig_sfr_test",uvm_component parent = null);
    super.new(name, parent);
  endfunction : new


  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    `uvm_info(get_full_name(),"=== SFR TEST BUILD PHASE STARTING ===",UVM_NONE)
  endfunction : build_phase


  task run_phase(uvm_phase phase);
    super.run_phase(phase);

    `uvm_info(get_full_name(),"=== SFR TEST RUN PHASE STARTING ===",UVM_NONE)
  endtask : run_phase


  task main_phase(uvm_phase phase);

    phase.raise_objection(this);

    `uvm_info("SFR_TEST", "SFR test started", UVM_LOW)

    drive_reset(3, CYCLES);

    foreach (patterns[pattern_idx]) begin

      `uvm_info("SFR_TEST",$sformatf("Testing pattern 0x%04h",patterns[pattern_idx]),UVM_LOW)

      `uvm_info("DEBUG", "Before CTRL0", UVM_NONE)
      write_reg_fields("CTRL0", {"mode"}, {patterns[pattern_idx][1:0]});
      `uvm_info("DEBUG", "After CTRL0", UVM_NONE)

      write_reg_fields("PWM_MODE", {"duty_cycle", "frequency_sel"}, {patterns[pattern_idx][9:0], patterns[pattern_idx][13:12]});

      write_reg_fields("CNT_TIMER_MODE0", {"input_sel", "trigger_sel", "out_function", "capture_sel"}, {patterns[pattern_idx][3:0], patterns[pattern_idx][5:4], patterns[pattern_idx][8], patterns[pattern_idx][13:12]});
      write_reg_fields("CNT_TIMER_MODE1", {"target_value"}, {patterns[pattern_idx][9:0]});
      read_reg("CTRL0");
      read_reg("PWM_MODE");
      read_reg("CNT_TIMER_MODE0");
      read_reg("CNT_TIMER_MODE1");

     // drive_reset(3, CYCLES);

    end

    `uvm_info("SFR_TEST", "SFR test finished", UVM_LOW)
    `WAIT_NS(1000)
    phase.drop_objection(this);

  endtask : main_phase

endclass : ifx_dig_sfr_test