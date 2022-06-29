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
// Revision: 1.02 parametrizao de pana
// Revision 0.01 - File Created
// Additional Comments: Usado para separar digitos hexadecimales de una palabra de 32 bits
// 
//////////////////////////////////////////////////////////////////////////////////
module mux_8_1#(parameter N = 3)(	//8 entradas, 1 salida
    input logic [3:0] A, B, C, D, E, F, G, H, //N entradas de 4b
    input logic [N-1:0] sel, //selector de N-1b
    output logic [3:0]out //salida 4b
    
 );
 
    always_comb begin
        case (sel)
            'd0: out = A;
            'd1: out = B;
            'd2: out = C;
            'd3: out = D;
            'd4: out = E;
            'd5: out = F;
            'd6: out = G;
            'd7: out = H;
        endcase
    end
endmodule
