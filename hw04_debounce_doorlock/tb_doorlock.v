`timescale 1ns/10ps
`define T_CLK 10

module tb_debounce_1();
parameter [19:0] T_20MS = 20'h0_0008; // d50_000_000;


reg clk;
reg n_rst;

reg din;

wire dout;

initial begin
    clk = 1'b1;
    n_rst = 1'b0;
    #(`T_CLK*1.2) n_rst = 1'b1;
end

always #(`T_CLK/2) clk = ~clk;



initial begin
    din = 1'b0;

    #(`T_CLK*3.1) 
    din = 1'b1;

    #(`T_CLK*2.1)
    din = 1'b0;

    #(`T_CLK*3.1)
    din = 1'b1;

    #(`T_CLK*1.1)
    din = 1'b0;

    #(`T_CLK*2.1)
    din = 1'b1;

    #(`T_CLK*3.1)
    din = 1'b1;

    #(`T_CLK*10.1)
    din = 1'b0;

    #(`T_CLK*2.1)
    din = 1'b1;

    #(`T_CLK*4.1)
    din = 1'b0;

    #(`T_CLK*2.1)
    din = 1'b1;

    #(`T_CLK*1.1)
    din = 1'b0;

    #(`T_CLK*20.1)
    $stop;
    
end

debounce_1 #(
   .T_20MS(T_20MS)
) u_debounce(
    .clk(clk),
    .n_rst(n_rst),
    .din(din),
    .dout(dout)
);

endmodule
