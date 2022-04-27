`timescale 1ns/1ps //`timescale
/*
module testbench_simple();

    logic A,B,C;
    logic X,Y,Z;
    
    logica_simple DUT(
        .A (A),
        .B (B),
        .C (C),
        .X (X),
        .Y (Y),
        .Z (Z)
        );
        
    initial begin
       A = 1'b0;
       B = 1'b0;
       C = 1'b0;
       #3
       A = 1'b1;
       #6
       B = 1'b1;
       #4
       C = 1'b1;
       #2
       A = 1'b0;
       C = 1'b0;
       #3
       C = 1'b1;
       #3
       B=1'b0;
       #3
       A=1'b1;
       
    end   
endmodule*/