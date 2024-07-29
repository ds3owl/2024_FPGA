`define SIM
`define CP
module uart_rx (
  clk,
  n_rst,
  uart_rxd,
  rx_data
);

input clk;
input n_rst;
input uart_rxd;

output [7:0]rx_data;

reg rxin_d1;
reg rxin_d2;
reg rxin_d3;
reg start_en;
reg rx_en;
reg [3:0]cnt;
reg clk_rx_en;
reg [3:0]cnt_rx_bit;
reg [7:0]rx_data_n;

//delay
always @(posedge clk or negedge n_rst)
	if(!n_rst) begin
	   rxin_d1 <= 1'b0;
	   rxin_d2 <= 1'b0;
	   rxin_d3 <= 1'b0;
	end
	else begin
	   rxin_d1 <= uart_rxd;
	   rxin_d2 <= rxin_d1;
	   rxin_d3 <= rxin_d2;
	end

//start_en
always @(posedge clk or negedge n_rst)
   if(!n_rst) begin
     start_en <= 1'b0;
   end
  else begin
    if((rxin_d2==1'b0)&&(rxin_d3==1'b1)&&(cnt_rx_bit==4'h0)) begin
      start_en <= 1'b1;
    end
    else begin
      start_en <= 1'b0;
    end
  end

//rx_en
always @(posedge clk or negedge n_rst)
   if(!n_rst) begin
      rx_en <= 1'b0;
   end
   else begin
      rx_en <= (start_en == 1'b1)? 1'b1 : (clk_rx_en == 1'b1 && cnt_rx_bit == 4'hb)? 1'b0 : rx_en;
   end

//cnt
always @(posedge clk or negedge n_rst) 
	if(!n_rst) begin
		cnt <= 4'b0000;
	end
	else begin
		if (rx_en == 1'b1) 
			cnt <= (cnt == 4'h7) ? 4'b0000 : cnt + 4'b0001;
	end
	
//clk_rx_en
always @(posedge clk or negedge n_rst)
  if(!n_rst) begin
    clk_rx_en <= 1'b0;
  end
  else begin
   clk_rx_en <= (cnt == 4'h3)? 1'b1 : 1'b0;
  end

//clk_rx_bit
always@(posedge clk or negedge n_rst)
  if (!n_rst)begin
    cnt_rx_bit <= 4'b0;
  end
  else begin
    if(start_en == 1'b1)
      cnt_rx_bit <= 4'h1;
    else begin
      if((rx_en == 1'b1)&&(clk_rx_en == 1'b1)) begin
        cnt_rx_bit <= cnt_rx_bit + 4'h1;
      end
      else begin
        if(cnt_rx_bit == 4'hc) begin
          cnt_rx_bit <= 4'h0;
        end
        else begin
          cnt_rx_bit <= cnt_rx_bit;
        end
      end
    end
  end


//rx_data_n for rx_data
always @(posedge clk or negedge n_rst)
   if(!n_rst) begin
      rx_data_n <= 8'h00;
   end
   else begin
      if ((rx_en == 1'b1) && (clk_rx_en == 1'b1) && (cnt_rx_bit != 4'h9) && (cnt_rx_bit != 4'ha) && (cnt_rx_bit != 4'hb) && (cnt_rx_bit != 4'hc)) begin
      rx_data_n <= {uart_rxd, rx_data_n[7:1]};
    end
    else begin
      rx_data_n <= rx_data_n;
    end
  end
    
//done
assign done = (cnt_rx_bit == 4'hc)? 1'b1 : 1'b0;

//rx_data
assign rx_data = rx_data_n;

endmodule