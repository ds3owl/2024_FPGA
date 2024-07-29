module fnd_enc (
    input [3:0] din,
    output reg [6:0] dout
);

    always @(*) begin
        case (din)
            4'h0: dout = 7'b1000000; // 0
            4'h1: dout = 7'b1111001; // 1
            4'h2: dout = 7'b0100100; // 2
            4'h3: dout = 7'b0110000; // 3
            4'h4: dout = 7'b0011001; // 4
            4'h5: dout = 7'b0010010; // 5
            4'h6: dout = 7'b0000010; // 6
            4'h7: dout = 7'b1111000; // 7
            4'h8: dout = 7'b0000000; // 8
            4'h9: dout = 7'b0010000; // 9
            4'hA: dout = 7'b0001000; // A
            4'hB: dout = 7'b0000011; // B
            4'hC: dout = 7'b1000110; // C
            4'hD: dout = 7'b0100001; // D
            4'hE: dout = 7'b0000110; // E
            4'hF: dout = 7'b0001110; // F
            default: dout = 7'b1111111; // Default case (all segments off)
        endcase
    end

endmodule