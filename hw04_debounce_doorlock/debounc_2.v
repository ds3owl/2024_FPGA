module debounc_2 (
	clk,
	n_rst,
	din,
	dout
);
parameter T_20MS = 20'hF_4240; // d1_000_000;

input clk;
input n_rst;
input din;
output dout;

reg [19:0] cnt;
wire cnt_restart;

reg din_d1;

always @(posedge clk or negedge n_rst)
	if(!n_rst) begin
		din_d1 <= 1'b0;
	end
	else begin
		din_d1 <= din;
	end

assign cnt_restart = (din != din_d1)? 1'b1 : 1'b0;

always @(posedge clk or negedge n_rst)
	if(!n_rst) begin
		cnt <= 20'h0_0000;
	end
	else begin
		 cnt <= ((cnt_restart == 1'b1) && (cnt == 20'h0_0000))? T_20MS :
            (cnt > 20'h0_0000)? cnt - 20'h0_0001 : cnt;
//If restar is 1 and cnt is 0, start the counter
//The rest is the same as debounc_1


	end

reg dout_rdy;

always @(posedge clk or negedge n_rst)
   if(!n_rst) begin
      dout_rdy <= 1'b0;
   end
   else begin
      dout_rdy <= (cnt == T_20MS)? din_d1 : dout_rdy;
   end   assign dout = dout_rdy;
//debouncing2 requires dout to go up as soon as restart starts.
//When cnt becomes T_20MS, the condition is satisfied, so dout is determined based on that condition.
endmodule

