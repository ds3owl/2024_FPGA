module spi_slave_adc(
    sclk,
    n_rst,
    cs_n,
    data,
    sdata
);

// Assign the given input and output conditions

input [4:0] sclk;
input n_rst;
input cs_n;
input [7:0] data;
output sdata;

// Declare the counter, buffer, and dout as registers
reg [4:0] cnt;
reg [7:0] buffer;
reg dout;

// Create a counter

always @(negedge sclk or negedge n_rst) begin
    if(!n_rst) begin
        cnt <= 5'h0;
    end
    else begin
        cnt <= cnt + 1'b1;
    end
end

// Load the data from the input into the buffer
// Shift the data from the buffer to dout

always @(negedge sclk or negedge n_rst) begin
    if(!n_rst) begin
        dout <= 1'b0;
        buffer <= 8'b0;
    end
    else
      if((cs_n == 1'b0) && (cnt == 5'b00010)) begin
        buffer <= data;
      end
      else begin
        dout <= buffer[7];
        buffer[7] <= buffer[6];
        buffer[6] <= buffer[5];
        buffer[5] <= buffer[4];
        buffer[4] <= buffer[3];
        buffer[3] <= buffer[2];
        buffer[2] <= buffer[1];
        buffer[1] <= buffer[0];
        buffer[0] <= 1'b0;
    end 
end

assign sdata = (cs_n == 1'b1||cnt == 5'b10000)? 1'bz : ((cnt >= 5'b00100)&&(cnt <= 5'b01011))? dout : 1'b0;

// When cs_n is 1 or the counter is 0x10, sdata outputs high impedance
// When cs_n is not 1 and the counter is running, sdata outputs dout
// In other conditions, sdata outputs 1'b0

endmodule