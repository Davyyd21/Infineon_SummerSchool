`timescale 1ns / 1ps

module register_N(
    input logic clk,
    input logic rstn,
    input logic en,
    input logic clear,
    output logic [9:0] out
);

logic[9:0]in;

always_ff @(posedge clk or negedge rstn)
begin
    if(!rstn)
        out <= 10'b0;
    else if(clear)
        out <= 10'b0;
    else out <= in;
end

always_ff @(posedge clk or negedge rstn)
begin
    if(!rstn)
        in <= 10'b0;
    else if(en)
        in <= out + 1'b1;
    else
        in <= out;
end
endmodule