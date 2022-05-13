`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// University: Universidad Tecnica Federico Santa Maria
// Course: ELO212
// Students: Cristobal Caqueo, Bastian Rivas, Claudio Zanetta
// 
// Create Date: 03/05/2022
// Design Name: guia5_alu
// Module Name: deco_binario_3_cold
// Project Name: mux_multiples_displays
// Target Devices: xc7a100tcsg324-1
// Tool Versions: Vivado 2021.1
// Description: Decodificador de 2 bits, funciona con configuracion One-Cold
// 
// Dependencies: Lab Digitales
// 
// Revision: 0.01
// Revision 0.01 - File Created
// Additional Comments: Adaptado para trabajar con los 4 displays de la actividad 3.4 de la guia 5
// 
//////////////////////////////////////////////////////////////////////////////////

module deco_binario_2_cold(
    input  logic [2:0]sel,
    output logic [3:0]out
    );

    always_comb begin

        case (sel)
        
            2'd0: out = 8'b1110;
            2'd1: out = 8'b1101;
            2'd2: out = 8'b1011;
            2'd3: out = 8'b0111;

        endcase

    end
    
endmodule
