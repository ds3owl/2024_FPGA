`define T_CLK 10
module tb_top;


  // Testbench signals
  reg clk;
  reg n_rst;
  reg n_start;
  reg [1:0] slide;
  reg baudrate;
  wire uart_txd_n;
  wire [1:0] led;
  wire clk_tx_en;


  // Instantiate the top module
  top uut (
      .clk(clk),
      .n_rst(n_rst),
      .n_start(n_start),
      .slide(slide),
      .uart_txd_n(uart_txd_n),
      .led(led)
  );

  // Clock generation
  always begin
    #(`T_CLK / 2) clk = ~clk;
  end

  // Testbench procedure
  initial begin
    // Initialize inputs
    clk = 0;
    n_rst = 1;
    n_start = 0;
    slide = 2'b00;
    baudrate = 0;

    // Apply reset
    #10;
    n_rst = 0;
    #20;
    n_rst = 1;

    // Wait for the system to stabilize
    #50;

    // Start simulation with various test cases

    // Test case 1: Baud rate 9600, slide to 00, start
    baudrate = 0;
    slide = 2'b00;
    #100;
    n_start = 1;
    #20;
    n_start = 0;

    // Wait for transmission to complete
    wait (led == 2'b00);
    #2000;

    // Test case 2: Baud rate 9600, slide to 01, start
    slide = 2'b01;
    #100;
    n_start = 1;
    #20;
    n_start = 0;

    // Wait for transmission to complete
    wait (led == 2'b01);
    #2000;

    // Test case 3: Baud rate 9600, slide to 10, start
    slide = 2'b10;
    #100;
    n_start = 1;
    #20;
    n_start = 0;

    // Wait for transmission to complete
    wait (led == 2'b10);
    #2000;

    // Test case 4: Baud rate 19200, slide to 11, start
    baudrate = 1;
    slide = 2'b11;
    #100;
    n_start = 1;
    #20;
    n_start = 0;

    // Wait for transmission to complete
    wait (led == 2'b11);
    #2000;

    // Finish simulation
    $stop;
  end

  // Monitor for debug purposes
  initial begin
    $monitor("Time=%0d, clk=%b, n_rst=%b, n_start=%b, slide=%b, baudrate=%b, uart_txd_n=%b, led=%b", 
             $time, clk, n_rst, n_start, slide, baudrate, uart_txd_n, led);
  end

endmodule