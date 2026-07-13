`timescale 1ns / 1ps

module EdgeDetection(
    input logic clk_i,
    input logic rstn_i,
    input logic input_source,
    output logic rise_event,
    output logic fall_event
);

logic Q;
always_ff @(posedge clk_i or negedge rstn_i)
begin
    if(!rstn_i)
        Q <= 1'b0;
    else
        Q <= input_source;
end

assign rise_event = input_source & ~Q;
assign fall_event = ~input_source & Q;


endmodule