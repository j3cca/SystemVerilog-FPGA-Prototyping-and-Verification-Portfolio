`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/09/2026 03:42:39 PM
// Design Name: 
// Module Name: parametric_barrel_shifter
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


module parametric_barrel_shifter #(
    parameter N = 8
) (
    input logic [N-1:0] d_in,  //input value to be rotated
    input logic [$clog2(N)-1:0] amt,  //number of rotations = log2(N) - 1
    input logic lr,  //0 = right, 1 = left
    output logic [N-1:0] out  //output
);

    //error checking
    if ((N & (N - 1)) != 0) $error("N must be a power of 2");

    //constant declaration
    localparam N1 = N - 1;

    //signal declaration
    logic [N1:0] l_in, rev_in, rout, lout;

    //reverse bits for left shift input
    assign l_in = {<<{d_in}};  //streaming operator reverses bits automatially

    //assign input to be shifted
    assign rev_in = (lr) ? l_in : d_in;

    //derive right shift output
    assign rout = ({rev_in, rev_in} >> amt); //concatenates rev_in to make 2N bus, then R shifts by amt; result will truncate 2N bus back to N

    //reverse bits for left shift output
    assign lout = {<<{rout}};

    //assign output based on lr value
    assign out = (lr) ? lout : rout;

endmodule
