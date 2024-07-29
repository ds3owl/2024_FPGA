module top(
  clk,
  n_rst,
  n_start,
  sclk,
  cs_n,
  sdata,
  slide,
  data
  );

input clk;
input n_rst;
input n_start;
input sdata;
input [8:0]slide;
output sclk;
output cs_n;
output [7:0]data;

wire next_start1;
wire next_start2;
wire [7:0]data_w1;
wire [7:0]data_w2;

reg [7:0]slide_data;
reg [7:0]cs_data;

//make a slide_data with slide button
always @(posedge clk or negedge n_rst)
  if(!n_rst) begin
    slide_data <= 8'b0000_0000;
  end
  else begin 
    slide_data <= {slide[7],slide[6],slide[5],slide[4],slide[3],slide[2],slide[1],slide[0]};
  end

//choose between slide_data and data_w2
always @(posedge clk or negedge n_rst)
  if(!n_rst) begin
    cs_data <= 8'b0000_0000;
  end
  else begin
    if(slide[8] == 1'b0) begin
      cs_data <= data_w2;
    end
    else begin
      if(slide[8] == 1'b1) begin
        cs_data <= slide_data;
      end
      else begin
        cs_data <= cs_data;
      end
    end
  end

spi_master_adc u_spi_master(
    .clk(clk),
    .n_rst(n_rst),
    .n_start(n_start),
    .sclk(sclk),
    .cs_n(cs_n),
    .sdata(sdata),
    .next_start(next_start1),
    .data(data_w1)
);

byte2ascii u_byte2ascii(
  .start(next_start),
  .data_in(data_w1),
  .uart_start(next_start2),
  .data_out(data_w2)
  );
  
uart_tx u_uart_tx(
  .clk(clk),
  .n_rst(n_rst),
  .din(cs_data),//input choosing data
  .start(next_start2),
  .uart_txd(uart_txd),
  .clk_tx_en(clk_tx_en),
  .done(done)
  );

endmodule