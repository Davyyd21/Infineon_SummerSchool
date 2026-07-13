`timescale 1ns / 1ps

module comp_eq(
    input logic[9:0]limit_f2,
    input logic[9:0]out_register,
    output logic sel_mux2
);

always_comb
begin
    if(limit_f2 == out_register)
        sel_mux2 = 1'b1;
    else
        sel_mux2 = 1'b0;
end

endmodule