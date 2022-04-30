`timescale 1ns / 1ps
//Decodificador de 2 bits
//Funciona con config one-cold
//xoxo El Basto
module deco_binario_2_cold(
    input  logic [1:0]sel,
    output logic [3:0]y
    );
    always_comb begin
        case (sel)
            2'b00: y = 4'b1110;
            2'b01: y = 4'b1101;
            2'b10: y = 4'b1011;
            2'b11: y = 4'b0111;
            
        endcase
    end
    
endmodule
