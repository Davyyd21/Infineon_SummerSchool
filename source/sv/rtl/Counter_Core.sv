`timescale 1ns / 1ps

module Counter_Core(
   input logic [1:0] Mode,
   input logic [9:0] Duty_Cycle,
   input logic [1:0] Frequency_selection,
   input logic [1:0] Trigger_selection,
   input logic Out_function,
   input logic [1:0]Capture_selection,
   input logic [9:0] Target_value,
   output logic [9:0] Counter_value,
   input logic Clear,
   output logic [9:0] Capture_value,
   output logic Timer_Running,
   input logic input_source,
   input logic clock,
   input logic rstn_i,
   output logic out
);
logic pwm;
logic out_counter;
logic out_timer;
logic[9:0] Counter_value_counter,Counter_value_timer;
logic[9:0] Capture_value_counter,Capture_value_timer;

PWM_Mode PWM_Mode(
    .prescale_sel(Frequency_selection),
    .rstn_i(rstn_i),
    .clk_i(clock),
    .duty_cycle_limit(Duty_Cycle),
    .clear(Clear),
    .pwm(pwm)
);

Counter_Mode Counter_Mode(
    .clk_i(clock),
    .rstn_i(rstn_i),
    .input_source(input_source),
    .Trigger_selection(Trigger_selection),
    .Capture_selection(Capture_selection),
    .Out_function(Out_function),      
    .Target_value(Target_value),
    .clear(Clear),
    .counter_value(Counter_value_counter),
    .capture_value(Capture_value_counter),
    .out_counter(out_counter), 
    .timer_running(Timer_running)        
);

Timer_Mode Timer_Mode(
    .clk_i(clock),
    .rstn_i(rstn_i),
    .input_source(input_source),
    .Trigger_selection(Trigger_selection),
    .Capture_selection(Capture_selection),
    .Out_function(Out_function),      
    .Target_value(Target_value),
    .clear(Clear),
    .counter_value(Counter_value_timer),
    .capture_value(Capture_value_timer),
    .out_timer(out_timer),
    .timer_running(Timer_Running)
);

always_comb begin
    case(Mode)
        2'b00:   out = 1'b0;
        2'b01:   out = pwm;
        2'b10:   out = out_counter;
        2'b11:   out = out_timer;   
        default: out = 1'b0;          
    endcase
end


always_comb begin
    case(Mode)
        2'b00:   Counter_value=10'b0;
        2'b01:   Counter_value=10'b0;
        2'b10:   Counter_value=Counter_value_counter;
        2'b11:   Counter_value=Counter_value_timer;   
        default: Counter_value = 1'b0;          
    endcase
end

always_comb begin
    case(Mode)
        2'b00:   Capture_value=10'b0;
        2'b01:   Capture_value=10'b0;
        2'b10:   Capture_value=Capture_value_counter;
        2'b11:   Capture_value=Capture_value_timer;   
        default: Capture_value = 1'b0;          
    endcase 
end
endmodule