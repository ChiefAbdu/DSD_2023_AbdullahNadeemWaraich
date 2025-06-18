`timescale 1ns / 1ps

// =======================================================
//               Seven Segment Behavioral
// =======================================================

module SevenSegBehavioral(
        input logic [3:0] num,
        input logic [2:0] sel,
        output logic [6:0] seg,
        output logic DP,
        output logic [7:0] anode
    );
    
    always_comb begin //Equations for All 8 segments
        
        seg[0] = (~num[3] & ~num[2] & ~num[1] & num[0]) | (~num[3] & num[2] & ~num[1] & ~num[0]) | 
                (num[3] & num[2] & ~num[1] & num[0]) | (num[3] & ~num[2] & num[1] & num[0]);//Seg A
        
        seg[1] = (num[2] & num[1] & ~num[0]) | (num[3] & num[1] & num[0]) |
                (num[3] & num[2] & ~num[0]) | (~num[3] & num[2] & ~num[1] & num[0]) ;//Seg B
        
        seg[2] = (~num[3] & ~num[2] & num[1] & ~num[0]) | (num[3] & num[2] & num[1]) |
                (num[3] & num[2] & ~num[0]);//Seg C
        
        seg[3] = (~num[3] & num[2] & ~num[1] & ~num[0]) | (~num[3] & ~num[2] & ~num[1] & num[0]) |
                (num[2] & num[1] & num[0]) | (num[3] & ~num[2] & num[1] & ~num[0]);//Seg D
        
        seg[4] = (~num[3] & num[0]) | (~num[2] & ~num[1] & num[0]) |
                (~num[3] & num[2] & ~num[1]);//Seg E
        
        seg[5] = (~num[3] & ~num[2] & num[0]) | (~num[3] & ~num[2] & num[1]) |
                (~num[3] & num[1] & num[0]) | (num[3] & num[2] & ~num[1] & num[0]);//Seg F
        
        seg[6] = (~num[3] & ~num[2] & ~num[1]) | (num[3] & num[2] & ~num[1] & ~num[0]) |
                (~num[3] & num[2] & num[1] & num[0]);;//Seg G
        
        DP = 1;//Seg DP
        
        
        // Equations for Anodes

        anode[0] = (sel[2] | sel[1] | sel[0]);
        anode[1] = (sel[2] | sel[1] | ~sel[0]);
        anode[2] = (sel[2] | ~sel[1] | sel[0]);
        anode[3] = (sel[2] | ~sel[1] | ~sel[0]);
        anode[4] = (~sel[2] | sel[1] | sel[0]);
        anode[5] = (~sel[2] | sel[1] | ~sel[0]);
        anode[6] = (~sel[2] | ~sel[1] | sel[0]);
        anode[7] = (~sel[2] | ~sel[1] | ~sel[0]);

    end
endmodule
