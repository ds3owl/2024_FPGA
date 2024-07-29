module ram_dual_16x8(
  clk,
  waddr,
  wen,
  wdata,
  raddr,
  rdata
);
parameter D_WIDTH = 8;
parameter A_WIDTH = 4;
//Changed from 5 to 4
//The rest is the same

input clk;
input [A_WIDTH-1:0] waddr;
input wen;
input [D_WIDTH-1:0] wdata;
input [A_WIDTH-1:0] raddr;
output [D_WIDTH-1:0] rdata;

reg [D_WIDTH-1:0] rdata;

reg [D_WIDTH-1:0] ram[2**A_WIDTH-1:0]; 

always @(posedge clk) begin
    if (wen == 1'b1) begin  
        ram[waddr] <= wdata;
    end
    rdata <= ram[raddr];
end

endmodule