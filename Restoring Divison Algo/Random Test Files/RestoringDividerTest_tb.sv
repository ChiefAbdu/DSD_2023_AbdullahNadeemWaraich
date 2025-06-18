`timescale 1ns / 1ps

module RestoringDividerTest_tb;

    logic clk;
    logic rst;
    logic start;
    logic toggle;
    logic [15:0] dividend, divisor;
    logic [15:0] quotient, remainder;
    logic valid;
    logic [6:0] seg;
    logic [7:0] an;
integer i, j;

    // Instantiate the DUT
    RestoringDividerTest uut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .toggle(toggle),
        .dividend(dividend),
        .divisor(divisor),
        .quotient(quotient),
        .remainder(remainder),
        .valid(valid),
        .seg(seg),
        .an(an)
    );

    // Clock generation
    always #5 clk = ~clk;  // 100MHz

    // Task to apply input and check output
    task automatic run_test(input [15:0] d, input [15:0] m);
        begin
            dividend = d;
            divisor  = m;
            start    = 1;
            toggle   = 0;
            @(posedge clk);
            start    = 0;

            // Wait for completion
            wait (valid == 1);
            @(posedge clk);

            if (divisor == 0) begin
                if (quotient !== 16'd0 || remainder !== dividend) begin
                    // Simple textual formatting for failure
                    $display("***** FAIL (Div0): %0d / 0 → Quotient: %0d Remainder: %0d (Expected Q=0, R=%0d) *****",
                        dividend, quotient, remainder, dividend);
                    $stop;  // Stop simulation on failure
                end else begin
                    // Simple textual formatting for pass
                    $display("===== PASS (Div0): %0d / 0 → Q: %0d, R: %0d =====", dividend, quotient, remainder);
                end
            end else begin
                if ((quotient * divisor + remainder) == dividend) begin
                    // Simple textual formatting for pass
                    $display("===== PASS: %0d / %0d = %0d R %0d =====", dividend, divisor, quotient, remainder);
                end else begin
                    // Simple textual formatting for failure
                    $display("***** FAIL: %0d / %0d = %0d R %0d (Expected %0d) *****",
                        dividend, divisor, quotient, remainder, dividend);
                    $stop;  // Stop simulation on failure
                end
            end
        end
    endtask

    initial begin
        clk = 0;
        rst = 0;
        start = 0;
        toggle = 0;
        dividend = 0;
        divisor = 0;

        #20 rst = 1;
        #20

        // Test all combinations of dividend and divisor (0 to 65535)
        // We use nested loops to iterate through all possible values of dividend and divisor.
        for (i = 0; i <= 65535; i = i + 1) begin
            for (j = 0; j <= 65535; j = j + 1) begin
                run_test(i, j);
            end
        end

        #100;
        $finish;
    end

endmodule
