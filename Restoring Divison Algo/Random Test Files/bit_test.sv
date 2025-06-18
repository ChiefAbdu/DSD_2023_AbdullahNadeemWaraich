module bit_test #(paramter BIT = 16)(
    input logic [BIT:0] number,
);

    logic [BIT:0] actual1,actual2,actual3,actual4;
    integer i;

    actual = size(8'b01011010)
    $display ("actual = %b", actual);

    actual1 = size(3'b110)
    $display ("actual1 = %b", actual1);

    actual2 = size(11'b00011010111)
    $display ("actual2 = %b", actual2);


function size(logic [BIT:0] number)
    always_comb begin
        for(i=0;i<BIT;i++) begin
            if number[i] = 1'b1;
                return i;
            else return 0;
        end