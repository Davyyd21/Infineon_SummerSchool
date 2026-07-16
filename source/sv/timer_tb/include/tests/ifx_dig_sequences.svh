class ifx_pin_toggle_sequence extends uvm_sequence #(ifx_dig_pin_toggle);

  `uvm_object_utils(ifx_pin_toggle_sequence)

  rand int selected_pin;
  rand int num_of_toggles;
  rand int half_period_ns;

  constraint selected_pin_c {
    selected_pin inside {[1:`EXT_INPUTS_NB]};
  }

  constraint half_period_c {
    half_period_ns >= 0;
    half_period_ns < 100000;
  }

  constraint num_of_toggles_c {
    num_of_toggles >= 0;
  }

  function new(string name = get_type_name());
    super.new(name);
  endfunction

  virtual task body();

    ifx_dig_pin_toggle item;

    item = ifx_dig_pin_toggle::type_id::create("item");

    start_item(item);

    item.selected_pin   = selected_pin;
    item.num_of_toggles = num_of_toggles;
    item.half_period_ns = half_period_ns;

    finish_item(item);

  endtask : body

endclass