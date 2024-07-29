module memory_controller(
  clk,
  n_rst,
  rx_done,
  rx_data,
  wdata,
  waddr,
  wen,
  raddr,
  ren,
  rdata,
  fnd_data
);

parameter D_WIDTH = 8;
parameter A_WIDTH = 4;

input clk;
input n_rst;
input rx_done;
input [D_WIDTH-1:0] rx_data;
output [D_WIDTH-1:0] wdata;
output [A_WIDTH-1:0] waddr;
output wen;
output [A_WIDTH-1:0] raddr;
input ren;
input [D_WIDTH-1:0] rdata;
output [D_WIDTH-1:0] fnd_data;

reg [A_WIDTH-1:0] waddr;
reg [A_WIDTH-1:0] raddr;
reg [D_WIDTH-1:0] fnd_data;

wire clear;

reg [A_WIDTH-1:0] raddr_3to0;

//wdata
assign wdata = rx_data;

//wen
assign wen = (rx_done == 1'b1) && (waddr != {{(A_WIDTH-1){1'b0}},3'b100})? 1'b1 : 1'b0;

//clear
assign clear = ((raddr == {(A_WIDTH){1'b0}}) && (raddr_3to0 == {{(A_WIDTH-2){1'b0}}, 2'b11})) ? 1'b1 : 1'b0;

//waddr
always @(posedge clk or negedge n_rst)
    if (!n_rst) begin
      waddr <= {(A_WIDTH){1'b0}};
    end
    else begin
      if (clear == 1'b1) begin
         waddr <= {(A_WIDTH){1'b0}};
      end
      else if (wen == 1'b1) begin
        waddr <= (waddr < {{(A_WIDTH-1){1'b0}},3'b100}) ? waddr + 1'b1 : waddr;
      end
    end

//raddr_3to0 for making clear
always @(posedge clk or negedge n_rst)
    if(!n_rst) begin
      raddr_3to0 <= {(A_WIDTH){1'b0}};
    end
    else begin
      raddr_3to0 <= raddr;
    end

//raddr
always @(posedge clk or negedge n_rst)
  if(!n_rst) begin
    raddr <= {(A_WIDTH){1'b0}};
  end
  else begin
    if ((ren == 1'b1) && (raddr <= {{(A_WIDTH-2){1'b0}}, 2'b10})) begin
      raddr <= raddr + {{(A_WIDTH-1){1'b0}},1'b1};
    end 
    else if ((raddr == {{(A_WIDTH-2){1'b0}}, 2'b11}) && (ren == 1'b1)) begin
      raddr <= {(A_WIDTH){1'b0}};
    end
    else begin 
      raddr <= raddr;
    end
  end

//fnd_data for making fnd
always @(posedge clk or negedge n_rst)
  if(!n_rst) begin
    fnd_data <= {(D_WIDTH){1'b0}};
  end
  else begin
    if (ren == 1'b1) begin
      fnd_data <= rdata;
    end
    else begin
      fnd_data <= fnd_data;
    end
  end

endmodule