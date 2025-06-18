module RestoringDividerTest (
    input  logic        clk,
    input  logic        rst,         // Active-low reset
    input  logic        start,
    input  logic        toggle,
    input  logic [15:0] dividend,
    input  logic [15:0] divisor,
    output logic [15:0] quotient,
    output logic [15:0] remainder,
    output logic        valid,
    output logic [6:0]  seg,
    output logic [7:0]  an
);

        logic [3:0] digit0,digit1,digit2,digit3,digit4;


        seven_seg_controller disp (
        .clk(clk),
        .digit0(digit0),
        .digit1(digit1),
        .digit2(digit2),
        .digit3(digit3),
        .digit4(digit4),
        .seg(seg),
        .an(an)
    );


    // State encoding
    typedef enum logic {
        IDLE,         // 1'b0
        DIVIDE        // 1'b1
    } state_t;

    state_t current_state, next_state;

    // 32-bit combined register: [31:16] for remainder (accumulator), [15:0] for quotient
    logic [31:0] combined_reg, next_combined_reg;
    logic [31:0] shifted_reg, temp_reg;

    // 5-bit counter to iterate division steps
    logic [4:0] iteration_count, next_iteration_count;

    // Valid output control
    logic next_valid;

    assign remainder = combined_reg[31:16];
    assign quotient  = combined_reg[15:0];

    // Sequential logic
    always_ff @(posedge clk or negedge rst) begin
        if (rst) begin
            combined_reg     <= 32'd0;
            current_state    <= IDLE;
            iteration_count  <= 5'd0;
            valid            <= 1'b0;
        end else begin
            combined_reg     <= next_combined_reg;
            current_state    <= next_state;
            iteration_count  <= next_iteration_count;
            valid            <= next_valid;
        end
    end

    // Combinational next-state and data logic
    always_comb begin
        // Default assignments
        next_state           = current_state;
        next_combined_reg    = combined_reg;  
        next_iteration_count = iteration_count;
        next_valid           = 1'b0;

        case (current_state)
            IDLE: begin
                next_iteration_count = 5'd0;
                if (start) begin
                    if (divisor == 16'd0) begin
                        next_state        = IDLE;
                        next_combined_reg = {dividend, 16'd0}; // Remainder = dividend, Quotient = 0
                        next_valid        = 1'b1;  // signal valid even though invalid op
                    end else begin
                        next_state        = DIVIDE;
                        next_combined_reg = {16'd0, dividend};  // Zero extend accumulator
                    end
                end else begin
                    next_state        = IDLE;
                    next_combined_reg = 32'd0;
                end
            end


            DIVIDE: begin
                // Step 1: Left shift combined register
                shifted_reg = combined_reg << 1;

                // Step 2: Subtract divisor from upper nibble (accumulator)
                temp_reg = {shifted_reg[31:16] - divisor, shifted_reg[15:0]};

                // Step 3: Check sign and restore if necessary
                if (temp_reg[31]) begin
                    // Restore: keep original and set quotient LSB to 0
                    next_combined_reg = {shifted_reg[31:16], shifted_reg[15:1], 1'b0};
                end else begin
                    // Keep subtraction result and set quotient LSB to 1
                    next_combined_reg = {temp_reg[31:16], shifted_reg[15:1], 1'b1};
                end

                // Step 4: Counter and completion check
                next_iteration_count = iteration_count + 1;

                if (iteration_count == 5'd15) begin  // After 16 cycles
                    next_state = IDLE;
                    next_valid = 1'b1;
                end else begin
                    next_state = DIVIDE;
                    next_valid = 1'b0;
                end
            end
        endcase
    end

        always_ff @(posedge clk)begin   
            if (toggle) begin
                digit0 <= remainder / 10000;                // Ten-thousands
                digit1 <= (remainder / 1000) % 10;          // Thousands
                digit2 <= (remainder / 100)  % 10;          // Hundreds
                digit3 <= (remainder / 10)   % 10;          // Tens
                digit4 <= remainder % 10;                   // Ones
            end 
            else begin
                digit0 <= quotient / 10000;                // Ten-thousands
                digit1 <= (quotient / 1000) % 10;          // Thousands
                digit2 <= (quotient / 100)  % 10;          // Hundreds
                digit3 <= (quotient / 10)   % 10;          // Tens
                digit4 <= quotient % 10;                   // Ones
            end
        end
endmodule

module seven_seg_controller (
    input  logic clk,
    input  logic [3:0] digit0, digit1, digit2, digit3, digit4,
    output logic [6:0] seg,
    output logic [7:0] an
);

    logic [3:0] digit;
    logic [2:0] sel;
    logic [16:0] clkdiv;

    always_ff @(posedge clk)
        clkdiv <= clkdiv + 1;

    assign sel = clkdiv[16:14];

    always_comb begin
        case (sel)
            3'd0: begin an = 8'b11111110; digit = digit0; end
            3'd1: begin an = 8'b11111101; digit = digit1; end
            3'd2: begin an = 8'b11111011; digit = digit2; end
            3'd3: begin an = 8'b11110111; digit = digit3; end
            3'd4: begin an = 8'b11101111; digit = digit4; end
            default: begin an = 8'b11111111; digit = 4'd0; end
        endcase

        case (digit)
            4'd0: seg = 7'b1000000;
            4'd1: seg = 7'b1111001;
            4'd2: seg = 7'b0100100;
            4'd3: seg = 7'b0110000;
            4'd4: seg = 7'b0011001;
            4'd5: seg = 7'b0010010;
            4'd6: seg = 7'b0000010;
            4'd7: seg = 7'b1111000;
            4'd8: seg = 7'b0000000;
            4'd9: seg = 7'b0011000;
            4'hA: seg = 7'b0001000;  // A
            4'hB: seg = 7'b0000011;  // B
            4'hC: seg = 7'b1000110;  // C
            4'hD: seg = 7'b0100001;  // D
            4'hE: seg = 7'b0000110;  // E
            4'hF: seg = 7'b0001110;  // F
            default: seg = 7'b0111111; // -
        endcase
    end

endmodule
