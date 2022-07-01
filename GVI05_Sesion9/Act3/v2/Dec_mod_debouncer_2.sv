`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.06.2022 18:21:12
// Design Name: 
// Module Name: Dec_mod_debouncer_2
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


module Dec_mod_debouncer_2(
    input logic [3:0]sel,
    output logic [1:0]out
    );
    
    always_comb begin
    
        case(sel)
           4'b0001: out = 2'b01;
           4'b0010: out = 2'b01; 
           4'b0100: out = 2'b10; 
           4'b1000: out = 2'b10;
           default: out = 2'b00;
           
        endcase
    end
endmodule
