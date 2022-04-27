//Módulo conversor BCD a 7seg de la pregunta 3.3 en la guía 2

`timescale 1ns / 1ps
module BCD_to_sevenSeg(
    input logic [3:0] BCD_in, //números del 0 al 9, 4bits
    output logic [6:0] sevenSeg //salida abcdefg según el datasheet de la plaquita, 7bits
    );
    
    always_comb begin
        case (BCD_in)
            4'd0: sevenSeg = 7'b1111110;
            4'd1: sevenSeg = 7'b0110000;
            4'd2: sevenSeg = 7'b1101101;
            4'd3: sevenSeg = 7'b1111001;
            4'd4: sevenSeg = 7'b0110011;
            4'd5: sevenSeg = 7'b1011011;
            4'd6: sevenSeg = 7'b1011111;
            4'd7: sevenSeg = 7'b1110000;
            4'd8: sevenSeg = 7'b1111111;
            4'd9: sevenSeg = 7'b1111011;
            default: sevenSeg = 7'b1111111; //por defecto enciende todos(pa evitar inferir latches
        endcase
    end
endmodule
