`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.07.2026 11:17:38
// Design Name: 
// Module Name: sync2ff
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


module sync2ff #(parameter width = 5)
(
    input clock, rst,
    input [width-1 :0] d1,
    output reg [width-1 :0] q2
    );
    
    reg [width-1 :0] q1;
    
    always @(posedge clock or negedge rst) begin
        if (!rst) begin
            q1 <= 0;
            q2 <= 0;
         end 
         else begin
            q1 <= d1;
            q2 <= q1;
         end
    end
        
endmodule
