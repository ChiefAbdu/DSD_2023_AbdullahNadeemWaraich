module rds_test #(parameter BIT_SIZE = 16) (
    input logic [BIT_SIZE-1:0]  dividend,
    input logic [BIT_SIZE:0]    divisor,
    input logic                 clk,reset,start,
    output logic [BIT_SIZE-1:0] remainder,
    output logic [BIT_SIZE-1:0] quotient,
    output logic                done
);  

    logic [2*BIT_SIZE:0] local_accumulator; // Accumulator = Quotient + Remainder 
    logic [BIT_SIZE:0]   count;
    logic [BIT_SIZE-1:0] local_quotient,local_remainder; //Local Signals for Quotient and Remainder

    logic [3:0] state,next_state;
    localparam IDLE = 4'b0001,
               RUN  = 4'b0010,
               DONE = 4'b0100;

always_ff @(posedge clk)begin
    if(reset)begin
        state <= IDLE;
    end
    else begin
        state <= next_state;
    end
end







always_comb begin

    local_accumulator = accumulator;
    local_dividend = dividend;
    count = BIT_SIZE;

    while (count != 0)begin
        combined = {local_accumulator,local_dividend}; //Joining Both bits
        shifted = combined << 1; //Left Shift for AQ

        //Splitting both parameters back
        local_accumulator = shifted[2*BIT_SIZE:BIT_SIZE+1];
        local_dividend = shifted[BIT_SIZE:1];

        if (local_accumulator[BIT_SIZE] == 1'b1) begin
            local_dividend[0] = 1'b0;
            local_accumulator = local_accumulator + divisor;
        end
        else begin
            local_dividend[0] = 1'b1;
        end
        count = count - 1;
    end
end

endmodule