`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/09/2025 10:39:17 PM
// Design Name: 
// Module Name: lab3_tb
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


module lab3_tb();
logic a,b,c;
logic x,y;

lab3 UUT(
    .a(a),
    .b(b),
    .c(c),
    .y(y),
    .x(x)
);

initial begin
    a = 0;b = 0;c = 0;
    #10;
    a = 0;b = 0;c = 1;
    #10;
    a = 0;b = 1;c = 0;
    #10;
    a = 0;b = 1;c = 1;
    #10;
    a = 1;b = 0;c = 0;
    #10;
    a = 1;b = 0;c = 1;
    #10;
    a = 1;b = 1;c = 0;
    #10;
    a = 1;b = 1;c = 1;   
    #10;
$finish;
end
initial begin
    $monitor("a=%b, b=%b, c=%b => x=%b, y=%b", a, b, c, x, y);
    end
endmodule
