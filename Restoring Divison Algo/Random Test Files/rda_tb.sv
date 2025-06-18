module rda_tb;

    // Testbench signals
    logic clk;
    logic rst;
    logic start;
    logic [15:0] dividend;
    logic [15:0] divisor;
    logic [15:0] quotient;
    logic [15:0] remainder;
    logic valid;

    // Instantiate the DUT
    RestoringDivider UUT (
        .clk(clk),
        .rst(rst),
        .start(start),
        .dividend(dividend),
        .divisor(divisor),
        .quotient(quotient),
        .remainder(remainder),
        .valid(valid)
    );

    // Clock generation: 10ns period
    initial clk = 0;
    always #5 clk = ~clk;

    // Task to wait until result is valid
    task wait_for_valid;
        begin
            while (!valid) @(posedge clk);
        end
    endtask

    // Task to perform a test and check result
    task run_test(input [15:0] d, input [15:0] m);
        logic [31:0] expected;
        begin
            dividend = d;
            divisor  = m;
            start    = 1;
            @(posedge clk);
            start    = 0;

            wait_for_valid();

            expected = (quotient * divisor) + remainder;

            $display("Test: %0d / %0d => Quotient = %0d, Remainder = %0d", d, m, quotient, remainder);
            if (expected == d)
                $display("  ✅ PASS: %0d = %0d * %0d + %0d\n", d, quotient, divisor, remainder);
            else
                $display("  ❌ FAIL: %0d ≠ %0d * %0d + %0d\n", d, quotient, divisor, remainder);
        end
    endtask

    initial begin
        $display("Starting RestoringDivider testbench...\n");
        rst = 1;
        start = 0;
        dividend = 0;
        divisor = 0;

        // Apply reset
        @(posedge clk);
        rst = 0;
        @(posedge clk);
        rst = 1;

        // Run several test cases
        run_test(16'd1000, 16'd10);
        run_test(16'd65535, 16'd255);
        run_test(16'd12345, 16'd17);
        run_test(16'd3456, 16'd1);
        run_test(16'd500, 16'd33);
        run_test(16'd0, 16'd15);       // Edge case: 0 / N

        $display("\nTestbench completed.");
        $finish;
    end

endmodule
