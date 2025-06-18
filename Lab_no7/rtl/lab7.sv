`timescale 1ns / 1ps


// =======================================================
//       Seven Seg Display (All Anodes On Together)
// =======================================================

module lab7(
    input logic clk, reset, write,       // Clock, write and reset signals  
    input logic [2:0] sel,               // Stored on Which Seven Segment
    input logic [3:0] num,               // Number you want to display  
    output logic [6:0] seg,              
    output logic [7:0] an                  
);
    
    reg [3:0] registers [7:0];          // Registers to store numb  
    logic [3:0] stored_num;             // The numbers stored
    logic clk_100Hz;                    // Slowed Clock Signal
    logic [2:0] active_sel = 0;         // Local Selector
    logic [2:0] new_sel = 0;            // Updated Selector
    

    // If Write recieved, update new_sel to the value inputed (of sel) otherwise cycle through the anodes(Displays)

    always_comb begin                   
        if (write)
            new_sel= sel;
        else
            new_sel= active_sel;
    end


    // Slowed Clock, Outputs a clock edge after 2^16 cycles essentialy converting the 100 MHz clock to 800 Hz Clock
    // Done so it is visible to a normal human (like you)

    reg [16:0] clk_div_count = 0;

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            clk_div_count <= 0;
            clk_100Hz <= 0;
        end else if (clk_div_count == 65535) begin      // This value corresponds to the comment on line 66
            clk_div_count <= 0;
            clk_100Hz <= ~clk_100Hz;
        end else begin
            clk_div_count <= clk_div_count + 1;
        end
    end
    
    // Stores 0's in the segments until write is turned on to store the value (num) Inputed by the user.
    // If write is on, stores the value given. If reset signal is given, resets all the segments which previously 
    // had a value to 0.

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            for (int i = 0; i < 8; i = i + 1)
                registers[i] <= 4'b0000;    
        end else if (write) begin
            registers[sel] <= num;         
        end
    end

    // Increments active_sel by 1 to cycle through all the segments (starts from 1st segment upto 8th over and over).
    // If reset is given starts the cycle again from the 1st segment.
    // Will not be noticable to a human eye due to the speed of the clock.
    // (You can see/visualize it by slowing the clock, to do this change the value 65535 to 2^20 or anything)

    always_ff @(posedge clk_100Hz or posedge reset) begin
        if (reset) begin
            active_sel <= 0;
        end else begin
            active_sel <= active_sel + 1;
        end
    end

    assign stored_num = registers[new_sel];

    // Decoder to change the stored value from binary to Decimal and display on the Segment.

    always_comb begin
        case (stored_num)
             4'h0: seg = 7'b1000000;
             4'h1: seg = 7'b1111001;
             4'h2: seg = 7'b0100100;
             4'h3: seg = 7'b0110000;
             4'h4: seg = 7'b0011001;
             4'h5: seg = 7'b0010010;
             4'h6: seg = 7'b0000010;
             4'h7: seg = 7'b1111000;
             4'h8: seg = 7'b0000000;
             4'h9: seg = 7'b0010000;
             4'hA: seg = 7'b0001000;
             4'hB: seg = 7'b0000011;
             4'hC: seg = 7'b1000110;
             4'hD: seg = 7'b0100001;
             4'hE: seg = 7'b0000110;
             4'hF: seg = 7'b0001110;
             default: seg = 7'b1111111; 
        endcase
    end

    // Decoder to Select the Segment where you want to store the value.

    always_comb begin
    an = 8'b1111_1111;  
    case (new_sel)
        3'b000: an = 8'b1111_1110; 
        3'b001: an = 8'b1111_1101; 
        3'b010: an = 8'b1111_1011;
        3'b011: an = 8'b1111_0111; 
        3'b100: an = 8'b1110_1111;
        3'b101: an = 8'b1101_1111; 
        3'b110: an = 8'b1011_1111; 
        3'b111: an = 8'b0111_1111; 
        default: an = 8'b1111_1111; 
    endcase
end

endmodule