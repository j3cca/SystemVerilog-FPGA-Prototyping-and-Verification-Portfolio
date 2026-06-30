`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/05/2026 01:01:04 PM
// Design Name: 
// Module Name: barrel_8_bit
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


module barrel_8_bit(
    input logic [7:0] d_in, //input value to be rotated
    input logic [2:0] amt, //number of rotations
    input logic lr, //0 = right, 1 = left
    output logic [7:0] out //output
    );
    
    //signal declaration
    logic [7:0] lrot0, lrot1, rrot0, rrot1, lout, rout;
    
    //left shift
    assign lrot0 = amt[0] ? {d_in[6:0], d_in[7]} : d_in; //MSB becomes LSB
    assign lrot1 = amt[1] ? {lrot0[5:0], lrot0[7:6]} : lrot0; //shift upper 2 bits to end
    assign lout = amt[2] ? {lrot1[3:0], lrot1[7:4]} : lrot1; //shift upper 4 bits to end

    //right shift
    assign rrot0 = amt[0] ? {d_in[0], d_in[7:1]} : d_in; //LSB becomes MSB
    assign rrot1 = amt[1] ? {rrot0[1:0], rrot0[7:2]} : rrot0; //shift lower 2 bits to beginning
    assign rout = amt[2] ? {rrot1[3:0], rrot1[7:4]} : rrot1; //shift lower 4 bits to beginning

    //assign output based on lr value
    assign out = (lr) ? lout : rout;
    
endmodule
