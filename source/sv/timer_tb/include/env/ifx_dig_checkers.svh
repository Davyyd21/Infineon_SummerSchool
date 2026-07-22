/*
 * Disclosure: Copyright (C) Infineon Technologies AG.
 * This code belongs to Infineon Technologies AG and must not be redistributed
 * or made publicly available without prior written consent of the owner.
 */

task do_checkers();
  bit pwm_measure_timeout_b = 0;

  fork

    begin
      `uvm_info(
        "DCHK_02",
        "Checker dchk_02_rdata_o_when_no_access started",
        UVM_LOW
      )

      // forever begin
      //   @(negedge dig_vif.clk_i);

      //   if(dig_vif.rstn_i && !dig_vif.acc_en_i) begin
      //     if(dig_vif.rdata_o !== '0) begin
      //       `uvm_error(
      //         "dchk_02_rdata_o_when_no_access",
      //         $sformatf(
      //           "Expecting 0 on rdata_o while no access is ongoing, but got 0x%0h",
      //           dig_vif.rdata_o
      //         )
      //       )
      //     end
      //   end
      // end
    end


    begin
      `uvm_info(
        "DCHK_03",
        "Checker dchk_03_pwm_on_0_duty_cycle started",
        UVM_LOW
      )

      forever begin
        @(configured_duty_cycle, configured_mode, dig_vif.output_o);

        if(dig_vif.rstn_i &&
           configured_mode == PWM_MODE &&
           configured_duty_cycle == 0.0) begin

          if(dig_vif.output_o !== 1'b0) begin
            `uvm_error(
              "dchk_03_pwm_on_0_duty_cycle",
              $sformatf(
                "Expecting 0 on output for 0%% duty cycle, but got %b",
                dig_vif.output_o
              )
            )
          end
        end
      end
    end


    begin
      `uvm_info(
        "DCHK_04",
        "Checker dchk_04_pwm_on_1_duty_cycle started",
        UVM_LOW
      )

      forever begin
        @(configured_duty_cycle, configured_mode, dig_vif.output_o);

        if(dig_vif.rstn_i &&
           configured_mode == PWM_MODE &&
           configured_duty_cycle == 1.0) begin

          if(dig_vif.output_o !== 1'b1) begin
            `uvm_error(
              "dchk_04_pwm_on_1_duty_cycle",
              $sformatf(
                "Expecting 1 on output for 100%% duty cycle, but got %b",
                dig_vif.output_o
              )
            )
          end
        end
      end
    end

  join_none
endtask

// TODO DAY6: Complete the functions so that it check the read data from the DUT against the expected values from the register model. 
function void check_read_data(int address, int read_data);

  ifx_dig_reg reg_h;
  int expected_data;

  reg_h = regblock.get_reg_by_address(address);

  if(reg_h == null)
    expected_data = 0;
  else
    expected_data = reg_h.get_reg_value();

  dchk_01_read_data:
    assert(read_data == expected_data)
    else
      `uvm_error("dchk_01_read_data",$sformatf("Read mismatch at address 0x%0h: expected 0x%0h, received 0x%0h",address,expected_data,read_data))

endfunction

