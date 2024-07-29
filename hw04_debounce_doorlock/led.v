module led(
  clk,
  n_rst,
  din,
  dout
  );

input clk;
input n_rst;
input din;
output reg dout;

parameter T_1S = 26'h2FA_F080; 
reg [25:0] counter = 0; 
reg din_prev; 

always @(posedge clk or negedge n_rst) begin
  if (!n_rst) begin
    counter <= 0;
    dout <= 0;
    din_prev <= 0;
  end 
  else begin
    // din ??? ?? ??
    if (din != din_prev) begin
      counter <= 0; // ??? ??
      dout <= 1; // dout ??? 0?? ???
    end 
    else if (counter >= T_1S) begin
      // 1?? ???? dout? 1? ??
      dout <= 0;
      counter <= counter; // ???? ??? ??
    end 
    else begin
      counter <= counter + 1; // ??? ??
    end
    
    din_prev <= din; // ?? din ?? ??? ??
  end
end
endmodule