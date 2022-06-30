`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.06.2022 19:43:30
// Design Name: 
// Module Name: mux_2_1_16b
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

module mux_2_1_16b #(parameter N = 16)(
    input  logic [N-1:0] A,
    input  logic [N-1:0] B,
    input  logic         sel,

    output logic [N-1:0] out  // valor de salida para el Display
    );

    always_comb begin
        if (sel)
            out = B;
        else
            out = A;
        
    end

endmodule
