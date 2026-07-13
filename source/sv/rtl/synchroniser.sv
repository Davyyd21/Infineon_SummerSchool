`timescale 1ns / 1ps

module synchroniser(
    input logic clk_i,
    input logic in_i,
    output logic out_o,
    input logic rstn_i
);

logic out_o_1;

always_ff @(posedge clk_i or negedge rstn_i) begin
    if(!rstn_i) begin
        out_o_1 <= 1'b0;
    end else begin
        out_o_1 <= in_i;
    end
end

always_ff @(posedge clk_i or negedge rstn_i) begin
    if(!rstn_i) begin
        out_o <= 1'b0;
    end else begin
        out_o <= out_o_1;
    end
end



endmodule