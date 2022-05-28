`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// University: Universidad Tecnica Federico Santa Maria
// Course: ELO212
// Students: Cristobal Caqueo, Bastian Rivas, Claudio Zanetta
// 
// Create Date: 03/05/2022
// Design Name: Guia 4
// Module Name: deco_binario_3_cold
// Project Name: mux_multiples_displays
// Target Devices: xc7a100tcsg324-1
// Tool Versions: Vivado 2021.1
// Description: Decodificador de 3 bits, funciona con configuracion One-Cold
// 
// Dependencies: Lab Digitales
// 
// Revision: 0.01
// Revision 0.01 - File Created
// Additional Comments: Adaptado para trabajar con los 8 displays de la actividad 4.1
// 
//////////////////////////////////////////////////////////////////////////////////

module deco_binario_3_cold#(parameter N = 3)(
    input  logic [N-1:0]sel,
    output logic [7:0]out
    );

    always_comb begin

        case (sel)
            'd0: out = 8'b11111110;
            'd1: out = 8'b11111101;
            'd2: out = 8'b11111011;
            'd3: out = 8'b11110111;
            'd4: out = 8'b11101111;
            'd5: out = 8'b11011111;
            'd6: out = 8'b10111111;
            'd7: out = 8'b01111111;
        endcase

    end
    
endmodule
