`timescale 1ns / 1ps
module mux_4_1(//4 entradas, 1 salida
    input logic [3:0] A, B, C, D, //entradas de 4b
    input logic [1:0] sel, //selector de 2b
    output logic [3:0]out//salida 4b
    
 );
 
    always_comb begin
     case(sel)
         2'b00: out=A;
         2'b01: out=B;
         2'b10: out=C;
         2'b11: out=D;
      //   3'b100: out=E;
         default: out=2'b11;
     endcase
    end

endmodule
