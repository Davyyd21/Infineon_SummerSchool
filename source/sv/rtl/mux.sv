`timescale 1ns / 1ps

module mux(
    input logic [3:0] input_selection,
    input logic input0_i,
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
always_comb begin
    case(input_selection)
        4'b0000: out_o = input0_i;
        4'b0001: out_o = input1_i;
        4'b0010: out_o = input2_i;
        4'b0011: out_o = input3_i;
        4'b0100: out_o = input4_i;  
        4'b0101: out_o = input5_i;
        4'b0110: out_o = input6_i;
        4'b0111: out_o = input7_i;
        4'b1000: out_o = input8_i;
        4'b1001: out_o = input9_i;
        4'b1010: out_o = input10_i;
        4'b1011: out_o = input11_i;
        4'b1100: out_o = input12_i;
        4'b1101: out_o = input13_i;
        4'b1110: out_o = input14_i;
        4'b1111: out_o = input15_i;
        default: out_o = 1'b0;
    endcase
end
endmodule