`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.06.2022 21:32:56
// Design Name: 
// Module Name: mux_led
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


module mux_led(
    input logic [1:0]sel,
    input logic [15:0]data0,
    input logic [15:0]data1,
    output logic [15:0]out
    );
    
    always_comb begin
    
        case(sel)
           2'b01: out = {12'b0, data1[3:0]};
           2'b10: out = data1;
           default: out = data0;
           
        endcase
    end
endmodule

