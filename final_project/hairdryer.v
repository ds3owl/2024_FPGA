//`define SIM
module hairdryer (
    input clk,
    input n_rst,
    input [1:0] slide,
    input btstart,
    input done,
    output reg uart_start,
    output reg [7:0] data_out
);

`ifdef SIM
parameter T_DIV_BIT    = 4;
parameter T_DIV_0      = 4'd15;
parameter T_DIV_HALF_0 = 4'd7;
parameter T_DIV_1      = 4'd7;
parameter T_DIV_HALF_1 = 4'd3;
`else
parameter T_DIV_BIT    = 13;
parameter T_DIV_0      = 13'd5207;
parameter T_DIV_HALF_0 = 13'd2603;
parameter T_DIV_1      = 13'd2603;
parameter T_DIV_HALF_1 = 13'd1301;
`endif

localparam IDLE = 4'h0;
localparam COLD = 4'h1;
localparam COLD_W = 4'h2;
localparam HOT = 4'h3;
localparam HOT_W = 4'h4;
localparam SLOW = 4'h5;
localparam SLOW_W = 4'h6;
localparam FAST = 4'h7;
localparam FAST_W = 4'h8;
localparam LAST = 4'h9;
    
localparam H = 8'h48;
localparam C = 8'h43;
localparam F = 8'h46;
localparam S = 8'h53;

reg [3:0] c_state, n_state;
reg btstart_edge1, btstart_edge2;

//check push button
always @(posedge clk or negedge n_rst) begin
  if (!n_rst) begin
    btstart_edge1 <= 1'b0;
    btstart_edge2 <= 1'b0;
  end 
  else begin
    btstart_edge1 <= btstart;
    btstart_edge2 <= btstart_edge1;
  end
end

//flip flop
always @(posedge clk or negedge n_rst)
  if(!n_rst) begin
    c_state <= IDLE;
  end
  else begin
    c_state <= n_state;
  end

// ?? ?? ? ??? ?? ??
always @(*) begin
  case (c_state)
    IDLE : begin
      n_state = (uart_start == 1'b1 && slide[0] == 1'b0) ? COLD : (uart_start == 1'b1 && slide[0] == 1'b1) ? HOT : c_state;
      uart_start = ((btstart_edge1 == 1'b1) && (btstart_edge2 == 1'b0)) ? 1'b1 : 1'b0;
    end
    COLD : begin
      n_state = COLD_W;
      uart_start = 1'b1;
    end
    COLD_W : begin
      n_state = (done == 1'b1 && slide[1] == 1'b0) ? SLOW : (done == 1'b1 && slide[1] == 1'b1) ? FAST : c_state;
      uart_start = 1'b0;
    end
    HOT : begin
      n_state = HOT_W;
      uart_start = 1'b1;
    end
    HOT_W : begin
      n_state = (done == 1'b1 && slide[1] == 1'b0) ? SLOW : (done == 1'b1 && slide[1] == 1'b1) ? FAST : c_state;
      uart_start = 1'b0;
    end
    SLOW : begin
      
      n_state = SLOW_W;
      uart_start = 1'b1;
    end
    SLOW_W : begin
      n_state = (done == 1'b1)? LAST : c_state;
      uart_start = 1'b0;
    end
    FAST : begin
      n_state = FAST_W;
      uart_start = 1'b1;
    end
    FAST_W : begin
      n_state = (done == 1'b1) ? LAST : c_state;
      uart_start = 1'b0;
    end
    LAST : begin
      n_state = (uart_start == 1'b1) ? IDLE : c_state;
      uart_start = ((btstart_edge1 == 1'b1) && (btstart_edge2 == 1'b0)) ? 1'b1 : 1'b0;
    end
    default : begin
      n_state = IDLE;
      uart_start = 1'b0;
    end
  endcase
end

always @(*) begin
  case (c_state)
    IDLE: data_out = 8'b0000_0000;
    COLD, COLD_W: data_out = C;
    HOT, HOT_W: data_out = H;
    SLOW, SLOW_W: data_out = S;
    FAST, FAST_W: data_out = F;
    default: data_out = 8'b0000_0000;
  endcase
end

endmodule