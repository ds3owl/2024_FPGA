module fnd_encoder(
    input [3:0] number, 
    output reg [6:0] fnd_on  
);

always @ (number)
case (number)
    4'h0 : fnd_on = 7'b1000000;  
    4'h1 : fnd_on = 7'b1111001;  
    4'h2 : fnd_on = 7'b0100100;  
    4'h3 : fnd_on = 7'b0110000;  
    4'h4 : fnd_on = 7'b0011001;  
    4'h5 : fnd_on = 7'b0010010;  
    4'h6 : fnd_on = 7'b0000010;  
    4'h7 : fnd_on = 7'b1111000;  
    4'h8 : fnd_on = 7'b0000000;  
    4'h9 : fnd_on = 7'b0010000;  
    default: fnd_on = 7'b1111111; 
endcase

endmodule
