module ClockDivider(
    input logic clk,
    input logic rst,
    output logic clk_out
);
    parameter DIVISOR = 50000000; // Assuming a 50MHz input clock to get a 1Hz output clock
    logic [$clog2(DIVISOR)-1:0] count;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            count <= 0;
            clk_out <= 0;
        end else if (count == DIVISOR - 1) begin
            count <= 0;
            clk_out <= ~clk_out;
        end else begin
            count <= count + 1;
        end
    end
endmodule
