module top(
  clk,
  n_rst,
  rx_done,
  rx_data,
  sw,
  fnd_data   
);

parameter D_WIDTH = 8;
parameter A_WIDTH = 4;

input clk; 
input n_rst;
input rx_done;
input [D_WIDTH-1:0] rx_data;
input sw;
output [D_WIDTH-1:0] fnd_data;

wire [A_WIDTH-1:0] waddr_w;
wire wen_w;
wire [D_WIDTH-1:0] wdata_w;
wire [A_WIDTH-1:0] raddr_w;
wire [D_WIDTH-1:0]  rdata_w;

memory_controller u_memory_controller(
  .clk(clk),
  .n_rst(n_rst),
  .rx_done(rx_done),
  .rx_data(rx_data),
  .ren(sw),
  .waddr(waddr_w),
  .wen(wen_w),
  .wdata(wdata_w),
  .raddr(raddr_w),
  .rdata(rdata_w),
  .fnd_data(fnd_data)
);

ram_dual_16x8 u_ram_dual_16x8(
  .clk(clk),
  .wdata(wdata_w),
  .waddr(waddr_w),
  .wen(wen_w),
  .raddr(raddr_w),
  .rdata(rdata_w)
);

endmodule