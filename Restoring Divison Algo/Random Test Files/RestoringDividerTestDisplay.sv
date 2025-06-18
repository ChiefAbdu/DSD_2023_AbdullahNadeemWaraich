module RestoringDividerTest (
    input  logic        clk,
    input  logic        rst,         // Active-high reset
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

        seven_seg_controller disp (
        .clk(clk),
        .rst(rst),
        .remainder(remainder),
        .quotient(quotient),
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
    always_ff @(posedge clk or posedge rst) begin
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
endmodule

module seven_seg_controller (
    input  logic clk,
    input  logic rst,
    input  logic [15:0] remainder,
    input  logic [15:0] quotient,
    output logic [6:0] seg,
    output logic [7:0] an
);

    logic clk_100Hz;   
    logic [3:0] digit;
    logic [2:0] active_sel;
    reg [16:0] clk_div_count = 0;
    logic [3:0] r_digit0,r_digit1,r_digit2,r_digit3; // Digit 0 is Most Significat, Digit 3 is Least Significant for remainder
    logic [3:0] q_digit0,q_digit1,q_digit2,q_digit3; // Digit 0 is Most Significat, Digit 3 is Least Significant for quoitent


            assign r_digit0 = remainder[15:12];  //MSB
            assign r_digit1 = remainder[11:8];
            assign r_digit2 = remainder[7:4];
            assign r_digit3 = remainder[3:0];   //LSB
       
            assign q_digit0 = quotient[15:12]; // MSB
            assign q_digit1 = quotient[11:8];
            assign q_digit2 = quotient[7:4];
            assign q_digit3 = quotient[3:0];   // LSB
       

        always_ff @(posedge clk or posedge rst) begin
            if (rst) begin
                clk_div_count <= 0;
                clk_100Hz <= 0;
            end else if (clk_div_count == 65535) begin
                clk_div_count <= 0;
                clk_100Hz <= ~clk_100Hz;
            end else begin
                clk_div_count <= clk_div_count + 1;
            end
        end

    always_ff @(posedge clk_100Hz or posedge rst) begin
        if (rst) begin
            active_sel <= 0;
        end else begin
            active_sel <= active_sel + 1;
        end
    end

    always_comb begin
        case (active_sel)
    
            3'd0: begin an = 8'b11111110; digit = r_digit0; end
            3'd1: begin an = 8'b11111101; digit = r_digit1; end
            3'd2: begin an = 8'b11111011; digit = r_digit2; end
            3'd3: begin an = 8'b11110111; digit = r_digit3; end
            3'd4: begin an = 8'b11101111; digit = q_digit0; end
            3'd5: begin an = 8'b11011111; digit = q_digit1; end
            3'd6: begin an = 8'b10111111; digit = q_digit2; end
            3'd7: begin an = 8'b01111111; digit = q_digit3; end
                    
        endcase

        case (digit)
            4'h0: seg = 7'b1000000;
            4'h1: seg = 7'b1111001;
            4'h2: seg = 7'b0100100;
            4'h3: seg = 7'b0110000;
            4'h4: seg = 7'b0011001;
            4'h5: seg = 7'b0010010;
            4'h6: seg = 7'b0000010;
            4'h7: seg = 7'b1111000;
            4'h8: seg = 7'b0000000;
            4'h9: seg = 7'b0011000;
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
