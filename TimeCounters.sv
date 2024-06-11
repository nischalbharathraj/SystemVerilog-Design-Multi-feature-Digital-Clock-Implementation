module TimeCounters(
    input logic clk,
    input logic rst,
    input logic [3:0] alarm_hh,
    input logic [3:0] alarm_mm,
    input logic alarm_set,
    output logic [3:0] hh,
    output logic [3:0] mm,
    output logic [3:0] ss,
    output logic alarm_trigger
);
    logic [3:0] sec_count = 0;
    logic [3:0] min_count = 0;
    logic [3:0] hour_count = 0;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            sec_count <= 0;
            min_count <= 0;
            hour_count <= 0;
            alarm_trigger <= 0;
        end else begin
            if (sec_count == 9) begin
                sec_count <= 0;
                if (min_count == 9) begin
                    min_count <= 0;
                    if (hour_count == 9) begin
                        hour_count <= 0;
                    end else begin
                        hour_count <= hour_count + 1;
                    end
                end else begin
                    min_count <= min_count + 1;
                end
            end else begin
                sec_count <= sec_count + 1;
            end

            // Alarm check
            if (alarm_set && hour_count == alarm_hh && min_count == alarm_mm) begin
                alarm_trigger <= 1;
            end else begin
                alarm_trigger <= 0;
            end
        end
    end

    assign ss = sec_count;
    assign mm = min_count;
    assign hh = hour_count;
endmodule
