module byte2ascii(
  start,
  data_in,
  uart_start,
  data_out
  );

input start;
input [7:0]data_in;
output uart_start;
output [7:0] data_out;

assign uart_start = start;
assign data_out = data_in;

endmodule