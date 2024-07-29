`timescale 1ns/1ps
`define T_CLK 20
module tb_spi_adc;

parameter SCLK_HALF = 4'hC;
reg clk, n_rst;
reg n_rst_slave;

initial begin
  n_rst = 1'b0;
  clk = 1'b1;
  #(`T_CLK*2.2) n_rst = 1'b1;
end
always #(`T_CLK/2) clk = ~clk;

reg start;
wire sclk, cs_n;
wire [7:0] led;
reg [7:0] data;
integer i;

initial begin
  n_rst_slave = 1'b0;
  start = 1'b0;
  data = 8'h00;

  wait(n_rst == 1'b1);
  n_rst_slave = 1'b1;
  for (i=8'hC5; i<8'hC9;i=i+1) begin
    #(`T_CLK*SCLK_HALF*9) data = i;
    #(`T_CLK*1) n_rst_slave = 1'b0;
    #(`T_CLK*1) n_rst_slave = 1'b1;
    #(`T_CLK*1) start = 1'b1;
    #(`T_CLK*1) start = 1'b0;

    wait (cs_n == 1'b0);
    $display("spi start");
    wait (cs_n == 1'b1);
    $display("spi end");
  end
  #(`T_CLK * SCLK_HALF*4) $stop;
end

spi_master_adc #(.SCLK_HALF(SCLK_HALF)) u_spi_master_adc(
  .clk(clk),
  .n_rst(n_rst),
  .n_start(~start),
  .sclk(sclk),
  .cs_n(cs_n),
  .sdata(sdata), // Master-In Slave-Out
  .led(led)
);

spi_slave_adc u_spi_slave_adc(
  .n_rst(n_rst_slave),
  .data(data),
  .sclk(sclk),
  .cs_n(cs_n),
  .sdata(sdata) // output
);

endmodule