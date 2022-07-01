`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.06.2022 19:03:31
// Design Name: 
// Module Name: LED_ctrl
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


module LED_ctrl(
    input logic [1:0]sel,
    input logic [7:0]data,
    output logic [7:0]out
    );
    
    always_comb begin
    
        case(sel)
           2'b10: out = data;
           2'b11: out = data; 
           default: out = 8'b0;
           
        endcase
    end
endmodule
