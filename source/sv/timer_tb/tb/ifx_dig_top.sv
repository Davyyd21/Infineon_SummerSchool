/*
 * Disclosure: Copyright (C) Infineon Technologies AG.
 * This code belongs to Infineon Technologies AG and must not be redistributed
 * or made publicly available without prior written consent of the owner.
 */

`include "ifx_dig_defines.svh"
`include"uvm_macros.svh"

module ifx_dig_top;
  import uvm_pkg::*;

  import ifx_dig_data_bus_uvc_pkg::*;
  import ifx_dig_pkg::*;
  import ifx_dig_test_pkg::*;

  initial begin
    $timeformat(-9, 3, " ns", 15);
    $display("running test");
    run_test();
  end

  wire               clk_i_w;
  wire               rstn_i_w;

  wire acc_en_i_w;
  wire wr_en_i_w;
  wire [`AWIDTH-1:0] addr_i_w;
  wire [`DWIDTH-1:0] wdata_i_w;
  wire [`DWIDTH-1:0] rdata_o_w;

  wire [`EXT_INPUTS_NB-1:0] inputs_i_w;
  
  wire output_o_w;

  reg clk;

  // TODO DAY1: Create DUT instance and connect to the wires here.
ifx_dig_interface DUT(
  .clk_i(clk_i_w),
  .rstn_i(rstn_i_w),
  .acc_en_i(acc_en_i_w),
  .wr_en_i(wr_en_i_w),
  .addr_i(addr_i_w),
  .wdata_i(wdata_i_w),
  .rdata_o(rdata_o_w),
  .inputs_i(inputs_i_w),
  .output_o(output_o_w)
);

  // TODO DAY1: Create interface instances and connect to DUT here.
TOP topdut(
  .clk_i(clk_i_w),
  .rstn_i(rstn_i_w),
  .acc_en_i(acc_en_i_w),
  .wr_en_i(wr_en_i_w),
  .addr_i(addr_i_w),
  .wdata_i(wdata_i_w),
  .rdata_o(rdata_o_w),
  .input1_i(inputs_i_w[0]),
  .input2_i(inputs_i_w[1]),
  .input3_i(inputs_i_w[2]),
  .input4_i(inputs_i_w[3]),
  .input5_i(inputs_i_w[4]),
  .input6_i(inputs_i_w[5]),
  .input7_i(inputs_i_w[6]),
  .input8_i(inputs_i_w[7]),
  .input9_i(inputs_i_w[8]),
  .input10_i(inputs_i_w[9]),
  .input11_i(inputs_i_w[10]),
  .input12_i(inputs_i_w[11]),
  .input13_i(inputs_i_w[12]),
  .input14_i(inputs_i_w[13]),
  .input15_i(inputs_i_w[14]),
  .out_o(output_o_w)
);

  ifx_dig_data_bus_uvc_interface data_uvc_if(
    .clk_i(clk_i_w),
    .rstn_i(rstn_i_w),
    
    .acc_en_o(acc_en_i_w),
    .wr_en_o(wr_en_i_w),
    .addr_o(addr_i_w),
    .wdata_o(wdata_i_w),
    .rdata_i(rdata_o_w)

  );

  // TODO DAY1: Complete generate_clock task and use it to generate the system clock with a frequency of 40 MHz
  initial begin
    generate_clock("ns", 25); 
  end



  task generate_clock(string time_unit, int period);
      time half_period;
      case(time_unit)
        "s":half_period=1s*(period/2);
        "ms":half_period=1ms*(period/2);
        "us":half_period=1us*(period/2);
        "ns":half_period=1ns*(period/2);
        "ps":half_period=1ps*(period/2);
        default:half_period=1ns*(period/2);
      endcase
      clk_i_w=0;
      forever #half_period clk_i_w=~clk_i_w;
  endtask


  assign clk_i_w = clk;

  initial begin
    uvm_config_db #(virtual ifx_dig_interface)::set(uvm_top, "*", "dig_if", dig_if);

    uvm_config_db #(virtual ifx_dig_data_bus_uvc_interface)::set(uvm_top, "data_bus_uvc_agt", "vif", data_uvc_if);

  end
endmodule
