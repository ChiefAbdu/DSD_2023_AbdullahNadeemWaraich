`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/11/2025 02:37:36 PM
// Design Name: 
// Module Name: tricolor_test_tb
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


module tricolor_test_tb();
    
    logic [1:0] a;
    logic [1:0] b;
    logic red,green,blue;

tricolor uut( 
    .a(a),
    .b(b),
    .red(red),
    .green(green),
    .blue(blue)
);

initial begin 
    a = 2'b00; b = 2'b00;
    #10; a = 2'b00; b = 2'b01;
    #10; a = 2'b00; b = 2'b10;
    #10; a = 2'b00; b = 2'b11;
    #10; a = 2'b01; b = 2'b00;
    #10; a = 2'b01; b = 2'b01;
    #10; a = 2'b01; b = 2'b10;
    #10; a = 2'b01; b = 2'b11;
    #10; a = 2'b10; b = 2'b00;
    #10; a = 2'b10; b = 2'b01;
    #10; a = 2'b10; b = 2'b10;
    #10; a = 2'b10; b = 2'b11;
    #10; a = 2'b11; b = 2'b00;
    #10; a = 2'b11; b = 2'b01;
    #10; a = 2'b11; b = 2'b10;
    #10; a = 2'b11; b = 2'b11;
    #10;
    
    $finish;
    end
endmodule
