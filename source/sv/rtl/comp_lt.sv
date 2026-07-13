`timescale 1ns / 1ps

module comp_lt(
    input logic[9:0]count,
    input logic[9:0]duty_cycle_limit,
    output logic pwm
);
always_comb
begin
    if(count < duty_cycle_limit)
        pwm = 1'b1;
    else
        pwm = 1'b0; 
end

endmodule