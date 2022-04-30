//Módulo conversor BCD a 7seg de la pregunta 3.3 en la guía 2
//Modificado con salida invertida para coincidir con la Nexys A7

`timescale 1ns / 1ps
module BCD_to_sevenSeg_inv(
    input logic [3:0] BCD_in, //números del 0 al 9, 4bits
    output logic [6:0] sevenSeg //salida abcdefg según el datasheet de la plaquita, 7bits
    );
    
    always_comb begin
    /* //Original:
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
            4'd10:sevenSeg = 7'b1110110;
            4'd11:sevenSeg = 7'b0011111;
            4'd12:sevenSeg = 7'b1001110;
            4'd13:sevenSeg = 7'b0111101;
            4'd14:sevenSeg = 7'b1001111;
            4'd15:sevenSeg = 7'b1000111;
            default: sevenSeg = 7'b1111111; //por defecto enciende todos
        endcase
        */
        //Fix pal Nexys:
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
            4'd10:sevenSeg = 7'b0001001;
            4'd11:sevenSeg = 7'b1100000;
            4'd12:sevenSeg = 7'b0110001;
            4'd13:sevenSeg = 7'b1000010;
            4'd14:sevenSeg = 7'b0110000;
            4'd15:sevenSeg = 7'b0111000;
            default: sevenSeg = 7'b1111111; //por defecto apaga todos
        endcase
    end
endmodule