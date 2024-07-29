module top(
  clk,
  n_rst,
  n_start,
  sclk,
  cs_n,
  sdata,
  uart_txd,
  led,
  slide
);

input clk;
input n_rst;
input n_start;
output sclk;
output cs_n;
input sdata;
output uart_txd;
output [7:0] led;
input [8:0]slide;

`ifdef SIM
parameter T_DIV_BIT    = 4;   //  2-bit
parameter T_DIV_0      = 4'd15; // 0-15 : 16 // 50 MHz clock -> 9,600 rate
parameter T_DIV_HALF_0 = 4'd7;  // 0- 7 : 8
parameter T_DIV_1      = 4'd7;  // 0- 7 : 8  // 50 MHz clock -> 9,600 rate
parameter T_DIV_HALF_1 = 4'd3;  // 0- 3 : 4
`else
// 50 MHz clock -> (1/(d5208)) -> 9,600 rate
parameter T_DIV_BIT    = 13;   // 5207 : 13-bit
parameter T_DIV_0      = 13'd5207; // 0-5207 : 5208  // 50 MHz clock ->  9,600 rate
parameter T_DIV_HALF_0 = 13'd2603; // 5208/2 = 2604  // 50 MHz clock ->  9,600 rate
parameter T_DIV_1      = 13'd5207; // 0-2603 : 2604  // 50 MHz clock -> 19,200 rate
parameter T_DIV_HALF_1 = 13'd1301; // 2604/2 = 1302  // 50 MHz clock -> 19,200 rate
`endif

parameter SCLK_HALF = 4'hC;

wire next_start1;
wire next_start2;
wire [7:0] select_data;
wire [7:0] data_w1;
wire [7:0] data_w2;
wire done;

assign select_data = (slide[8] == 1'b0) ? data_w2 : slide[7:0];

spi_master u_spi_master(
  .clk(clk),
  .n_rst(n_rst),
  .n_start(n_start),
  .done(next_start1),
  .led(data_w1),
  .sclk(sclk),
  .cs_n(cs_n),
  .sdata(sdata)
);

byte2ascii u_byte2ascii(
  .clk(clk),
  .n_rst(n_rst),
  .start(next_start1),
  .data_in(data_w1),
  .uart_start(next_start2),
  .data_out(data_w2),
  .rx_done(done)
);

uart_tx u_uart_tx(
  .clk(clk), 	
	.n_rst(n_rst),
	.start(next_start2),
	.din(select_data),
	.uart_txd(uart_txd_n),
	.done(done)
);

assign uart_txd = ~uart_txd_n;
assign led = select_data;

endmodule