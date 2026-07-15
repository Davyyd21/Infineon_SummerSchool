class ifx_dig_sfr_test extends ifx_dig_testbase;

  `uvm_component_utils(ifx_dig_sfr_test)

  logic [15:0] patterns[] = {16'h0000,16'hFFFF,16'hAAAA,16'h5555};

  logic [2:0] rw_addresses[] = {3'b000,3'b001,3'b010,3'b011};

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

    `uvm_info("SFR_TEST","SFR test started",UVM_LOW)

    drive_reset(3, CYCLES);

    foreach (patterns[pattern_idx]) begin

      `uvm_info("SFR_TEST",$sformatf("Testing pattern 0x%04h",patterns[pattern_idx]),UVM_LOW)

      foreach (rw_addresses[reg_idx]) begin

        data_bus_write_seq.address = rw_addresses[reg_idx];
        data_bus_write_seq.data    = patterns[pattern_idx];

        `uvm_info("SFR_TEST",$sformatf("WRITE address=%0d data=0x%04h",rw_addresses[reg_idx],patterns[pattern_idx]),UVM_LOW)

        data_bus_write_seq.start(
          dig_env.data_bus_uvc_agt.sequencer
        );

      end

      foreach (rw_addresses[reg_idx]) begin

        data_bus_read_seq.address = rw_addresses[reg_idx];

        `uvm_info("SFR_TEST",$sformatf("READ address=%0d",rw_addresses[reg_idx]),UVM_LOW)

        data_bus_read_seq.start(
          dig_env.data_bus_uvc_agt.sequencer
        );

      end

      drive_reset(3, CYCLES);

    end

    `uvm_info("SFR_TEST","SFR test finished",UVM_LOW)

    phase.drop_objection(this);

  endtask : main_phase

endclass : ifx_dig_sfr_test