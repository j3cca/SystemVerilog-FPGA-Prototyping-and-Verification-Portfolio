`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/07/2026 04:45:30 PM
// Design Name: 
// Module Name: pulse_width_modulation
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


module pulse_width_modulation #(
    parameter int MAX_WIDTH = 4  //bit width
) (
    input logic clk,  //clock
    input logic rst,  //reset, goes to button
    input logic [MAX_WIDTH-1:0] duty_cycle_amt,  //length of ON/high interval
    output logic sq_pulse  //square wave pulse
);

    // --declarations--
    logic [MAX_WIDTH-1:0] cycle_count;
    logic pulse_state;
    logic pulse_next;

    // --register--
    always_ff @(posedge clk, posedge rst) begin
        //reset
        if (rst) begin
            cycle_count <= 'b0;
            pulse_state <= 'b0;
        end else begin
            cycle_count <= cycle_count + 'b1;  //increment counter
            pulse_state <= pulse_next;  //progress to next state
        end
    end

    // --next state logic--
    always_comb begin
        //if HIGH signal hasn't reached specified active length
        if ((cycle_count < duty_cycle_amt) && (duty_cycle_amt > 0)) begin //ensures duty cycle is not 0
            pulse_next = 1'b1;
        end else begin
            //if specified active length reached or if duty cycle = 0
            pulse_next = 1'b0;
        end

    end

    // --output logic
    assign sq_pulse = pulse_state;

endmodule
