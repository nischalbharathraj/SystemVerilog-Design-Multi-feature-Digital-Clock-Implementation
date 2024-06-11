module tb_DigitalClock;
    logic clk;
    logic rst;
    logic alarm_set;
    logic [3:0] alarm_hh;
    logic [3:0] alarm_mm;
    logic sw_start;
    logic sw_reset;
    logic [6:0] seg_hh1, seg_hh2, seg_mm1, seg_mm2, seg_ss1, seg_ss2;
    logic [6:0] seg_sw_mm1, seg_sw_mm2, seg_sw_ss1, seg_sw_ss2;
    logic alarm_trigger;

    // Instantiate the Digital Clock with Stopwatch
    DigitalClockWithStopwatch dut (
        .clk(clk),
        .rst(rst),
        .alarm_set(alarm_set),
        .alarm_hh(alarm_hh),
        .alarm_mm(alarm_mm),
        .sw_start(sw_start),
        .sw_reset(sw_reset),
        .seg_hh1(seg_hh1),
        .seg_hh2(seg_hh2),
        .seg_mm1(seg_mm1),
        .seg_mm2(seg_mm2),
        .seg_ss1(seg_ss1),
        .seg_ss2(seg_ss2),
        .seg_sw_mm1(seg_sw_mm1),
        .seg_sw_mm2(seg_sw_mm2),
        .seg_sw_ss1(seg_sw_ss1),
        .seg_sw_ss2(seg_sw_ss2),
        .alarm_trigger(alarm_trigger)
    );

    // Clock generation
    always #10 clk = ~clk;

    initial begin
        // Initialize signals
        clk = 0;
        rst = 1;
        alarm_set = 0;
        alarm_hh = 4'd0;
        alarm_mm = 4'd1;
        sw_start = 0;
        sw_reset = 0;

        // Release reset
        #50;
        rst = 0;

        // Set alarm
        #100;
        alarm_set = 1;

        // Start stopwatch
        #200;
        sw_start = 1;

        // Stop stopwatch
        #1000;
        sw_start = 0;

        // Reset stopwatch
        #200;
        sw_reset = 1;

        // Observe alarm trigger
        #10000;
        $stop;
    end
endmodule
