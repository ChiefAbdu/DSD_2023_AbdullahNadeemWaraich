`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/19/2025 11:32:28 PM
// Design Name: 
// Module Name: SevenSegDecoder
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


module SevenSegDecoder(
    input logic [2:0] sel,
    output logic [7:0] anode
    );
    
    always_comb begin
        anode = 8'b11111111; //All Segments Off
        
        case(sel)
            3'b000 : anode = 'b11111110;
            3'b001 : anode = 'b11111101;
            3'b010 : anode = 'b11111011;
            3'b011 : anode = 'b11110111;
            3'b100 : anode = 'b11101111;
            3'b101 : anode = 'b11011111;
            3'b110 : anode = 'b10111111;
            3'b111 : anode = 'b01111111;
        endcase
    end   
endmodule
