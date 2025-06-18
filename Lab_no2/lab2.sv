`timescale 1ns / 1ps

module lab2(
    input logic a,b,c,                          // Inputs A,B,C
    output logic x,y                            // Outputs X,Y
);

    logic not_out,nand_out,or_out1,xor_out;     // Local Signals
    
    always_comb begin                           // Combinational Block
      not_out = ~c;                             
      or_out1 = a | b;
      nand_out = ~(a & b);
      xor_out = nand_out ^ or_out1;
      x = not_out ^ or_out1;
      y = or_out1 & xor_out ;
      end

endmodule