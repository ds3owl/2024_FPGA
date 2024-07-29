`timescale 1ns/100ps
`define T_CLK 10

module tb_top;

parameter D_WIDTH = 8;
parameter A_WIDTH = 4;
parameter T_DIV_BIT = 4;
parameter T_DIV_0 = 4'd7;
parameter T_DIV_HALF_0 = 4'd7;
parameter T_DIV_1 = 4'd7;
parameter T_DIV_HALF_1 = 4'd3;
parameter SCLK_HALF = 4'hC;

reg clk;
reg n_rst;
reg rx_done;
reg [D_WIDTH-1:0] rx_data;
reg sw;

wire [D_WIDTH-1:0] fnd_data;

always #(`T_CLK/2) clk = ~clk;

top #(
    .D_WIDTH(D_WIDTH),
    .A_WIDTH(A_WIDTH)
)u_top(
    .clk(clk),
    .n_rst(n_rst),
    .rx_data(rx_data),
    .rx_done(rx_done),
    .sw(sw),
    .fnd_data(fnd_data)
);

initial begin
    clk = 1'b1;
    n_rst = 1'b0;
    rx_done = 1'b0;
    rx_data = 8'h0;  
    sw = 1'b0;
    #(`T_CLK*2.2)n_rst = 1'b1;
end

initial begin
  wait(n_rst == 1'b1);
  #(`T_CLK*SCLK_HALF*4) rx_data = 8'h63;
  #(`T_CLK*SCLK_HALF*1) rx_done = 1'b1;
  #(`T_CLK*1) rx_done = 1'b0;
  #(`T_CLK*SCLK_HALF*1) sw = 1'b1;
  #(`T_CLK*1) sw = 1'b0;
  
  #(`T_CLK*SCLK_HALF*4) rx_data = 8'h35;
  #(`T_CLK*SCLK_HALF*1) rx_done = 1'b1;
  #(`T_CLK*1) rx_done = 1'b0;
  #(`T_CLK*SCLK_HALF*1) sw = 1'b1;
  #(`T_CLK*1) sw = 1'b0;
  
  #(`T_CLK*SCLK_HALF*4) rx_data = 8'h20;
  #(`T_CLK*SCLK_HALF*1) rx_done = 1'b1;
  #(`T_CLK*1) rx_done = 1'b0;
  
  #(`T_CLK*SCLK_HALF*4) rx_data = 8'h63;
  #(`T_CLK*SCLK_HALF*1) rx_done = 1'b1;
  #(`T_CLK*1) rx_done = 1'b0;
  #(`T_CLK*SCLK_HALF*1) sw = 1'b1;
  #(`T_CLK*1) sw = 1'b0;
  
  #(`T_CLK*SCLK_HALF*4) rx_data = 8'h36;
  #(`T_CLK*SCLK_HALF*1) rx_done = 1'b1;
  #(`T_CLK*1) rx_done = 1'b0;
  #(`T_CLK*SCLK_HALF*1) sw = 1'b1;
  #(`T_CLK*1) sw = 1'b0;
  wait (u_top.u_memory_controller.clear == 1'b1);
  
  #(`T_CLK*SCLK_HALF*4) rx_data = 8'h20;
  #(`T_CLK*SCLK_HALF*1) rx_done = 1'b1;
  #(`T_CLK*1) rx_done = 1'b0;
  #(`T_CLK*SCLK_HALF*1) sw = 1'b1;
  #(`T_CLK*1) sw = 1'b0;
  
  #(`T_CLK*SCLK_HALF*4) $stop;
end

endmodule