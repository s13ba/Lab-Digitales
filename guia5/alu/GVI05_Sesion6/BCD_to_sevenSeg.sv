`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// University: Universidad Tecnica Federico Santa Maria
// Course: ELO212
// Students: Cristobal Caqueo, Bastian Rivas, Claudio Zanetta
// 
// Create Date: 03/05/2022
// Design Name: Guia 4
// Module Name: BCD_to_sevenSeg
// Project Name: mux_multiples_displays
// Target Devices: xc7a100tcsg324-1
// Tool Versions: Vivado 2021.1
// Description: Conversor de nibbles a numeros legibles en displays de 7 segmentos
// 
// Dependencies: Lab Digitales
// 
// Revision: 0.01
// Revision 0.01 - File Created
// Additional Comments: Módulo conversor BCD a 7seg de la pregunta 3.3 en la guía 2. 
//                      Modificado con 0 como ON para coincidir con la Nexys A7
// 
//////////////////////////////////////////////////////////////////////////////////
module BCD_to_sevenSeg(
    input logic [3:0] BCD_in, //números del 0 al F, 4bits. 
    output logic [6:0] sevenSeg //salida abcdefg según el datasheet de la plaquita, 7bits
    );
    
    always_comb begin
    
        //0:ON, 1:OFF
        case (BCD_in)
            4'd0: sevenSeg = 7'b0000001;
            4'd1: sevenSeg = 7'b1001111;
            4'd2: sevenSeg = 7'b0010010;
            4'd3: sevenSeg = 7'b0000110;
            4'd4: sevenSeg = 7'b1001100;
            4'd5: sevenSeg = 7'b0100100;
            4'd6: sevenSeg = 7'b0100000;
            4'd7: sevenSeg = 7'b0001111;
            4'd8: sevenSeg = 7'b0000000;
            4'd9: sevenSeg = 7'b0000100;
            4'd10:sevenSeg = 7'b0001000; //A
            4'd11:sevenSeg = 7'b1100000; //b
            4'd12:sevenSeg = 7'b0110001; //C
            4'd13:sevenSeg = 7'b1000010; //d
            4'd14:sevenSeg = 7'b0110000; //E
            4'd15:sevenSeg = 7'b0111000; //F
            default: sevenSeg = 7'b1111111; //por defecto apagaría todos 
        endcase
    end
endmodule