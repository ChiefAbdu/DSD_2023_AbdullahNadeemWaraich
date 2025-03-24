`timescale 1ns / 1ps
module lab7(
    input logic clk, reset, write,         
    input logic [2:0] sel,                
    input logic [3:0] num,                 
    output logic [6:0] seg,              
    output logic [7:0] an                  
);
    
    reg [3:0] registers [7:0];           
    logic [3:0] stored_num;
    logic clk_100Hz;
    logic [2:0] active_sel = 0;
    logic [2:0] new_sel = 0;
    
    always_comb begin
        if (write)
            new_sel= sel;
        else
            new_sel= active_sel;
    end

    reg [16:0] clk_div_count = 0;
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            clk_div_count <= 0;
            clk_100Hz <= 0;
        end else if (clk_div_count == 65535) begin
            clk_div_count <= 0;
            clk_100Hz <= ~clk_100Hz;
        end else begin
            clk_div_count <= clk_div_count + 1;
        end
    end
    

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            for (int i = 0; i < 8; i = i + 1)
                registers[i] <= 4'b0000;    
        end else if (write) begin
            registers[sel] <= num;         
        end
    end

    always_ff @(posedge clk_100Hz or posedge reset) begin
        if (reset) begin
            active_sel <= 0;
        end else begin
            active_sel <= active_sel + 1;
        end
    end
    assign stored_num = registers[new_sel];
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