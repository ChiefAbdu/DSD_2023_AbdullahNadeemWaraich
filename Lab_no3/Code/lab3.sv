`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/28/2025 03:35:38 PM
// Design Name: 
// Module Name: lab3
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


module lab3(
    input logic a,b,c,
    output logic x,y
);

    logic not_out,nand_out,or_out1,xor_out;
    
    always_comb begin    
      not_out = ~c;
      or_out1 = a | b;
      nand_out = ~(a & b);
      xor_out = nand_out ^ or_out1;
      x = not_out ^ or_out1;
      y = or_out1 & xor_out ;
      end

endmodule