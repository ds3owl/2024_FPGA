module spi_master_adc(
    clk,
    n_rst,
    n_start,
    sclk,
    cs_n,
    sdata,
    led
);

input clk;
input n_rst;
input n_start;
input sdata;
output cs_n;
output reg sclk;
output [7:0] led;

reg sclk_rise;
reg [4:0] cnt;
reg [4:0] cnt_sclk;
reg [7:0] ledd;
reg cs;
reg b0_d1;
reg b0_d2;
wire b0_on;

parameter SCLK_HALF = 4'hC;

//make a cnt
always @(posedge clk or negedge n_rst) begin
    //cnt reset
    if(!n_rst) begin
        cnt <= 5'b00000;
    end
    else begin
      //cs_n == 0 & cnt < 12
      if((!cs_n)&&(cnt < 5'b01100)) begin
        cnt <= cnt + 5'b00001;
      end
      //cs_n == 1 or cnt >= 12
      else begin
        cnt <= 5'b00000;
      end
    end
end

//make a sclk
always @(posedge clk or negedge n_rst) begin
    if(!n_rst) begin
      //sclk reset
      sclk <= 1'b1;
    end
    else begin
      if(cnt == 5'b01100) begin
        //reverse sclk when cnt == 12 
        sclk <= ~sclk;
      end
      else begin
        //maintaining sclk
        sclk <= sclk;
      end
    end
  end
  
//make a cnt_sclk
always @(posedge clk or negedge n_rst) begin
  if(!n_rst) begin
    //cnt_sclk reset
    cnt_sclk <= 1'b0;
  end
  else begin
    if(cnt == 5'b01100 && sclk == 1'b0) begin
      //increase cnt_sclk if the condition is true
      cnt_sclk <= cnt_sclk + 1'b1;
    end
    else begin
      if(cnt_sclk == 5'b10000) begin
        //reset the cnt_sclk when it reaches the full count
        cnt_sclk <= 5'b00000;
      end
      else begin
        //maintaining cnt_sclk
        cnt_sclk <= cnt_sclk;
      end
    end
  end
end

//make a cs for cs_n
always @(posedge clk or negedge n_rst) begin
  if(!n_rst) begin
    //cs reset
    cs <= 1'b1;
  end
  else begin
    //if the n_start button is pressed, output 0
    //if the cnt_sclk reaches the full count, output 1
    //otherwise, maintain the current output
    cs <= (b0_on == 1'b1) ? 1'b0 :(cnt_sclk == 5'b10000) ? 1'b1 : cs;               
  end
end

//make a sclk_rise
always @(posedge clk or negedge n_rst) begin
  if(!n_rst) begin
    //sclk_rise reset
    sclk_rise <= 1'b0;
  end
  else begin
    if(cnt == 5'b01011 && sclk == 1'b0) begin
      //set sclk to 1 right before sclk goes high
      sclk_rise <= 1'b1;
    end
    else begin
      //maintain sclk_rise at 0 normally
      sclk_rise <= 1'b0;
    end
  end
end

//make a ledd for led
always @(posedge clk or negedge n_rst) begin
  if(!n_rst) begin
    //ledd reset
    ledd <= 8'b00000000;
  end
  else begin
    if(sclk_rise == 1'b1 && cnt_sclk < 5'b01011)begin
      //shift the ledd left, then assign the value of sdata to ledd[0]
      ledd[7] <= ledd[6];
      ledd[6] <= ledd[5];
      ledd[5] <= ledd[4];
      ledd[4] <= ledd[3];
      ledd[3] <= ledd[2];
      ledd[2] <= ledd[1];
      ledd[1] <= ledd[0];
      ledd[0] <= sdata;
    end
    else begin
      //maintain ledd nomally
      ledd <= ledd;
    end
  end
end

//make a edge_det for n_start
//referenced in Week 4 assignment
always @(posedge clk or negedge n_rst) begin
  if(!n_rst) begin
    b0_d1 <= 1'b0;
    b0_d2 <= 1'b0;
  end
  else begin
    b0_d1 <= n_start;
    b0_d2 <= b0_d1;
  end
end 
    
//cs -> cs_n
assign cs_n = cs;
//ledd -> led
assign led = ledd;
//indicate that the button has been pressed once
assign b0_on = (!b0_d1 && b0_d2) ? 1'b1 : 1'b0;

endmodule

