/*
 * Disclosure: Copyright (C) Infineon Technologies AG.
 * This code belongs to Infineon Technologies AG and must not be redistributed
 * or made publicly available without prior written consent of the owner.
 */

class ifx_dig_hello_world extends ifx_dig_testbase;

  `uvm_component_utils(ifx_dig_hello_world)

  // interfata virtuala pe care o vom obtine direct din config_db,
  // fara sa trecem prin dig_env / dig_cfg
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

    // preluam interfata virtuala setata in ifx_dig_top
    if (!uvm_config_db#(virtual ifx_dig_interface)::get(this, "", "dig_if", dig_vif))
      `uvm_fatal(get_full_name(), "Nu am putut obtine dig_if din config_db!")

    phase.raise_objection(this);

    // (a) afiseaza mesajul "Start of test"
    `uvm_info(get_full_name(), "Start of test", UVM_NONE)

    // (b) reset activ (rstn_i=0) tinut timp de 2 pulsuri de ceas
    dig_vif.rstn_i = 1'b0;
    @(posedge dig_vif.clk_i);
    @(posedge dig_vif.clk_i);
    dig_vif.rstn_i = 1'b1;

    // (c) asteapta 500 us
    `WAIT_US(500)

    // (d) afiseaza mesajul "Hello UVM World!"
    `uvm_info(get_full_name(), "Hello UVM World!", UVM_NONE)

    // (e) asteapta inca 500 us si incheie simularea
    `WAIT_US(500)

    phase.drop_objection(this);
  endtask

endclass