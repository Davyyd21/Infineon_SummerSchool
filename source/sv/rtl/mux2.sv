`timescale 1ns / 1ps

module mux2(
        input logic sel,
        input logic sw_trigger,
        input logic input0_i,
        output logic out_o
);

always_comb begin
    case(sel)
        1'b0: out_o = input0_i;
        1'b1: out_o = sw_trigger;
        default: out_o = 1'b0;
    endcase
end

endmodule