`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/05/2026 12:59:32 PM
// Design Name: 
// Module Name: barrel_8_bit_alt
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


module barrel_8_bit_alt(
    input logic [7:0] d_in, //input value to be rotated
    input logic [2:0] amt, //number of rotations
    input logic lr, //0 = right, 1 = left
    output logic [7:0] out //output
    );
    
    //signal declaration
    logic [7:0] l_in, rev_in, rot0, rot1, rout, lout;
    
    //derive left shift input
    generate
        genvar i;
        for (i = 0; i < 8; i++) begin: left_in
          assign l_in[i] = d_in[7-i];
        end
    endgenerate
    
    // assign input to be shifted
    assign rev_in = (lr) ? l_in : d_in;

    //right shift
    assign rot0 = amt[0] ? {rev_in[0], rev_in[7:1]} : rev_in; //LSB becomes MSB
    assign rot1 = amt[1] ? {rot0[1:0], rot0[7:2]} : rot0; //shift lower 2 bits to beginning
    assign rout = amt[2] ? {rot1[3:0], rot1[7:4]} : rot1; //shift lower 4 bits to beginning

    //derive left shift output
    generate
        genvar j;
        for (j = 0; j < 8; j++) begin: left_out
          assign lout[j] = rout[7-j];
        end
    endgenerate
    
    //assign output based on lr value
    assign out = (lr) ? lout : rout;

endmodule
