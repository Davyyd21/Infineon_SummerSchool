`timescale 1ns / 1ps

module mux2_pwm(
    input logic sel,
    input logic[9:0]in0,in1,
    output logic[9:0]out
);

always_comb
begin
    case(sel)
        1'b0: out = in0;
        1'b1: out = in1;
        default: out = 10'b0;
    endcase
end 
endmodule