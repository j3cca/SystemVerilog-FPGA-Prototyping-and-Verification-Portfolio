`timescale 1ns / 1fs  //1fs time precision to allow repeating decimal value for clock period
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/25/2026 03:42:18 PM
// Design Name: 
// Module Name: TB_stim_pulse_gen
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


module TB_stim_pulse_gen ();

    // --parameters--
    localparam real HALF_PERIOD = 1000.0 / 24.0;  //clock period = 83.3333ns
    localparam int MAX_WIDTH = 4;  //max bit width

    // -- signal declarations --
    logic TB_clk = 1'b0;
    logic TB_rst;
    logic [MAX_WIDTH-1:0] TB_high_interval;
    logic [MAX_WIDTH-1:0] TB_low_interval;
    logic TB_sq_pulse;

    // -- TB variables --
    int pass_count;
    int fail_count;
    realtime start_time_high;
    realtime meas_width_high;
    realtime start_time_low;
    realtime meas_width_low;
    real epsilon = 0.001;  // 1 picosecond tolerance

    // -- UUT instantiation --
    stim_pulse_gen #(
        .CYCLE_CNT_MAX(11),
        .MAX_WIDTH(MAX_WIDTH)
    ) UUT (
        .clk(TB_clk),
        .rst(TB_rst),
        .high_interval(TB_high_interval),
        .low_interval(TB_low_interval),
        .sq_pulse(TB_sq_pulse)
    );

    // --initial conditions--
    initial begin
        TB_rst = 1'b1;
        repeat (3)
        @(negedge TB_clk);  // Wait 1.5 clock cycles, don't de-assert on rising clock edge
        TB_rst = 1'b0;
    end

    // --clock--
    always begin
        #(HALF_PERIOD);
        TB_clk = ~TB_clk;
    end

    // --Testbench Begin--
    initial begin
        pass_count = 0;
        fail_count = 0;

        $display("-- Starting Test Bench --");

        //will iterate through all possible values of m and n
        for (int i = 0; i < 16; i++) begin
            @(negedge TB_clk) TB_high_interval = i;

            for (int j = 0; j < 16; j++) begin
                @(negedge TB_clk) TB_low_interval = j;

                TB_rst = 1'b1;
                repeat (3)
                @(negedge TB_clk);  // Wait 1.5 clock cycles, don't de-assert on rising clock edge
                TB_rst = 1'b0;

                verify_wave(TB_high_interval, TB_low_interval);

                // // -- pass condition --
                // assert (TB_sq_pulse === expected_out) begin
                //     pass_count++;
                //     // $display(
                //     //     "PASS test: \n int input: %b\n fp output: %b\n int output: %b\n uf: %b\n of: %b\n",);
                // end  // -- fail condition --
                // else begin
                //     fail_count++;
                //     $error("Test %0d Failed.", i);
                //     // $display(
                //     //     "FAIL test: \n int input: %b\n fp output: %b\n int output: %b\n uf: %b\n of: %b\n");
                // end

                if (((i * j) % 20) === 0) $display("Test number %0d executing...", (i * j));
            end
        end

        // --Testbench End--
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

    task verify_wave;
        input logic [MAX_WIDTH-1:0] high;
        input logic [MAX_WIDTH-1:0] low;

        begin
            if ((high == 0) || (low == 0)) begin
                repeat (2) @(posedge TB_clk);
                if (high == 0) begin
                    assert (TB_sq_pulse === 0) begin
                        pass_count++;
                        $display("PASS test:\n high = %0d\n low = %0d\n", high, low);
                    end else begin
                        fail_count++;
                        $display("FAIL test:\n high = %0d\n low = %0d\n", high, low);
                        $error("Test i = %0d, j = %0d Failed.", high, low);
                    end
                end else begin  //if n == 0
                    assert (TB_sq_pulse === 1) begin
                        pass_count++;
                        $display("PASS test:\n high = %0d\n low = %0d\n", high, low);
                    end else begin
                        fail_count++;
                        $display("FAIL test:\n high = %0d\n low = %0d\n", high, low);
                        $error("Test i = %0d, j = %0d Failed.", high, low);
                    end
                end
            end else begin
                //check high pulse
                fork
                    begin
                        @(posedge TB_sq_pulse) start_time_high = $realtime;
                    end
                    begin
                        #(1000000);
                        $fatal(1, "Watchdog: Pulse never went high.");
                    end
                join_any
                disable fork;

                fork
                    begin
                        @(negedge TB_sq_pulse) meas_width_high = $realtime - start_time_high;
                    end
                    begin
                        #(1000000);
                        $fatal(1, "Watchdog: Pulse never went low.");
                    end
                join_any
                disable fork;

                if ((meas_width_high > (high * 1000.0) - epsilon) && (meas_width_high < (high * 1000.0) + epsilon)) begin
                    pass_count++;
                    $display("PASS test:\n high = %0d\n duration = %0t\n", high, meas_width_high);
                end else begin
                    fail_count++;
                    $display("FAIL test:\n high = %0d\n duration = %0t\n", high, meas_width_high);
                    $error("Test i = %0d, j = %0d Failed.", high, low);
                end

                //check low pulse
                start_time_low = $realtime;  //bc negedge just occurred

                fork
                    begin
                        @(posedge TB_sq_pulse) meas_width_low = $realtime - start_time_low;
                    end
                    begin
                        #(1000000);
                        $fatal(1, "Watchdog: Pulse never went high.");
                    end
                join_any
                disable fork;

                if ((meas_width_low > (low * 1000.0) - epsilon) && (meas_width_low < (low * 1000.0) + epsilon)) begin
                    pass_count++;
                    $display("PASS test:\n low = %0d\n duration = %0t\n", low, meas_width_low);
                end else begin
                    fail_count++;
                    $display("FAIL test:\n low = %0d\n duration = %0t\n", low, meas_width_low);
                    $error("Test i = %0d, j = %0d Failed.", high, low);
                end
            end
        end
    endtask

endmodule
