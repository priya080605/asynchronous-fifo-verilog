`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.07.2026 11:02:47
// Design Name: 
// Module Name: gray_pointer
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


module gray_pointer #(parameter width = 4)
(
    input clock, rst, en,
    output reg [width:0] b_ptr, g_ptr               // msb is wrap bit for full empty logic
    );
    
    wire [width:0] b_next, g_next;
    
    assign b_next = b_ptr + (en ? 1'b1 : 1'b0);
    assign g_next = (b_next >> 1) ^ b_next; 
    
    always @(posedge clock or negedge rst) begin
        if (!rst) begin 
            b_ptr <=0;
            g_ptr <=0;
        end 
        else begin
            b_ptr <= b_next;
            g_ptr <= g_next;
        end
    end

endmodule
