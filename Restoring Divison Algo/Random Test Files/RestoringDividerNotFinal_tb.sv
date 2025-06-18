`timescale 1ns / 1ps

module RestoringDividerFinal_tb;

    logic clk;
    logic rst;
    logic start;
    logic toggle;
    logic push;
    logic [15:0] user_input;
    logic [15:0] quotient;
    logic [15:0] remainder;
    logic valid;
    logic [6:0] seg;
    logic [7:0] an;

    // Instantiate DUT
    RestoringDividerFinal    uut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .toggle(toggle),
        .push(push),
        .user_input(user_input),
        .quotient(quotient),
        .remainder(remainder),
        .valid(valid),
        .seg(seg),
        .an(an)
    );

    // Clock generation
    always #5 clk = ~clk;

    task reset_dut();
        begin
            rst = 1;
            start = 0;
            toggle = 0;
            push = 0;
            user_input = 16'd0;
            #20;
            rst = 0;
        end
    endtask

    task load_inputs(input [15:0] divd, input [15:0] divs);
        begin
            // Load dividend
            toggle = 0;
            user_input = divd;
            push = 1;
            #10;
            push = 0;
            #10;

            // Load divisor
            toggle = 1;
            user_input = divs;
            push = 1;
            #10;
            push = 0;
            #10;
        end
    endtask

    task start_division();
        begin
            start = 1;
            #10;
            start = 0;
        end
    endtask

    initial begin
        $display("Starting testbench...");
        clk = 0;

        // Test Case 1: 100 / 3
        reset_dut();
        load_inputs(16'd100, 16'd3);
        start_division();

        wait (valid);
        #10;
        $display("Test 1: 100 / 3");
        $display("Quotient = %0d, Remainder = %0d", quotient, remainder);

        // Test Case 2: 255 / 15
        reset_dut();
        load_inputs(16'd255, 16'd15);
        start_division();

        wait (valid);
        #10;
        $display("Test 2: 255 / 15");
        $display("Quotient = %0d, Remainder = %0d", quotient, remainder);

        // Test Case 3: 12345 / 123
        reset_dut();
        load_inputs(16'd12345, 16'd123);
        start_division();

        wait (valid);
        #10;
        $display("Test 3: 12345 / 123");
        $display("Quotient = %0d, Remainder = %0d", quotient, remainder);

        // Test Case 4: Divide by zero
        reset_dut();
        load_inputs(16'd500, 16'd0);
        start_division();

        wait (valid);
        #10;
        $display("Test 4: 500 / 0");
        $display("Quotient = %0d, Remainder = %0d", quotient, remainder);

        $display("All tests completed.");
        $finish;
    end

endmodule
