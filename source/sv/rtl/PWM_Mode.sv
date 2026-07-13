`timescale 1ns / 1ps

module PWM_Mode(
    input logic [1:0]prescale_sel,
    input logic rstn_i,
    input logic clk_i,
    input logic[9:0]duty_cycle_limit,
    input logic clear,
    output logic pwm
);

logic[8:0]Np;
logic prescaler;
logic[9:0]in;
logic[9:0]count;
logic sel_mux2;
mux4 u_mux4(
    .prescale_sel(prescale_sel),
    .limit0(98),
    .limit1(122),
    .limit2(196),
    .limit3(392),
    .Np(Np)
);

prescaler u_prescaler(
    .limit_f1(Np),
    .rstn(rstn_i),
    .clk(clk_i),
    .prescaler(prescaler)
);

register_N u_register_N(
    .clk(clk_i),
    .rstn(rstn_i),
    .en(prescaler),
    .clear(clear),
    .out(count)
);

comp_eq u_comp_eq(
    .out_register(count),
    .limit_f2(1023),
    .sel_mux2(sel_mux2)
);

mux2_pwm mux2_pwm(
    .sel(sel_mux2),
    .in0(10'b0),
    .in1(count + 1'b1),
    .out(in)
);

comp_lt u_comp_lt(
    .count(count),
    .duty_cycle_limit(duty_cycle_limit),
    .pwm(pwm)
);


endmodule