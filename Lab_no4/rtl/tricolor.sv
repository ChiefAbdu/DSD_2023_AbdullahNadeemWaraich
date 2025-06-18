`timescale 1ns / 1ps

module tricolor(
    input logic [1:0] a,            // Input A
    input logic [1:0] b,            // Input B
    output logic red,green,blue     // Output RGB (LEDs)
);

    // Equations of Red, Green, Blue derived from K-Maps.

    assign red = (a[1] & ~b[0]) | (a[1] & ~b[1]) | (a[0] & a[1]) | (~b[0] & ~b[1]) | (a[0] & ~b[1]); 
    
    assign blue = (~a[0] & b[0]) | (a[1] & ~b[1]) | (a[0] & ~b[0]) | (~a[1] & b[1]);

    assign green = (~a[0] & ~a[1]) | (~a[0] & b[1]) | (b[0] & b[1]) | (~a[1] & b[1]) | (~a[1] & b[0]);

endmodule

