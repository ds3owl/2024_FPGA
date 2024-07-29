module byte2ascii(
  clk,
  n_rst,
  start,
  data_in,
  uart_start,
  data_out,
  rx_done
  );

input clk;
input n_rst;
input start;
input [7:0]data_in;
output uart_start;
output [7:0]data_out;
input rx_done;

parameter S_IDLE = 3'b000;
parameter S_FIRST = 3'b001;
parameter S_FIRST_W = 3'b010;
parameter S_SEC = 3'b011;
parameter S_SEC_W = 3'b100;
parameter S_SPACE = 3'b101;
parameter S_SPACE_W = 3'b110;

reg [2:0]c_state;
reg [2:0]n_state;
reg r_uart_start;
reg [7:0]r_data;

//flip flop
always @(posedge clk or negedge n_rst)
  if(!n_rst) begin
    c_state <= S_IDLE;
  end
  else begin
    c_state <= n_state;
  end

//state machine
always @(*)
  case(c_state)
    S_IDLE : begin
      n_state = (start == 1'b1) ? S_FIRST : c_state;
      r_uart_start = 1'b0;
    end
    S_FIRST : begin
      n_state = S_FIRST_W;
      r_uart_start = 1'b1;
    end
    S_FIRST_W : begin
      n_state = (rx_done == 1'b1) ? S_SEC : c_state;
      r_uart_start = 1'b0;
    end
    S_SEC : begin
      n_state = S_SEC_W;
      r_uart_start = 1'b1;
    end
    S_SEC_W : begin
      n_state = (rx_done == 1'b1) ? S_SPACE : c_state;
      r_uart_start = 1'b0;
    end
    S_SPACE : begin
      n_state = S_SPACE_W;
      r_uart_start = 1'b1;
    end
    S_SPACE_W : begin
      n_state = (rx_done == 1'b1) ? S_IDLE : c_state;
      r_uart_start = 1'b0;
    end
    default : begin
      n_state = S_IDLE;
      r_uart_start = 1'b0;
    end
  endcase

//data
always@(*)
    if(c_state == S_IDLE) begin
      r_data = 8'b0000_0000;
    end
    else begin
      if(c_state == S_FIRST || c_state == S_FIRST_W) begin
        r_data = (data_in[7:4] < 4'b1010) ? {4'b0011, data_in[7:4]} : {4'b0100, data_in[7:4] - 4'b1001};
      end
      else if(c_state == S_SEC || c_state == S_SEC_W) begin
        r_data = (data_in[3:0] < 4'b1010) ? {4'b0011, data_in[3:0]} : {4'b0100, data_in[7:4] - 4'b1001};
      end
      else begin
        r_data = 8'b0010_0000;
      end
    end

//output for uart_tx
assign uart_start = r_uart_start;
assign data_out = r_data;

endmodule