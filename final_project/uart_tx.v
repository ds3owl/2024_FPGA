//`define SIM
module uart_tx(
  clk,
  n_rst,
  din,
  start,
  uart_txd,
  clk_tx_en,
  done
  );
  
input clk;
input n_rst;
input [7:0]din;
input start;
output uart_txd;
output clk_tx_en;
output done;

reg tx_en;
reg tx_en_det;
reg [12:0]cnt;
reg [3:0]cnt_bit;
reg [7:0]buffer;
reg clk_tx_en1;
reg uart_txd1;
reg done1;
  
  `ifdef SIM
  parameter MAX = 13'd7;
  parameter T_DIV_BIT    = 4;   //  2-bit
  parameter T_DIV_0      = 4'd15; // 0-15 : 16 // 50 MHz clock -> 9,600 rate
  parameter T_DIV_HALF_0 = 4'd7;  // 0- 7 : 8
  parameter T_DIV_1      = 4'd7;  // 0- 7 : 8  // 50 MHz clock -> 9,600 rate
  parameter T_DIV_HALF_1 = 4'd3;  // 0- 3 : 4
  `else
  // 50 MHz clock -> (1/(d5208)) -> 9,600 rate
  parameter MAX = 13'd5207;
  parameter T_DIV_BIT    = 13;   // 5207 : 13-bit
  parameter T_DIV_0 = 13'd5207; // 0-5207 : 5208  // 50 MHz clock ->  9,600 rate
  parameter T_DIV_HALF_0 = 13'd2603; // 5208/2 = 2604  // 50 MHz clock ->  9,600 rate
  parameter T_DIV_1      = 13'd2603; // 0-2603 : 2604  // 50 MHz clock -> 19,200 rate
  parameter T_DIV_HALF_1 = 13'd1301; // 2604/2 = 1302  // 50 MHz clock -> 19,200 rate
  `endif

//make a tx_en
always @(posedge clk or negedge n_rst) begin
  if(!n_rst) begin
    tx_en_det <= 1'b0;
    tx_en <= 1'b0;
  end
  else begin
    if(start == 1'b1) begin
      tx_en_det <= 1'b1;
    end
    else begin
      if(done == 1'b1) begin
        tx_en_det <= 1'b0;
      end
      else begin
        tx_en <= tx_en_det;
      end
    end
  end
end

//make a cnt
always @(posedge clk or negedge n_rst) begin
  if(!n_rst) begin
    cnt <= 4'h0;
  end
  else begin
    if(tx_en == 1'b1) begin
     cnt <= (cnt == MAX) ? 4'h0 : cnt + 4'h01;
    end
  end
end
   
//make a clk_tx_en1 for clk_tx_en
always @(posedge clk or negedge n_rst) begin
  if(!n_rst) begin
    clk_tx_en1 <= 1'b0;
  end
  else begin
    if(cnt==MAX-1'b1)begin
      clk_tx_en1 <= 1'b1;
    end
    else begin
      clk_tx_en1 <= 1'b0;
    end
  end
end

//make a cnt_bit
always @(posedge clk or negedge n_rst) begin
  if(!n_rst) begin
    cnt_bit <= 4'b0000;
  end
  else begin
    if((cnt_bit == 4'b1011)&&(clk_tx_en == 1'b1)) begin //reset cnt_bit
      cnt_bit <= 4'b0000;
    end
    else begin
      if((tx_en == 1'b1)&&(clk_tx_en == 1'b1)) begin 
      cnt_bit <= cnt_bit + 4'b0001;
      end
      else begin
        cnt_bit <= cnt_bit;
      end
    end
  end
end
      

//makes uart_txd1 & buffer for uart_txd
always @(posedge clk or negedge n_rst) begin
  if(!n_rst) begin
    uart_txd1 <= 1'b1;
    buffer <= 8'b0;
  end
  else begin
    if((tx_en == 1'b1)&&(cnt_bit == 4'b0000)&&(cnt == MAX)) begin //start
      buffer <= din;
      uart_txd1 <= 1'b0;
    end
    else begin//parity
      if((tx_en == 1'b1)&&(cnt_bit == 4'b1001)&&(cnt == MAX)) begin
        uart_txd1 <= 1'b0;
      end
      else begin//stop
        if((tx_en == 1'b1)&&(cnt_bit == 4'b1010)&&(cnt == MAX)) begin
          uart_txd1 <= 1'b1;
        end
        else begin
          if(cnt == MAX)begin
            uart_txd1 <= buffer[0];
            buffer[0] <= buffer[1];
            buffer[1] <= buffer[2];
            buffer[2] <= buffer[3];
            buffer[3] <= buffer[4];
            buffer[4] <= buffer[5];
            buffer[5] <= buffer[6];
            buffer[6] <= buffer[7];
            buffer[7] <= 1'b1;
          end
          else begin
            uart_txd1 <= uart_txd1;
          end
        end
      end
    end
  end
end

//make a done1 for done
always @(posedge clk or negedge n_rst) begin
  if(!n_rst) begin
    done1 <= 1'b0;
  end
  else begin
    if((cnt_bit == 4'b1011)&&(cnt == MAX)) begin
      done1 <= 1'b1;
    end
    else begin
      done1 <= 1'b0;
    end
  end
end

assign clk_tx_en = clk_tx_en1;
assign uart_txd = uart_txd1;
assign done = done1;

endmodule