`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.06.2022 19:02:46
// Design Name: 
// Module Name: Seg_ctrl
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


module Seg_ctrl(
    input logic [1:0]sel,
    input logic [6:0]data0,
    input logic [6:0]data1,
    output logic [6:0]out
    );
    
    always_comb begin
    
        case(sel)
           2'b00: out = data1;
           2'b01: out = data0;
           2'b10: out = 7'b1111111; 
           default: out = data0;
           
        endcase
    end
endmodule
