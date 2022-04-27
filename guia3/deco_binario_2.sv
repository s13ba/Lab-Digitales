`timescale 1ns / 1ps
//Decodificador de 1ra pregunta de guía 3
//Funciona con config one-hot
//xoxo El Basto
module deco_binario_2(
    input logic a,b,
    output logic [3:0]y,
    output [1:0]sel
    );
    assign sel = {a, b}; //del 00 al 11
    always_comb begin
        case (sel)
            2'b00: y = 4'b0001;
            2'b01: y = 4'b0010;
            2'b10: y = 4'b0100;
            2'b11: y = 4'b1000;
            
        endcase
    end
    
endmodule
