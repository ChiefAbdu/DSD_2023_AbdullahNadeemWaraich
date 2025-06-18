`timescale 1ns / 1ps

// =======================================================
//  Seven Seg Display (All Anodes On Together) Test Bench
// =======================================================


module lab7_tb;
    
    reg [2:0] sel;
    reg [3:0] num;
    reg clk, reset, write;
    wire [6:0] seg;
    wire [7:0] anode;
    wire DP;
    
    lab7 uut (
        .sel(sel),
        .num(num),
        .clk(clk),
        .reset(reset),
        .write(write),
        .seg(seg),
        .anode(anode),
        .DP(DP)
    );
    
    always #5 clk = ~clk; // Generate clock with 10ns period
    
    task initialize;
        begin
            clk = 0;
            reset = 1;
            write = 0;
            sel = 3'b000;
            num = 4'b0000;
            #10 reset = 0;
        end
    endtask
    
    task write_data(input [2:0] t_sel, input [3:0] t_num);
        begin
            sel = t_sel;
            num = t_num;
            write = 1;
            #10 write = 0;
        end
    endtask
    
    initial begin
        // Test all possible values for sel and num
        int i, j;
        for (i = 0; i < 8; i = i++) begin
            for (j = 0; j < 16; j++) begin
                write_data(i, j);
            end
        end
        
        // Observe output for some time
        #200;
        $stop;
    end
endmodule
