interface ifx_dig_interface (
    input bit clk_i,
    output bit rstn_i,

    input bit acc_en_i,
    input bit wr_en_i,
    input bit [`AWIDTH-1:0] addr_i,
    input bit [`DWIDTH-1:0] wdata_i,
    input bit [`DWIDTH-1:0] rdata_o,

    output bit [`EXT_INPUTS_NB-1:0] inputs_i,
    input bit output_o
);

  property outputs_reset_value_p;
    @(posedge clk_i)
    $rose(rstn_i) |=> (rdata_o == '0 && output_o == 1'b0);
  endproperty

  outputs_reset_value_a:
    assert property(outputs_reset_value_p)
    else
      $error("Outputs do not have the correct reset values");

  initial begin
    inputs_i = '0;
  end

endinterface