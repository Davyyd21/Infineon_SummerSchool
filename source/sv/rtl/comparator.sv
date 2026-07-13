`timescale 1ns / 1ps

module comparator(
        input logic [3:0] input_selection,
        input logic [3:0] input0_i,
        output logic out
);
always_comb begin
    if(input0_i == input_selection) begin
        out = 1'b1;
    end else begin
        out = 1'b0;
    end
end


endmodule