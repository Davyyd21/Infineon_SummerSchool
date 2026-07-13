`timescale 1ns / 1ps

module register_block(
   input logic clk_i,
   input logic rstn_i,
   input logic acc_en_i,
   input logic wr_en_i,
   input logic [2:0] addr_i,
   input logic [15:0]wdata_i,
   output logic [15:0]rdata_o,
   output logic [3:0]input_selection,
   output logic sw_trigger,
   output logic [1:0] Mode,
   output logic [9:0] Duty_Cycle,
   output logic [1:0] Frequency_selection,
   output logic [1:0] Trigger_selection,
   output logic Out_function,
   output logic [1:0]Capture_selection,
   output logic [9:0] Target_value,
   input logic [9:0] Counter_value,
   output logic Clear,
   input logic [9:0] Capture_value,
   input logic Timer_Running
);

logic [15:0] CTRL0;
logic [15:0] PWM_MODE;
logic [15:0] CNT_MODE0;
logic [15:0] CNT_MODE1;
logic [15:0] COUNTER_VALUE;
logic [15:0] COMMAND;
logic [15:0] CAPTURE_VALUE;

always_ff @(posedge clk_i or negedge rstn_i) 
begin
    if(!rstn_i) 
    begin
        CTRL0 <= 16'h0000;
        PWM_MODE <= 16'h0000;
        CNT_MODE0 <= 16'h0000;
        CNT_MODE1 <= 16'h0000;
        // COUNTER_VALUE <= 16'h0000;
        // COMMAND <= 16'h0000;
        // CAPTURE_VALUE <= 16'h0000;
    end 

    else if(acc_en_i && wr_en_i)
    begin
        case(addr_i)
            3'b000: CTRL0 <={14'b0, wdata_i[1:0]};
            3'b001: PWM_MODE <= {2'b0,wdata_i[13:12],2'b0,wdata_i[9:0]};
            3'b010: CNT_MODE0 <= {2'b0,wdata_i[13:12],3'b0,wdata_i[8],2'b0,wdata_i[5:0]};
            3'b011: CNT_MODE1 <= {6'b0,wdata_i[9:0]};
            // 3'b100: COUNTER_VALUE <= wdata_i;
            3'b101: COMMAND <= {11'b0,wdata_i[4],wdata_i[3:1],wdata_i[0]};
            // 3'b110: CAPTURE_VALUE <= wdata_i;
            default: ;
        endcase
    end
end

always_ff @(posedge clk_i or negedge rstn_i)
begin
    if(!rstn_i)
    begin
        rdata_o <= 16'h0000;
    end
    else if(acc_en_i && !wr_en_i)
    begin
        case(addr_i)
            3'b000: rdata_o <= CTRL0;
            3'b001: rdata_o <= PWM_MODE;
            3'b010: rdata_o <= CNT_MODE0;
            3'b011: rdata_o <= CNT_MODE1;
            3'b100: rdata_o <= COUNTER_VALUE;       
            3'b101: rdata_o <= COMMAND;
            3'b110: rdata_o <= CAPTURE_VALUE;
            default: rdata_o <= 16'h0000;
        endcase
    end
end

assign Mode = CTRL0[1:0];
assign Duty_Cycle = PWM_MODE[9:0];
assign Frequency_selection = PWM_MODE[13:12];
assign Trigger_selection = CNT_MODE0[5:4];
assign input_selection = CNT_MODE0[3:0];
assign Out_function = CNT_MODE0[8];
assign Capture_selection = CNT_MODE0[13:12];
assign Target_value = CNT_MODE1[9:0];
assign COUNTER_VALUE = {6'b0, Counter_value};
assign Clear = COMMAND[0];
assign sw_trigger = COMMAND[4];
assign CAPTURE_VALUE = {3'b0, Timer_Running, 2'b0, Capture_value};
endmodule

