module RestoringDividerTest_tb;

    logic clk, rst, start, toggle;
    logic [15:0] dividend, divisor;
    logic [15:0] quotient, remainder;
    logic valid;
    logic [6:0] seg;
    logic [7:0] an;

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

    always #5 clk = ~clk;

    initial begin
        // Initialize
        clk = 0; rst = 1; start = 0; toggle = 0;
        dividend = 16'd100;
        divisor  = 16'd7;
        #20 rst = 0;
        #20 start = 1;
        #10 start = 0;

        // Wait for valid signal
        wait (valid);
        #100;

        $display("Quotient: %0d", quotient);
        $display("Remainder: %0d", remainder);

        $stop;
    end
endmodule
