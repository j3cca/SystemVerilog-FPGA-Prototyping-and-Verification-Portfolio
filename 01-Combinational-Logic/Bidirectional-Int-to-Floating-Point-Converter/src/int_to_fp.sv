`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/16/2026 04:08:50 PM
// Design Name: 
// Module Name: int_to_fp
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module int_to_fp (
    input logic signed [7:0] int_input,
    output logic [12:0] fp_result
);

    // --signal declaration--
    //final variables
    logic sign;
    logic [3:0] exp_out;  //output exponent
    logic [7:0] mantissa_out;  //output mantissa
    //intermediate variables
    logic [6:0] magn_int;  //magnitude of int, no sign

    //strip off sign bit and invert bits if sign = neg
    assign sign = int_input[7];
    assign magn_int = sign ? (~(int_input[6:0]) + 1'b1) : int_input[6:0];

    //assign exponent and mantissa based on location of leading 1
    always_comb begin
        casez (magn_int)
            7'b1??_????: begin
                exp_out = 4'd13;
                //exponent with bias (2^{n-1} - 1), shift 6 + 7 (bias)
                mantissa_out = {magn_int[5:0], 2'b0};
            end
            7'b01?_????: begin
                exp_out = 4'd12;  //shift 5 + 7 (bias)
                mantissa_out = {magn_int[4:0], 3'b0};
            end
            7'b001_????: begin
                exp_out = 4'd11;  //shift 4 + 7 (bias)
                mantissa_out = {magn_int[3:0], 4'b0};
            end
            7'b000_1???: begin
                exp_out = 4'd10;  //shift 3 + 7 (bias)
                mantissa_out = {magn_int[2:0], 5'b0};
            end
            7'b000_01??: begin
                exp_out = 4'd9;  //shift 2 + 7 (bias)
                mantissa_out = {magn_int[1:0], 6'b0};
            end
            7'b000_001?: begin
                exp_out = 4'd8;  //shift 1 + 7 (bias)
                mantissa_out = {magn_int[0], 7'b0};
            end
            7'b000_0001: begin
                exp_out = 4'd7;  //shift 0 + 7 (bias)
                mantissa_out = 8'b0;
            end
            default: begin  //covers all 0 case and -128 case
                exp_out = sign ? 4'd14 : 4'd0;
                //if sign = 1, -128 >> shift 7 + 7 (bias) = 14
                //all 0's = 0 exponent (no bias)
                mantissa_out = 8'b0;
            end
        endcase
    end

    //concatenate final result
    assign fp_result = {sign, exp_out, mantissa_out};

endmodule
