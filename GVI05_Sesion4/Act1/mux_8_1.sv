`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// University: Universidad Tecnica Federico Santa Maria
// Course: ELO212
// Students: Cristobal Caqueo, Bastian Rivas, Claudio Zanetta
// 
// Create Date: 03/05/2022
// Design Name: Guia 4
// Module Name: mux_8_1
// Project Name: mux_multiples_displays
// Target Devices: xc7a100tcsg324-1
// Tool Versions: Vivado 2021.1
// Description: Multiplexor de 8 entradas de 4 bits 
// 
// Dependencies: Lab Digitales
// 
// Revision: 0.02
// Revision 0.01 - File Created
// Additional Comments: Usado para separar digitos hexadecimales de una palabra de 32 bits
// 
//////////////////////////////////////////////////////////////////////////////////
module mux_8_1(	//8 entradas, 1 salida
    input logic [3:0] A, B, C, D, E, F, G, H, //8 entradas de 4b
    input logic [2:0] sel, //selector de 3b
    output logic [3:0]out //salida 4b
    
 );
 
    always_comb begin
        case (sel)
            3'd0: out = A;
            3'd1: out = B;
            3'd2: out = C;
            3'd3: out = D;
            3'd4: out = E;
            3'd5: out = F;
            3'd6: out = G;
            3'd7: out = H;
        endcase
    end
endmodule
