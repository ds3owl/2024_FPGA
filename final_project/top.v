//`define SIM
module top (
    input clk,
    input n_rst,
    input n_start,
    input [1:0] slide,
    output uart_txd_n,
    output [1:0]led,
    output [6:0]fnd0,
    output [6:0]fnd2,
    output clk_tx_en
);

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
  parameter T_DIV_1      = 13'd2603; // 0-2603 : 2604  // 50 MHz clock -> 19,200 rate
  parameter T_DIV_HALF_1 = 13'd1301; // 2604/2 = 1302  // 50 MHz clock -> 19,200 rate
  `endif

    wire [7:0] data_out;
    wire next_start;
    wire uart_txd;
    wire done;
    
    assign led = {slide[0],slide[1]};
    
    assign fnd0 = (slide[0] == 1'b0) ? 7'b1000110 : 7'b0001001;//Cold or Hot
    assign fnd2 = (slide[1] == 1'b0) ? 7'b0010010 : 7'b0001110;//Slow or Fast
    
    hairdryer u_hairdryer (
        .clk(clk),
        .n_rst(n_rst),
        .slide(slide),
        .btstart(n_start),
        .done(done),
        .uart_start(next_start),
        .data_out(data_out)
    );

    uart_tx #(
        .T_DIV_BIT(T_DIV_BIT),
        .T_DIV_0(T_DIV_0),
        .T_DIV_HALF_0(T_DIV_HALF_0),
        .T_DIV_1(T_DIV_1),
        .T_DIV_HALF_1(T_DIV_HALF_1)
    ) u_uart_tx (
        .clk(clk),
        .n_rst(n_rst),
        .start(next_start),
        .din(data_out),
        .uart_txd(uart_txd),
        .done(done),
        .clk_tx_en(clk_tx_en)
    ); 
    
    assign uart_txd_n = ~uart_txd;  

endmodule