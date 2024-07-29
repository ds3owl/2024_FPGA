`timescale 1ns/1ps
`define T_CLK 20

module tb_uart_tx;
`ifdef SIM
parameter T_DIV = 13'd7; // 0- 7 : 8 
parameter T_DIV_HALF = 13'd3; // 0- 3 : 4
`else
// 50 MHz clock -> (1/(d5208)) -> 9,600 rate
parameter T_DIV = 13'd5207; 
parameter T_DIV_HALF = 13'd2603; 
`endif

reg clk, n_rst, start, tx_en;
reg [7:0] din;
wire uart_txd, clk_tx_en, done;

initial begin
 n_rst = 1'b0;
 clk = 1'b1;
 #(`T_CLK*2.2) n_rst = 1'b1;
end
always #(`T_CLK/2) clk = ~clk;
initial begin

start = 1'b0;
din = 12'h0;
#(`T_CLK *10);
#(`T_CLK*1) din = 8'b0011_0111;
start = 1'b1;
#(`T_CLK*1) start = 1'b0;
#(`T_CLK *100);
#(`T_CLK*1) din = 8'b0010_0000;
start = 1'b1;
#(`T_CLK*1) start = 1'b0;
#(`T_CLK *100);
#(`T_CLK * 5) $stop;
end

uart_tx u_uart_tx(
.clk(clk),
.n_rst(n_rst),
.din(din),
.start(start),
.uart_txd(uart_txd),
.clk_tx_en(clk_tx_en),
.done(done)
);

endmodule