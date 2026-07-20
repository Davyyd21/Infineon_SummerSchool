class ifx_dig_pin_driver extends uvm_driver #(ifx_dig_pin_toggle);

  `uvm_component_utils(ifx_dig_pin_driver)

  virtual ifx_dig_interface dig_vif;

  function new(string name = "ifx_dig_pin_driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if(!uvm_config_db#(virtual ifx_dig_interface)::get(this, "", "dig_if", dig_vif))
      `uvm_fatal("PIN_DRIVER/NOVIF", "No digital interface found")
  endfunction

  task run_phase(uvm_phase phase);
    ifx_dig_pin_toggle item;

    forever begin
      seq_item_port.get_next_item(item);

      repeat(item.num_of_toggles) begin
        dig_vif.inputs_i[item.selected_pin - 1] = 0;
        #(item.half_period_ns);
        dig_vif.inputs_i[item.selected_pin - 1] = 1;
        #(item.half_period_ns);
      end

      dig_vif.inputs_i[item.selected_pin - 1] = 0;

      seq_item_port.item_done();
    end
  endtask

endclass