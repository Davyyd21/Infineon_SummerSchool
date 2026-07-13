`timescale 1ns / 1ps

module prescaler(
    input logic[8:0]limit_f1,
    input logic rstn,
    input logic clk,
    output logic prescaler
);
logic[8:0]counter;

always_ff @(posedge clk or negedge rstn)
begin
    if(!rstn)
        counter <= 9'b0;
    else if(counter == limit_f1)begin
        counter <= 9'b0;
        prescaler <= 1'b1;
    end
    else begin
        prescaler <= 1'b0;
        counter <= counter + 1'b1; 
    end
end




endmodule