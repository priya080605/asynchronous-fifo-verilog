`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.07.2026 12:06:39
// Design Name: 
// Module Name: fifo_ram
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


module fifo_ram #(parameter data = 8, addr = 4)
(
    input w_clk, r_clk, w_en,
    input [addr-1:0] w_addr, r_addr,
    input [data-1:0] w_data,
    output reg [data-1:0] r_data
    );
    
    reg [data-1:0] memory [0: (1<<addr)-1];
    
    always @(posedge w_clk) 
        if (w_en) memory[w_addr] <= w_data;
        
    always @(posedge r_clk) 
        r_data <= memory[r_addr];
    
endmodule
