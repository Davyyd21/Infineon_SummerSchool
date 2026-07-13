`timescale 1ns / 1ps

module Timer_Mode(
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
    output logic out_timer,
    output logic timer_running
);

    logic rise_event, fall_event;
    logic start_event, capture_event;
    logic counting;
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
            2'b00: start_event = rise_event;
            2'b01: start_event = fall_event;
            2'b10: start_event = rise_event | fall_event;
            default: start_event = 1'b0; // 2'b11 = none
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

    assign target_reached=(counter_value == Target_value);

    always_ff @(posedge clk_i or negedge rstn_i) begin
        if (!rstn_i) begin
            counter_value <= 10'b0;
            counting      <= 1'b0;
        end
        else if (clear) begin
            counter_value <= 10'b0;
            counting      <= 1'b0;
        end
        else if (start_event) begin
            counter_value <= 10'd1;
            counting      <= 1'b1;
        end
        else if (counting) begin
            if (counter_value == Target_value) begin
                counter_value <= 10'b0;
                counting      <= 1'b0;  
            end
            else begin
                counter_value <= counter_value + 1'b1;  
            end
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
            out_timer <= 1'b0;
        else if (clear)
            out_timer <= 1'b0;
        else if (target_reached) begin // cand ne atingem target-ul vrem un impuls sau un toggle pe iesire
            if (Out_function == 1'b0)
                out_timer <= 1'b1;    //sunt in modul impuls      
            else
                out_timer <= ~out_timer;  //sunt in modul toggle
        end
        else if (Out_function == 1'b0) begin
            out_timer <= 1'b0;              //sunt in modul impuls si aduc iesirea la 0 din nou dupa ce a fost 1 o perioada pentru a crea impulsul
        end
    end
assign timer_running = counting;
endmodule