`timescale 1ns / 1ps


// =======================================================
//                 Seven Segment Final 
// =======================================================

module SevenSegFinal(
    input  logic [3:0] num,     // The Number you want to display 
    input  logic [2:0] sel,     // The Segment on which you want to display
    output logic [6:0] seg, 
    output logic DP,   
    output logic [7:0] anode
);

    SevenSegSegment seg_decoder (
        .num(num),
        .seg(seg)
    );
    
    SevenSegAnode anode_decoder (
        .sel(sel),
        .anode(anode)
    );

endmodule

