`timescale 1ns / 1fs
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/07/2026 04:46:09 PM
// Design Name: 
// Module Name: TB_pwm
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


module TB_pwm ();

    // --parameters--
    localparam real SYS_CLK_PER = 1000.0 / 12.0;
    localparam real SYS_CLK_HALF_PER = SYS_CLK_PER / 2.0;
    //localparam real PWM_PERIOD = 4000.0 / 3.0;  //clock period = 1333.33ns
    //12MHz oscillator = 83.3 ns period * 16 = 1333.33 ns
    localparam int MAX_WIDTH = 4;  //max bit width
    //localparam real LENGTH_CLK_CYCLES = 64000.0 / 3.0;  //length of clock cycles

    // -- signal declarations --
    logic TB_clk = 1'b0;
    logic TB_rst;
    logic [MAX_WIDTH-1:0] TB_duty_cycle_amt;
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
    pulse_width_modulation #(
        .MAX_WIDTH(MAX_WIDTH)
    ) UUT (
        .clk(TB_clk),
        .rst(TB_rst),
        .duty_cycle_amt(TB_duty_cycle_amt),
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
        #(SYS_CLK_HALF_PER);
        TB_clk = ~TB_clk;
    end

    // --Testbench Begin--
    initial begin
        pass_count = 0;
        fail_count = 0;

        $display("-- Starting Test Bench --");

        //will iterate through all possible values of m and n
        for (int i = 0; i < 16; i++) begin
            @(negedge TB_clk) TB_duty_cycle_amt = i;

            TB_rst = 1'b1;
            repeat (3)
            @(negedge TB_clk);  // Wait 1.5 clock cycles, don't de-assert on rising clock edge
            TB_rst = 1'b0;


            verify_wave(TB_duty_cycle_amt);

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

            //if (((i * j) % 20) === 0) $display("Test number %0d executing...", (i * j));
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

        begin
            if (high == 0) begin
                repeat (2) @(posedge TB_clk);
                if (TB_sq_pulse === 0) begin
                    pass_count++;
                    $display("PASS test:\n high = %0d\n", high);
                end else begin
                    fail_count++;
                    $display("FAIL test:\n high = %0d\n", high);
                    $error("Test i = %0d Failed.", high);
                end
            end else if (high == 15) begin
                repeat (2) @(posedge TB_clk);
                if (TB_sq_pulse === 1) begin
                    pass_count++;
                    $display("PASS test:\n high = %0d\n", high);
                end else begin
                    fail_count++;
                    $display("FAIL test:\n high = %0d\n", high);
                    $error("Test i = %0d Failed.", high);
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

                if ((meas_width_high > ((high * SYS_CLK_PER) - epsilon)) && (meas_width_high < ((high * SYS_CLK_PER) + epsilon))) begin
                    pass_count++;
                    $display("PASS test HIGH:\n high = %0d\n duration = %0t\n", high,
                             meas_width_high);
                end else begin
                    fail_count++;
                    $display("FAIL test HIGH:\n high = %0d\n", high);
                    $error("Test i = %0d Failed.", high);
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

                if ((meas_width_low > ((((2**MAX_WIDTH) - high) * SYS_CLK_PER) - epsilon)) && (meas_width_low < ((((2**MAX_WIDTH) - high) * SYS_CLK_PER) + epsilon))) begin
                    pass_count++;
                    $display("PASS test LOW:\n low = %0d\n duration = %0t\n",
                             ((2 ** MAX_WIDTH) - high), meas_width_low);
                end else begin
                    fail_count++;
                    $display("FAIL test LOW:\n high = %0d\n duration = %0t\n", high,
                             meas_width_low);
                    $error("Test i = %0d, j = %0d Failed.", high, ((2 ** MAX_WIDTH) - high));
                end
            end
        end
    endtask

endmodule
