`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.07.2026 14:01:25
// Design Name: 
// Module Name: testbench
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


`timescale 1ns / 1ps

module testbench;

    parameter DATA_WIDTH = 8;
    parameter ADDR_WIDTH = 4;
    parameter DEPTH      = 1 << ADDR_WIDTH;

    reg  wr_clk, rd_clk, rst_n;
    reg  wr_en, rd_en;
    reg  [DATA_WIDTH-1:0] wr_data;
    wire [DATA_WIDTH-1:0] rd_data;
    wire wr_full, rd_empty;

    reg  [DATA_WIDTH-1:0] ref_mem [0:255];
    integer wptr = 0;
    integer rptr = 0;
    reg  [DATA_WIDTH-1:0] expected;
    reg started;
    integer errors = 0;

    top #(.data_width(DATA_WIDTH), .addr_width(ADDR_WIDTH)) dut (
        .w_clk(wr_clk), .r_clk(rd_clk), .rst(rst_n),
        .w_en(wr_en), .r_en(rd_en),
        .w_data(wr_data), .r_data(rd_data),
        .w_full(wr_full), .r_empty(rd_empty)
    );

    initial wr_clk = 0;
    always #5 wr_clk = ~wr_clk;

    initial begin
        rd_clk = 0;
        #4;
    forever #8.5 rd_clk = ~rd_clk;
    end 
    
    initial begin
        rst_n = 0;
        wr_en = 0; rd_en = 0; wr_data = 0;started=0;
        repeat (4) @(posedge wr_clk);
        rst_n = 1;
    end

    reg wr_active;
    initial wr_active = 0;

    initial begin
        wait (rst_n == 1);
        wr_active = 1;
        repeat (30) @(posedge wr_clk);
        wr_active = 0;
    end

    always @(negedge wr_clk) begin
        if (wr_active && !wr_full) begin
            wr_en   <= 1;
            wr_data <= $random;
        end else begin
            wr_en <= 0;
        end
    end

    always @(posedge wr_clk) begin
        if (wr_en) begin
            ref_mem[wptr] = wr_data;
            wptr = wptr + 1;
        end
    end

    // ===================== READ + CHECK =====================
   initial begin
        wait(rst_n==1);
        repeat (5)@(posedge rd_clk);
        started=1; 
   end
   always@(negedge rd_clk) begin
    if  (started && !rd_empty)
              rd_en<=1;
    else 
               rd_en<=0;
   end

    reg rd_valid_d;
    initial rd_valid_d = 0;
    always @(posedge rd_clk) begin
        rd_valid_d <= (rd_en && !rd_empty);
    end

    always @(posedge rd_clk) begin
        if (rd_valid_d) begin
            if (rptr < wptr) begin
                expected = ref_mem[rptr];
                rptr = rptr + 1;
                if (rd_data !== expected) begin
                    $display("ERROR: idx=%0d expected=%0h got=%0h time=%0t", rptr-1, expected, rd_data, $time);
                    errors = errors + 1;
                end else begin
                    $display("PASS: idx=%0d read %0h time=%0t", rptr-1, rd_data, $time);
                end
            end
        end
       
    end

    // ===================== finish condition =====================
    initial begin
        #2000;
        if (errors == 0)
            $display("TEST PASSED - all data matched, no errors");
        else
            $display("TEST FAILED - %0d mismatches", errors);
        $finish;
    end

endmodule