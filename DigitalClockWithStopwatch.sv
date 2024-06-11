module DigitalClockWithStopwatch(
    input logic clk,
    input logic rst,
    input logic alarm_set,
    input logic [3:0] alarm_hh,
    input logic [3:0] alarm_mm,
    input logic sw_start,
    input logic sw_reset,
    output logic [6:0] seg_hh1,
    output logic [6:0] seg_hh2,
    output logic [6:0] seg_mm1,
    output logic [6:0] seg_mm2,
    output logic [6:0] seg_ss1,
    output logic [6:0] seg_ss2,
    output logic [6:0] seg_sw_mm1,
    output logic [6:0] seg_sw_mm2,
    output logic [6:0] seg_sw_ss1,
    output logic [6:0] seg_sw_ss2,
    output logic alarm_trigger
);
    logic clk_1Hz;
    logic [3:0] hh, mm, ss;
    logic [3:0] sw_mm, sw_ss;
    logic sw_running;

    // Instantiate Clock Divider
    ClockDivider clk_div (
        .clk(clk),
        .rst(rst),
        .clk_out(clk_1Hz)
    );

    // Instantiate Time Counters
    TimeCounters time_cnt (
        .clk(clk_1Hz),
        .rst(rst),
        .alarm_hh(alarm_hh),
        .alarm_mm(alarm_mm),
        .alarm_set(alarm_set),
        .hh(hh),
        .mm(mm),
        .ss(ss),
        .alarm_trigger(alarm_trigger)
    );

    // Stopwatch logic
    always_ff @(posedge clk_1Hz or posedge rst) begin
        if (rst) begin
            sw_mm <= 0;
            sw_ss <= 0;
            sw_running <= 0;
        end else if (sw_reset) begin
            sw_mm <= 0;
            sw_ss <= 0;
            sw_running <= 0;
        end else if (sw_start) begin
            sw_running <= 1;
        end else if (sw_running) begin
            if (sw_ss == 9) begin
                sw_ss <= 0;
                if (sw_mm == 9) begin
                    sw_mm <= 0;
                end else begin
                    sw_mm <= sw_mm + 1;
                end
            end else begin
                sw_ss <= sw_ss + 1;
            end
        end
    end

    // Instantiate Seven Segment Displays
    SevenSegmentDisplay disp_hh1 (
        .num(hh / 10),
        .segments(seg_hh1)
    );
    SevenSegmentDisplay disp_hh2 (
        .num(hh % 10),
        .segments(seg_hh2)
    );
    SevenSegmentDisplay disp_mm1 (
        .num(mm / 10),
        .segments(seg_mm1)
    );
    SevenSegmentDisplay disp_mm2 (
        .num(mm % 10),
        .segments(seg_mm2)
    );
    SevenSegmentDisplay disp_ss1 (
        .num(ss / 10),
        .segments(seg_ss1)
    );
    SevenSegmentDisplay disp_ss2 (
        .num(ss % 10),
        .segments(seg_ss2)
    );

    // Stopwatch displays
    SevenSegmentDisplay disp_sw_mm1 (
        .num(sw_mm / 10),
        .segments(seg_sw_mm1)
    );
    SevenSegmentDisplay disp_sw_mm2 (
        .num(sw_mm % 10),
        .segments(seg_sw_mm2)
    );
    SevenSegmentDisplay disp_sw_ss1 (
        .num(sw_ss / 10),
        .segments(seg_sw_ss1)
    );
    SevenSegmentDisplay disp_sw_ss2 (
        .num(sw_ss % 10),
        .segments(seg_sw_ss2)
    );
endmodule
