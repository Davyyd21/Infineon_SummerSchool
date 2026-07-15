class ifx_dig_hello_world extends ifx_dig_testbase;

  `uvm_component_utils(ifx_dig_hello_world)

  virtual ifx_dig_interface dig_vif;

  function new(string name = "ifx_dig_hello_world", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    `uvm_info(get_full_name(), "Build phase starting", UVM_NONE)
  endfunction : build_phase

  task run_phase(uvm_phase phase);
    super.run_phase(phase);

    if (!uvm_config_db#(virtual ifx_dig_interface)::get(
          this,
          "",
          "dig_if",
          dig_vif
        ))
      `uvm_fatal(
        get_full_name(),
        "Nu am putut obtine dig_if din config_db!"
      )

    phase.raise_objection(this);

    `uvm_info(get_full_name(), "Start of test", UVM_NONE)

    // Reset pentru minimum 3 cicluri de ceas
    drive_reset(3, CYCLES);

    `WAIT_US(500)

    `uvm_info(get_full_name(), "Hello UVM World!", UVM_NONE)

    `WAIT_US(500)

    phase.drop_objection(this);

  endtask : run_phase

endclass : ifx_dig_hello_world