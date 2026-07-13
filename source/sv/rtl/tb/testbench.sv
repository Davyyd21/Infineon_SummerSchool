`timescale 1ns / 1ps

module testbench();
logic clk_i;
logic rstn_i;
logic acc_en_i;
logic wr_en_i;
logic [2:0] addr_i;
logic [15:0] wdata_i;
logic [15:0] rdata_o;
logic input1_i;
logic input2_i;
logic input3_i;
logic input4_i;
logic input5_i;
logic input6_i;
logic input7_i;
logic input8_i;
logic input9_i;
logic input10_i;
logic input11_i;
logic input12_i;
logic input13_i;
logic input14_i;
logic input15_i;
logic out_o;


TOP dut(
   .clk_i(clk_i),
   .rstn_i(rstn_i),
   .acc_en_i(acc_en_i),
   .wr_en_i(wr_en_i),
   .addr_i(addr_i),
   .wdata_i(wdata_i),
   .rdata_o(rdata_o),
   .input1_i(input1_i),
   .input2_i(input2_i),
   .input3_i(input3_i),
   .input4_i(input4_i),
   .input5_i(input5_i),
   .input6_i(input6_i),
   .input7_i(input7_i),
   .input8_i(input8_i),
   .input9_i(input9_i),
   .input10_i(input10_i),
   .input11_i(input11_i),
   .input12_i(input12_i),
   .input13_i(input13_i),
   .input14_i(input14_i),
   .input15_i(input15_i),
   .out_o(out_o)
);


initial begin
    clk_i = 0;
    forever #2 clk_i = ~clk_i; // Clock period of 10 time units
end


    initial begin

    input1_i  = 0;
    input2_i  = 0;
    input3_i  = 0;
    input4_i  = 0;
    input5_i  = 0;
    input6_i  = 0;
    input7_i  = 0;
    input8_i  = 0;
    input9_i  = 0;
    input10_i = 0;
    input11_i = 0;
    input12_i = 0;
    input13_i = 0;
    input14_i = 0;
    input15_i = 0;


    rstn_i = 0;
    acc_en_i = 0;
    wr_en_i = 0;
    addr_i = 3'b000;
    wdata_i = 16'd0;

    #5;
    rstn_i=1;

    acc_en_i = 1;
    wr_en_i = 1;
    addr_i = 3'b000;
    wdata_i = 16'b0000_0000_0000_0010;
    #4;
    addr_i=3'b011;
    wdata_i = 16'd8;
    #4;
    addr_i=3'b010;
    wdata_i = 16'b0010_0000_0010_0001;
    #4;

    acc_en_i = 0;
    wr_en_i = 0;

    #10;
    input1_i = 1;

    #10;
    input1_i = 0;

    #20;
    input1_i = 1;

    #20;
    input1_i = 0;
    #20;
    input1_i = 1;
    #20;
    input1_i = 0;
    #20;
    input1_i = 1;
    #20;
    input1_i = 0;
    #20;
    input1_i = 1;
    #20;
    input1_i = 0;
    #20;
    input1_i = 1;
    #20;
    input1_i = 0;
    #20;
    input1_i = 1;
    #100;
    $finish;

end




endmodule