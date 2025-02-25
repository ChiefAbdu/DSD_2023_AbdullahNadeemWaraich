`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/19/2025 11:37:56 PM
// Design Name: 
// Module Name: SevenSegFinal
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


module SevenSegFinal(
    input  logic [3:0] num,   
    input  logic [2:0] sel,    
    output logic [6:0] seg, 
    output logic DP,   
    output logic [7:0] anode
);

    SevenSeg seg_decoder (
        .num(num),
        .seg(seg)
    );
    
    SevenSegDecoder anode_decoder (
        .sel(sel),
        .anode(anode)
    );

endmodule

