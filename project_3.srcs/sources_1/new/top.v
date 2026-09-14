`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.07.2026 11:27:54
// Design Name: 
// Module Name: top
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

module top #(parameter data_width = 8, addr_width = 4)
(
    input w_clk, r_clk, rst, w_en, r_en,
    output [data_width-1 : 0] r_data,
    input [data_width-1 : 0] w_data,
    output w_full, r_empty
    );
    
    wire [addr_width : 0] w_bptr , w_gptr;
    wire [addr_width : 0] r_bptr , r_gptr;
    wire [addr_width : 0] w_g_sync , r_g_sync;
    
    gray_pointer #(addr_width) write_pointer( .clock(w_clk) , .rst(rst), .en(w_en && !w_full), .b_ptr(w_bptr) , .g_ptr(w_gptr));
    gray_pointer #(addr_width) read_pointer( .clock(r_clk) , .rst(rst), .en(r_en && !r_empty), .b_ptr(r_bptr) , .g_ptr(r_gptr));
    
    sync2ff #(addr_width+1) write_sync( .clock(w_clk) , .rst(rst), .d1(r_gptr) , .q2(r_g_sync));  
    sync2ff #(addr_width+1) read_sync( .clock(r_clk) , .rst(rst), .d1(w_gptr) , .q2(w_g_sync));
    
    assign w_full = (w_gptr[addr_width] != r_g_sync[addr_width]) && (w_gptr[addr_width-1] != r_g_sync[addr_width-1])
                      && (w_gptr[addr_width-2] == r_g_sync[addr_width-2]); 
    assign r_empty = (r_gptr == w_g_sync);
    
    fifo_ram #(data_width , addr_width) RAM( .w_clk(w_clk), .r_clk(r_clk), .w_en(w_en && !w_full), .w_addr(w_bptr[addr_width-1:0]),
               .r_addr(r_bptr[addr_width-1:0]), .w_data(w_data), .r_data(r_data));
endmodule