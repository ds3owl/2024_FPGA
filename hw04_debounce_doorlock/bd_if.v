module bd_if(
  clk,
  n_rst,
  bt_i,
  btstar_i,
  led_i,
  bt_o,
  btstar_o,
  led_o,
  );

parameter T_1S = 26'h2FA_F080;
parameter T_20MS = 20'hF_4240;

input clk;
input n_rst;
input [9:0] bt_i;
input btstar_i;
input led_i;
output [9:0] bt_o;
output btstar_o;
output led_o;

wire [9:0] dwire;
//Add dwire, a wire, to connect debounce and edge_det_p

//Assign debounc to each button and connect debounc to edge_det_p

debounc_1 #(.T_20MS(T_20MS)) u_debounc0(
//debounc_2 #(.T_20MS(T_20MS)) u_debounc(
//debounc_3 #(.T_20MS(T_20MS)) u_debounc(
  .clk(clk),
  .n_rst(n_rst),
  .din(bt_i[0]),
  .dout(dwire[0])
);

edge_det_p u_edgedet_p0 (
  .clk(clk),
  .n_rst(n_rst),
  .b0(dwire[0]),
  .b0_on(bt_o[0])
  );

debounc_1 #(.T_20MS(T_20MS)) u_debounc1(
//debounc_2 #(.T_20MS(T_20MS)) u_debounc(
//debounc_3 #(.T_20MS(T_20MS)) u_debounc(
  .clk(clk),
  .n_rst(n_rst),
  .din(bt_i[1]),
  .dout(dwire[1])
);

edge_det_p u_edgedet_p1 (
  .clk(clk),
  .n_rst(n_rst),
  .b0(dwire[1]),
  .b0_on(bt_o[1])
  );

debounc_2 #(.T_20MS(T_20MS)) u_debounc2(
//debounc_2 #(.T_20MS(T_20MS)) u_debounc(
//debounc_3 #(.T_20MS(T_20MS)) u_debounc(
  .clk(clk),
  .n_rst(n_rst),
  .din(bt_i[2]),
  .dout(dwire[2])
);

edge_det_p u_edgedet_p2 (
  .clk(clk),
  .n_rst(n_rst),
  .b0(dwire[2]),
  .b0_on(bt_o[2])
  );

debounc_2 #(.T_20MS(T_20MS)) u_debounc3(
//debounc_2 #(.T_20MS(T_20MS)) u_debounc(
//debounc_3 #(.T_20MS(T_20MS)) u_debounc(
  .clk(clk),
  .n_rst(n_rst),
  .din(bt_i[3]),
  .dout(dwire[3])
);

edge_det_p u_edgedet_p3 (
  .clk(clk),
  .n_rst(n_rst),
  .b0(dwire[3]),
  .b0_on(bt_o[3])
  );

debounc_2 #(.T_20MS(T_20MS)) u_debounc4(
//debounc_2 #(.T_20MS(T_20MS)) u_debounc(
//debounc_3 #(.T_20MS(T_20MS)) u_debounc(
  .clk(clk),
  .n_rst(n_rst),
  .din(bt_i[4]),
  .dout(dwire[4])
);

edge_det_p u_edgedet_p4 (
  .clk(clk),
  .n_rst(n_rst),
  .b0(dwire[4]),
  .b0_on(bt_o[4])
  );

debounc_2 #(.T_20MS(T_20MS)) u_debounc5(
//debounc_2 #(.T_20MS(T_20MS)) u_debounc(
//debounc_3 #(.T_20MS(T_20MS)) u_debounc(
  .clk(clk),
  .n_rst(n_rst),
  .din(bt_i[5]),
  .dout(dwire[5])
);

edge_det_p u_edgedet_p5 (
  .clk(clk),
  .n_rst(n_rst),
  .b0(dwire[5]),
  .b0_on(bt_o[5])
  );

debounc_3 #(.T_20MS(T_20MS)) u_debounc6(
//debounc_2 #(.T_20MS(T_20MS)) u_debounc(
//debounc_3 #(.T_20MS(T_20MS)) u_debounc(
  .clk(clk),
  .n_rst(n_rst),
  .din(bt_i[6]),
  .dout(dwire[6])
);

edge_det_p u_edgedet_p6 (
  .clk(clk),
  .n_rst(n_rst),
  .b0(dwire[6]),
  .b0_on(bt_o[6])
  );

debounc_3 #(.T_20MS(T_20MS)) u_debounc7(
//debounc_2 #(.T_20MS(T_20MS)) u_debounc(
//debounc_3 #(.T_20MS(T_20MS)) u_debounc(
  .clk(clk),
  .n_rst(n_rst),
  .din(bt_i[7]),
  .dout(dwire[7])
);

edge_det_p u_edgedet_p7(
  .clk(clk),
  .n_rst(n_rst),
  .b0(dwire[7]),
  .b0_on(bt_o[7])
  );

debounc_3 #(.T_20MS(T_20MS)) u_debounc8(
//debounc_2 #(.T_20MS(T_20MS)) u_debounc(
//debounc_3 #(.T_20MS(T_20MS)) u_debounc(
  .clk(clk),
  .n_rst(n_rst),
  .din(bt_i[8]),
  .dout(dwire[8])
);

edge_det_p u_edgedet_p8 (
  .clk(clk),
  .n_rst(n_rst),
  .b0(dwire[8]),
  .b0_on(bt_o[8])
  );
  
debounc_3 #(.T_20MS(T_20MS)) u_debounc9(
//debounc_2 #(.T_20MS(T_20MS)) u_debounc(
//debounc_3 #(.T_20MS(T_20MS)) u_debounc(
  .clk(clk),
  .n_rst(n_rst),
  .din(bt_i[9]),
  .dout(dwire[9])
);

edge_det_p u_edgedet_p9 (
  .clk(clk),
  .n_rst(n_rst),
  .b0(dwire[9]),
  .b0_on(bt_o[9])
  );

edge_det_p u_edgedet_pstar (
  .clk(clk),
  .n_rst(n_rst),
  .b0(~btstar_i),
  .b0_on(btstar_o)
  );

led #(.T_1S(T_1S)) u_led(
  .clk(clk),
  .n_rst(n_rst),
  .din(led_i),
  .dout(led_o)
);
  
endmodule