`timescale 1ns / 1ps

// =======================================================
//                Seven Seg (Anode Decoder)
// =======================================================

module SevenSegAnode(
    input logic [2:0] sel,          // 3 Bit Selector Input
    output logic [7:0] anode        // 8 Bit Anode Output
    );
    
    // Decodes the 3 bit input into 8 bit outputs, each 3 bit input control a different anode, 
    // e.g sel = 3'b101 would turn on the 3rd anode(Seven Segment Display)

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
