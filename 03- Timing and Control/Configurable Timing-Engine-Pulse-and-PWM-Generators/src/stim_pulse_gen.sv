`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/25/2026 03:41:37 PM
// Design Name: 
// Module Name: stim_pulse_gen
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


module stim_pulse_gen #(
    parameter int CYCLE_CNT_MAX = 11,  //0->11 = 12 cycles (1000ns at 12MHz)
    parameter int MAX_WIDTH = 4  //bit width
) (
    input logic clk,  //clock
    input logic rst,  //reset, goes to button
    input logic [MAX_WIDTH-1:0] high_interval,  //length of ON/high interval
    input logic [MAX_WIDTH-1:0] low_interval,  //length of OFF/low interval
    output logic sq_pulse  //square wave pulse
);

    // --declarations--
    logic pulse_state;  //pulse_state holds current value,
    logic pulse_next;  //r_next holds next state
    logic [MAX_WIDTH-1:0] cycle_cnt;  //cycle_cnt counts every 12 clock cycles
    logic [MAX_WIDTH-1:0] pulse_count;  //det.s if interval has been reached

    // --register--
    always_ff @(posedge clk, posedge rst) begin
        //reset
        if (rst) begin
            pulse_state <= 1'b0;  //start in OFF state
            pulse_count <= 1'b1;
            cycle_cnt   <= 'b0;

        end else begin
            //0 conditions
            if ((high_interval == 0) || (low_interval == 0)) begin
                if (((high_interval == 0) && (low_interval == 0)) || (high_interval == 0)) begin  //if (on AND off) = 0 or on = 0
                    pulse_state <= 1'b0;  //output is low because high = 0
                    pulse_count <= 1'b1;
                    cycle_cnt   <= 'b0;
                end else begin  //if (low == 0)
                    pulse_state <= 1'b1;  //signal should go high
                    pulse_count <= 1'b1;
                    cycle_cnt   <= 'b0;
                end

                //every 12 clock cycles, state may change
            end else if (cycle_cnt >= CYCLE_CNT_MAX) begin
                pulse_state <= pulse_next;
                cycle_cnt   <= 'b0;

                //to reset pulse_count if necessary
                if (pulse_state) begin  //if pulse is high/ON
                    //use >= in case m updates and == condition is missed
                    if (pulse_count >= high_interval)  //reset if switch to low
                        pulse_count <= 1'b1;
                    else pulse_count <= pulse_count + 1'b1;
                end else begin  //if pulse is low/OFF
                    if (pulse_count >= low_interval)  //reset if switch to high
                        pulse_count <= 1'b1;
                    else pulse_count <= pulse_count + 1'b1;
                end

                //if 12 clk cycles haven't elapsed, no change
            end else begin
                cycle_cnt <= cycle_cnt + 1'b1;  //must be in if/else if w/in asynch reset block
                //pulse_state <= pulse_state; //this is unnecessary since previous state is otherwise maintained
            end
        end
    end

    // --next state logic--
    always_comb begin
        if (pulse_state) begin  //if pulse is high/ON
            if ((pulse_count >= high_interval) && (high_interval != 0)) begin
                pulse_next = 1'b0;
            end else begin
                pulse_next = 1'b1;
            end
        end else begin  //if pulse is low/OFF
            if ((pulse_count >= low_interval) && (low_interval != 0)) begin
                pulse_next = 1'b1;
            end else begin
                pulse_next = 1'b0;
            end
        end
    end

    // --output logic
    assign sq_pulse = pulse_state;

endmodule
