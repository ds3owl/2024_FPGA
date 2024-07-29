module edge_det_p(
    clk,
    n_rst,
    b0,
    b0_on
);

input clk;
input n_rst;
input b0;
output b0_on;

reg b0_d1;
reg b0_d2;
wire b0_on;

always @(posedge clk or negedge n_rst) // Rising edge
if(!n_rst) begin
    b0_d1 <= 1'b0;
    b0_d2 <= 1'b0;
end
else begin
    b0_d1 <= b0;
    b0_d2 <= b0_d1;
end

assign b0_on = (b0_d1 && !b0_d2) ? 1'b1 : 1'b0; // b1 ?? ??

endmodule