`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.06.2022 19:03:46
// Design Name: 
// Module Name: AN_ctrl
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


module AN_ctrl(
    input logic [1:0]sel,
    input logic [7:0]data0,
    input logic [7:0]data1,
    output logic [7:0]out
    );
    
    always_comb begin
    
        case(sel)
           2'b00: out = data1;
           2'b01: out = data0;
           2'b10: out = 8'hff; 
           default: out = data1;
           
        endcase
    end
endmodule
