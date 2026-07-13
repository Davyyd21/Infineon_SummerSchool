`timescale 1ns / 1ps

module TOP(
    input logic clk_i,
    input logic rstn_i,
    input logic acc_en_i,
    input logic wr_en_i,
    input logic [2:0] addr_i,
    input logic [15:0] wdata_i,
    output logic [15:0] rdata_o,
    input logic input1_i,
    input logic input2_i,
    input logic input3_i,
    input logic input4_i,
    input logic input5_i,
    input logic input6_i,
    input logic input7_i,
    input logic input8_i,
    input logic input9_i,
    input logic input10_i,
    input logic input11_i,
    input logic input12_i,
    input logic input13_i,
    input logic input14_i,
    input logic input15_i,
    output logic out_o
);

logic sw_trigger;
logic [3:0] input_selection;
logic[1:0] Mode;
logic [9:0] Duty_Cycle;
logic [1:0] Frequency_selection;
logic [1:0] Trigger_selection;
logic Out_function;
logic [1:0] Capture_selection;
logic [9:0] Target_value;
logic [9:0] Counter_value;
logic Clear;
logic [9:0] Capture_value;
logic Timer_Running;
logic out_comparator;
logic out_mux16;
logic out_synchroniser;
logic out_mux2;
logic out_counter_core;

register_block reg_block_inst(
   .clk_i(clk_i),
   .rstn_i(rstn_i),
   .acc_en_i(acc_en_i),
   .wr_en_i(wr_en_i),
   .addr_i(addr_i),
   .wdata_i(wdata_i),
   .rdata_o(rdata_o),
   .input_selection(input_selection),
   .sw_trigger(sw_trigger),
   .Mode(Mode),
   .Duty_Cycle(Duty_Cycle),
   .Frequency_selection(Frequency_selection),
   .Trigger_selection(Trigger_selection),
   .Out_function(Out_function),
   .Capture_selection(Capture_selection),
   .Target_value(Target_value),
   .Counter_value(Counter_value),
   .Clear(Clear),
   .Capture_value(Capture_value),
   .Timer_Running(Timer_Running)
);

comparator comparator_inst(
    .input_selection(input_selection),
    .input0_i(4'b0000),
    .out(out_comparator)
);

mux mux_inst(
    .input_selection(input_selection),
    .input0_i(0),
    .input1_i(input1_i),
    .input2_i(input2_i),
    .input3_i(input3_i),
    .input4_i(input4_i),
    .input5_i(input5_i),
    .input6_i(input6_i),
    .input7_i(input7_i),
    .input8_i(input8_i),
    .input9_i(input9_i),
    .input10_i(input10_i),
    .input11_i(input11_i),
    .input12_i(input12_i),
    .input13_i(input13_i),
    .input14_i(input14_i),
    .input15_i(input15_i), // Default input for unused selection
    .out_o(out_mux16)
);

synchroniser synchroniser_inst(
    .clk_i(clk_i),
    .in_i(out_mux16),
    .out_o(out_synchroniser),
    .rstn_i(rstn_i)
);

mux2 mux2_inst(
    .sel(out_comparator),
    .sw_trigger(sw_trigger),
    .input0_i(out_synchroniser),
    .out_o(out_mux2)
);

Counter_Core counter_core_inst(
    .Mode(Mode),
    .Duty_Cycle(Duty_Cycle),
    .Frequency_selection(Frequency_selection),
    .Trigger_selection(Trigger_selection),
    .Out_function(Out_function),
    .Capture_selection(Capture_selection),
    .Target_value(Target_value),
    .Counter_value(Counter_value),
    .Clear(Clear),
    .Capture_value(Capture_value),
    .Timer_Running(Timer_Running),
    .input_source(out_mux2),
    .clock(clk_i),
    .rstn_i(rstn_i),
    .out(out_counter_core)
);

always_ff@(posedge clk_i or negedge rstn_i)begin
    if(!rstn_i)
        out_o<=0;
    else begin
        out_o<=out_counter_core;
    end
end
endmodule