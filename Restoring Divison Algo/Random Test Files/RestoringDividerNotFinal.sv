module RestoringDividerFinal (
    input  logic        clk,         // Clock
    input  logic        rst,         // Active-high reset
    input  logic        start,       // Start Divison once start is give (when the values of Divisor and Dividened are stored)   
    input  logic        toggle,      // Switch between Dividened and Divisor Input
    input  logic        push,        // Push Values to the registers
    input  logic [15:0] user_input,  // Input from User
    output logic [15:0] quotient,
    output logic [15:0] remainder,
    output logic        valid,
    output logic [6:0]  seg,
    output logic [7:0]  an
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

    logic [15:0] divisor; 
    logic [15:0] dividend;

    always_ff@(posedge clk or posedge rst) begin
        if (rst) begin
            divisor <= 16'd0;
            dividend <= 16'd0;
        end else if (push) begin
            if (toggle) begin
                divisor <= user_input;
            end else begin
                dividend <= user_input;
            end        
        end
    end



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

