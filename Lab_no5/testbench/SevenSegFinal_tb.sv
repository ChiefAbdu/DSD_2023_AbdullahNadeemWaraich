`timescale 1ns / 1ps

// =======================================================
//           Seven Seg (Self-Testing Test Bench)
// =======================================================


module SevenSegFinal_tb();
    logic [3:0] num;
    logic [2:0] sel;
    logic [6:0] seg;
    logic [7:0] anode;
SevenSegFinal uut( 
    .num(num),
    .sel(sel),
    .seg(seg),
    .anode(anode)
);

task driver(logic [3:0] number = $random, logic [2:0] selector = $random);
        num = number;
        sel = selector;
        #10;
endtask

task direct_test(logic [3:0] num, logic [2:0] sel);
    begin
        driver(num,sel);
    end
endtask

task random_test(input int n);
    for(int i=0 ; i<n ; i++)
    begin
        driver();
    end
endtask  

task monitor();
        begin
            $monitor("Time: %0t | num = %b, sel = %b, seg = %b, anode = %b", 
                     $time, num, sel, seg, anode);
        end
    endtask

initial begin
    
        monitor();
        
        direct_test(4'hA,3'b010);
        direct_test(4'h2,3'b001);
        
        random_test(10);
       
        $finish;    
        end
endmodule