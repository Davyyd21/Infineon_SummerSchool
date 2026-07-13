`timescale 1ns / 1ps

// 100 125 200 400    
// 1000

module mux4(
    input logic [1:0]prescale_sel,
    input logic[8:0]limit0,limit1,limit2,limit3,
    output logic[8:0]Np
);

always_comb
begin
    case(prescale_sel)
        2'b00: Np = limit0;
        2'b01: Np = limit1;
        2'b10: Np = limit2;
        2'b11: Np = limit3;
        default: Np = 9'b0;
    endcase
end

endmodule