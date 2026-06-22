`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/05/2026 01:00:04 PM
// Design Name: 
// Module Name: TB_barrel_8_bit_alt
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


module TB_barrel_8_bit_alt();

// -- signal declarations --
    logic [7:0] TB_d_in; //input value to be rotated
    logic [2:0] TB_amt; //number of rotations
    logic TB_lr; //0 = right, 1 = left
    logic [7:0] TB_out;
    
    // -- TB variables --
    logic [7:0] expected_out;
    logic [7:0] temp_shift;
    logic [7:0] mask;
    int pass_count;
    int fail_count;
    
    // -- UUT instantiation --
    barrel_8_bit_alt UUT( 
        .d_in(TB_d_in),
        .amt(TB_amt),
        .lr(TB_lr),
        .out(TB_out)
    );
    
    initial begin
        pass_count = 0;
        fail_count = 0;
        
        $display("-- Starting Test Bench --");
        
        //outer loop - sets left or right shift
        for (int i = 0; i < 2; i++) begin
            TB_lr = i;    
            
            //inner loop - sets amt of rotation
            for (int j = 0; j < 8; j++) begin
                TB_amt = j; 
                
                //innermost loop - sets input value
                for (int k=0; k < 256; k++) begin
                    TB_d_in = k;
                    
                    //performs L or R shift based on amount
                    if (TB_lr) begin
                        temp_shift = TB_d_in << TB_amt;
                        mask = TB_d_in >> (8 - TB_amt);
                        expected_out = temp_shift | mask;
                    end
                    
                    else begin
                        temp_shift = TB_d_in >> TB_amt;
                        mask = TB_d_in << (8 - TB_amt);
                        expected_out = temp_shift | mask;
                    end
                
                    #1; //delay to allow calculation time
                
                    // -- pass condition --
                    assert (expected_out === TB_out) begin
                        pass_count++;
                        $display("PASS test: %8b shifted by %3b = %8b (lr = %1b)", TB_d_in, TB_amt, TB_out, TB_lr);
                    end
                    
                    // -- fail condition --
                    else begin
                        fail_count++;
                        $display("FAIL test: %8b shifted by %3b != %8b (lr = %1b, expected = %8b)", TB_d_in, TB_amt, TB_out, TB_lr, expected_out);
                    end
                    
                    #9; //delay before next loop
                end    
            end
        end
        
        $display("-- Test Bench Summary --");
        $display("Pass count: %0d", pass_count);
        $display("Fail count: %0d", fail_count);
        
        if (fail_count == 0) begin
            $display("All tests passed!");
        end
        
        else begin
            $display("Test failed.");
        end
        
        $finish; //finish simulation
    end
endmodule
