`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/17/2026 05:49:57 PM
// Design Name: 
// Module Name: BIST_loopback_TB
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


module BIST_loopback_TB ();

    // -- signal declarations --
    logic signed [7:0] TB_int_input;
    logic [12:0] TB_fp_output;
    logic signed [7:0] TB_int_output;
    logic TB_uf;
    logic TB_of;

    // -- TB variables --
    //logic [12:0] expected_fp_output;
    int pass_count;
    int fail_count;

    // -- UUT instantiation --
    int_to_fp UUT (
        .int_input(TB_int_input),
        .fp_result(TB_fp_output)
    );

    fp_to_int UUT2 (
        .int_result(TB_int_output),
        .fp_input(TB_fp_output),
        .uf(TB_uf),
        .of(TB_of)
    );

    initial begin
        pass_count = 0;
        fail_count = 0;

        $display("-- Starting Test Bench --");

        //will iterate through 1000 random values
        for (int i = -128; i < 128; i++) begin
            TB_int_input = i;

            #1;  //delay to allow calculation time

            // -- pass condition --
            assert ((TB_int_output === TB_int_input) || TB_uf || TB_of) begin
                pass_count++;
//                $display(
//                    "PASS test: \n int input: %b\n fp output: %b\n int output: %b\n uf: %b\n of: %b\n",
//                    TB_int_input, TB_fp_output, TB_int_output, TB_uf, TB_of);
            end  // -- fail condition --
            else begin
                fail_count++;
                $error("Test %0d Failed.", i);
//                $display(
//                    "FAIL test: \n int input: %b\n fp output: %b\n int output: %b\n uf: %b\n of: %b\n",
//                    TB_int_input, TB_fp_output, TB_int_output, TB_uf, TB_of);
            end

            #9;  //delay before next loop
            if ((i % 20) === 0) $display("Test number %d executing...", i);
        end

        $display("-- Test Bench Summary --");
        $display("Pass count: %0d", pass_count);
        $display("Fail count: %0d", fail_count);

        if (fail_count == 0) begin
            $display("All tests passed!");
        end else begin
            $display("Test failed.");
        end

        $finish;  //finish simulation
    end
endmodule
