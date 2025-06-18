module restoring_division #(parameter BIT_SIZE = 16) (
    input logic clk,
    input logic reset,
    input logic start,           // Signal to start the division
    input logic [BIT_SIZE-1:0] dividend,  // Dividend
    input logic [BIT_SIZE:0] divisor,     // Divisor (signed)
    output logic [BIT_SIZE-1:0] quotient, // Quotient
    output logic [BIT_SIZE-1:0] remainder, // Remainder
    output logic done            // Indicates the operation is finished
);

    // State variables
    logic [2*BIT_SIZE-1:0] accumulator;  // Accumulator (Dividend + Remainder)
    logic [BIT_SIZE-1:0] q;              // Quotient
    logic [BIT_SIZE-1:0] r;              // Remainder (internal)

    // Control signals
    reg [3:0] state, next_state;  // State machine states
    localparam IDLE     = 4'b0001,
               RUN      = 4'b0010,
               DONE     = 4'b0100;

    // State machine logic
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    // Next state logic
    always_ff @(state or start or accumulator or q or r) begin
        case (state)
            IDLE: begin
                if (start) 
                    next_state = RUN;
                else
                    next_state = IDLE;
            end

            RUN: begin
                if (r == 0)  // Termination condition when all bits are processed
                    next_state = DONE;
                else
                    next_state = RUN;
            end

            DONE: begin
                next_state = DONE;  // Once done, stay in DONE state
            end

            default: next_state = IDLE;
        endcase
    end

    // Division algorithm logic
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            accumulator <= 0;
            q <= 0;
            r <= 0;
            done <= 0;
        end else begin
            case (state)
                IDLE: begin
                    accumulator <= 0;
                    q <= 0;
                    r <= dividend;  // Initialize remainder to dividend
                    done <= 0;
                end

                RUN: begin
                    // Shift left the accumulator (qu = quotient, remainder)
                    accumulator <= {r[BIT_SIZE-2:0], q}; 

                    // Subtract the divisor from the accumulator
                    if (accumulator[2*BIT_SIZE-1:BIT_SIZE] >= divisor) begin
                        accumulator[2*BIT_SIZE-1:BIT_SIZE] <= accumulator[2*BIT_SIZE-1:BIT_SIZE] - divisor;
                        q <= {q[BIT_SIZE-2:0], 1'b1};  // Append 1 to quotient
                    end else begin
                        q <= {q[BIT_SIZE-2:0], 1'b0};  // Append 0 to quotient
                    end
                end

                DONE: begin
                    remainder <= accumulator[BIT_SIZE-1:0];  // Save the remainder
                    quotient <= q;  // Save the quotient
                    done <= 1;  // Signal that division is done
                end

                default: begin
                    done <= 0;
                end
            endcase
        end
    end
endmodule
