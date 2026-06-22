`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/11/2026 01:54:04 PM
// Design Name: 
// Module Name: TB_parametric_barrel_shifter
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


module TB_parametric_barrel_shifter #(
    parameter N = 16
) ();
    // -- constant declarations --
    localparam N1 = N - 1;
    localparam M = $clog2(N);
    localparam M1 = M - 1;

    // -- signal declarations --
    logic [N1:0] TB_d_in;  //input value to be rotated
    logic [M1:0] TB_amt;  //number of rotations
    logic TB_lr;  //0 = right, 1 = left
    logic [N1:0] TB_out;

    // -- TB variables --
    logic [N1:0] expected_out, temp_shift, mask;
    int pass_count;
    int fail_count;

    // -- UUT instantiation --
    parametric_barrel_shifter #(
        .N(N)  //ensures that the parameter matches what is passed by TB
    ) UUT (
        .d_in(TB_d_in),
        .amt (TB_amt),
        .lr  (TB_lr),
        .out (TB_out)
    );

    initial begin
        pass_count = 0;
        fail_count = 0;

        $display("-- Starting Test Bench --");

        //will iterate through 1000 random values
        for (int i = 0; i < 1000; i++) begin
            TB_lr   = $urandom_range(0, 1); //constrained to 0 or 1
            TB_amt  = $urandom_range(0, N - 1); //amt to shift constrained by N
            TB_d_in = $urandom; //can be any value

            //performs L or R shift based on amount
            if (TB_lr) begin
                temp_shift = TB_d_in << TB_amt;
                mask = TB_d_in >> (N - TB_amt);
                expected_out = temp_shift | mask;
            end else begin
                temp_shift = TB_d_in >> TB_amt;
                mask = TB_d_in << (N - TB_amt);
                expected_out = temp_shift | mask;
            end

            #1;  //delay to allow calculation time

            // -- pass condition --
            assert (expected_out === TB_out) begin
                pass_count++;
                //$display("PASS test: %b shifted by %3b = %b (lr = %1b)", TB_d_in, TB_amt, TB_out, TB_lr);
            end  // -- fail condition --
            else begin
                fail_count++;
                $error("Test Failed.");
                //$display("FAIL test: %b shifted by %3b != %b (lr = %1b, expected = %b)", TB_d_in, TB_amt, TB_out, TB_lr, expected_out);
            end

            #9;  //delay before next loop
            if ((i % 100) === 0) $display("Test number %d executing...", i);
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
