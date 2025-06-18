`timescale 1ns / 1ps

module full_adder(
    input logic a,      // Input A
    input logic b,      // Input B
    input logic c,      // Input C
    output logic sum,   // Input Sum
    output logic carry  // Input Carry
 );
 
 
 assign sum = (a ^ b) ^ c;                  // Sum Equation
 assign carry = (a & b) | (c & (a ^ b));    // Carry Equation
 
 endmodule