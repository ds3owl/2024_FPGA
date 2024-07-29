`timescale 1ns/10ps
`define T_CLK 10
module tb_doorlock_hdl;
reg clk;
reg n_rst;
initial begin
clk = 1'b1;
n_rst = 1'b0;
#(`T_CLK*2.2) n_rst = 1'b1;
end
always #(`T_CLK/2) clk = ~clk;
reg [9:0] bt;
reg btstar;
wire led;

initial begin
bt = 10'h000;
btstar = 1'b0;

wait(n_rst == 1'b1);
#(`T_CLK*1) bt[1] = 1'b1;
#(`T_CLK*1) bt[1] = 1'b0;
#(`T_CLK*1) bt[2] = 1'b1;
#(`T_CLK*1) bt[2] = 1'b0;
#(`T_CLK*1) bt[7] = 1'b1;
#(`T_CLK*1) bt[7] = 1'b0;
#(`T_CLK*1) btstar = 1'b1;
#(`T_CLK*1) btstar = 1'b0;

#(`T_CLK*5) bt[1] = 1'b1;
#(`T_CLK*1) bt[1] = 1'b0;
#(`T_CLK*1) btstar = 1'b1;
#(`T_CLK*1) btstar = 1'b0;

#(`T_CLK*5) bt[1] = 1'b1;
#(`T_CLK*1) bt[1] = 1'b0;
#(`T_CLK*1) bt[2] = 1'b1;
#(`T_CLK*1) bt[2] = 1'b0;
#(`T_CLK*1) bt[3] = 1'b1;
#(`T_CLK*1) bt[3] = 1'b0;
#(`T_CLK*1) bt[7] = 1'b1;
#(`T_CLK*1) bt[7] = 1'b0;
#(`T_CLK*1) btstar = 1'b1;
#(`T_CLK*1) btstar = 1'b0;

#(`T_CLK*5) bt[1] = 1'b1; 
#(`T_CLK*1) bt[1] = 1'b0;
#(`T_CLK*1) bt[2] = 1'b1;
#(`T_CLK*1) bt[2] = 1'b0;
#(`T_CLK*1) btstar = 1'b1;
#(`T_CLK*1) btstar = 1'b0;

#(`T_CLK*5) bt[1] = 1'b1;
#(`T_CLK*1) bt[1] = 1'b0;
#(`T_CLK*1) bt[2] = 1'b1;
#(`T_CLK*1) bt[2] = 1'b0;
#(`T_CLK*1) bt[9] = 1'b1;
#(`T_CLK*1) bt[9] = 1'b0;
#(`T_CLK*1) bt[7] = 1'b1;
#(`T_CLK*1) bt[7] = 1'b0;
#(`T_CLK*1) bt[7] = 1'b1;
#(`T_CLK*1) bt[7] = 1'b0;
#(`T_CLK*1) btstar = 1'b1;
#(`T_CLK*1) btstar = 1'b0;

#(`T_CLK*5) bt[1] = 1'b1;
#(`T_CLK*1) bt[1] = 1'b0;
#(`T_CLK*1) bt[7] = 1'b1;
#(`T_CLK*1) bt[7] = 1'b0;
#(`T_CLK*1) btstar = 1'b1;
#(`T_CLK*1) btstar = 1'b0;

#(`T_CLK*5) bt[1] = 1'b1;
#(`T_CLK*1) bt[1] = 1'b0;
#(`T_CLK*1) bt[2] = 1'b1;
#(`T_CLK*1) bt[2] = 1'b0;
#(`T_CLK*1) bt[7] = 1'b1;
#(`T_CLK*1) bt[7] = 1'b0;
#(`T_CLK*1) bt[5] = 1'b1;
#(`T_CLK*1) bt[5] = 1'b0;
#(`T_CLK*1) bt[7] = 1'b1;
#(`T_CLK*1) bt[7] = 1'b0;
#(`T_CLK*1) btstar = 1'b1;
#(`T_CLK*1) btstar = 1'b0;


#(`T_CLK*5) bt[1] = 1'b1;
#(`T_CLK*1) bt[1] = 1'b0;
#(`T_CLK*1) bt[2] = 1'b1;
#(`T_CLK*1) bt[2] = 1'b0;
#(`T_CLK*1) bt[7] = 1'b1;
#(`T_CLK*1) bt[7] = 1'b0;
#(`T_CLK*1) bt[4] = 1'b1;
#(`T_CLK*1) bt[4] = 1'b0;
#(`T_CLK*1) btstar = 1'b1;
#(`T_CLK*1) btstar = 1'b0;

$stop;

end

doorlock_hdl u_doorlock_hdl(
.clk(clk),
.n_rst(n_rst),
.bt(bt),
.btstar(btstar),
.led(led)
);
endmodule