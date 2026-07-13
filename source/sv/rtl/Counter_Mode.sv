`timescale 1ns / 1ps

module Counter_Mode(
    input  logic clk_i,
    input  logic rstn_i,
    input  logic input_source,
    input  logic [1:0] Trigger_selection,
    input  logic [1:0] Capture_selection,
    input  logic Out_function,      
    input  logic [9:0] Target_value,
    input  logic clear,
    output logic [9:0] counter_value,
    output logic [9:0] capture_value,
    output logic out_counter,
    output logic timer_running
);

    logic rise_event, fall_event;
    logic event_detected, capture_event;
    logic target_reached;   

    EdgeDetection EdgeDetection(
        .clk_i(clk_i),
        .rstn_i(rstn_i), 
        .input_source(input_source),
        .rise_event(rise_event), 
        .fall_event(fall_event)
    );

    always_comb begin
        case(Trigger_selection)
            2'b00: event_detected = rise_event;
            2'b01: event_detected = fall_event;
            2'b10: event_detected = rise_event | fall_event;
            default: event_detected = 1'b0;
        endcase
    end

    always_comb begin
        case(Capture_selection)
            2'b00: capture_event = rise_event;
            2'b01: capture_event = fall_event;
            2'b10: capture_event = rise_event | fall_event;
            default: capture_event = 1'b0;
        endcase
    end

    assign target_reached = (counter_value == Target_value);

    always_ff @(posedge clk_i or negedge rstn_i) begin
        if (!rstn_i)
            counter_value <= 10'b0;
        else if (clear)
            counter_value <= 10'b0;
        else if (counter_value == Target_value) 
                counter_value <= 10'b0;
        else if(event_detected)begin
                counter_value <= counter_value + 1'b1;
                timer_running <= 1;
        end
        end

    always_ff @(posedge clk_i or negedge rstn_i) begin
        if (!rstn_i)
            capture_value <= 10'b0;
        else if (capture_event)
            capture_value <= counter_value;
    end

    always_ff @(posedge clk_i or negedge rstn_i) begin
        if (!rstn_i)
            out_counter <= 1'b0;
        else if (clear)
            out_counter<= 1'b0;
        else if (target_reached) begin
            if (Out_function == 1'b0)
                out_counter <= 1'b1;          
            else
                out_counter <= ~out_counter;  
        end
        else if (Out_function == 1'b0) begin
            out_counter <= 1'b0;              
        end
    end

endmodule