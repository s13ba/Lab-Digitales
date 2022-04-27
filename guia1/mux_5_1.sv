`timescale 1ns / 1ps
module mux_5_1(//5 entradas, 1 salida
    input logic [3:0] A, B, C, D, E, //entradas de 4b
    input logic [2:0] sel, //selector de 2b
    output logic [3:0]out//salida 4b
    
 );
 
    always_comb begin
     case(sel)
         3'b000: out=A;
         3'b001: out=B;
         3'b010: out=C;
         3'b011: out=D;
         3'b100: out=E;
         default: out=3'b111;
     endcase
    end

endmodule
