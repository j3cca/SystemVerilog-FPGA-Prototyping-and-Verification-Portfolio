`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/17/2026 05:53:46 PM
// Design Name: 
// Module Name: fp_to_int
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


module fp_to_int (
    output logic signed [7:0] int_result,
    input logic [12:0] fp_input,
    output logic uf,  //underflow signal
    output logic of  //overflow signal
);

    // --signal declaration--
    //intermediate variables
    logic sign;
    logic [3:0] exp;  //exponent
    logic [3:0] exp_sans_bias;
    logic [7:0] mantissa;  //mantissa
    logic [8:0] mantissa_w_1;  //mantissa + leading 1: 1.mantissa
    logic [8:0] unsigned_int;  //holds int value prior to 2's comp.
    logic [6:0] signed_int;  //holds int value after 2's complement op

    //separate fp value to components
    assign sign = fp_input[12];
    assign exp = fp_input[11:8];
    assign mantissa = fp_input[7:0];

    //remove bias from exponent to get shift amount
    assign exp_sans_bias = exp - 7;

    //add leading value (1 or 0) prior to mantissa
    assign mantissa_w_1 = (!exp) ? {1'b0, mantissa} : {1'b1, mantissa};
    //if exponent = 0, don't add leading 0 (denormal num)

    //shift based on exponent
    assign unsigned_int = (!exp) ? 9'b0 : (mantissa_w_1 >> (8 - exp_sans_bias));
    //no shift if exponent = 0 bc = all zero case

    //change back to 2's complement if neg
    assign signed_int = (sign) ? (~(unsigned_int[6:0]) + 1'b1) : (unsigned_int[6:0]);

    //underflow flag set
    assign uf = ((exp < 7) && (exp != 0)) ? 1 : 0;  //if exp < 7, exp_sans_bias = neg

    //overflow flag set
    assign of = (!sign && unsigned_int > 127) || (sign && unsigned_int > 128);
    //if pos, 127 = max, if neg, -128 = max

    //concatenate final result
    assign int_result = {sign, signed_int};

endmodule
