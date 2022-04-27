//Testbench pa testear el fibinario (que valga la redundancia)
/*
`timescale 1ns/1ps 

module testbench_fibinario();

    logic A, B, C, D, Z;

    fibinario DUT(
        .A (A),
        .B (B),
        .C (C),
        .D (D),
        .Z (Z)       
        );
        
        //logic [3:0]F;
        //concatenar {A,B,C,D}=4'b0001;
    initial begin
        A = 1'b0;
        B = 1'b0;
        C = 1'b0;
        D = 1'b0;
        #5
        A = 1'b0;
        B = 1'b0;
        C = 1'b0;
        D = 1'b1;
        #5
        A = 1'b0;
        B = 1'b0;
        C = 1'b1;
        D = 1'b0;
        #5
        A = 1'b0;
        B = 1'b0;
        C = 1'b1;
        D = 1'b1;
        #5
        A = 1'b0;
        B = 1'b1;
        C = 1'b0;
        D = 1'b0;
        #5
        A = 1'b0;
        B = 1'b1;
        C = 1'b0;
        D = 1'b1;
        #5
        A = 1'b0;
        B = 1'b1;
        C = 1'b1;
        D = 1'b0;
        #5 
        A = 1'b0;
        B = 1'b1;
        C = 1'b1;
        D = 1'b1;
        #5        
        A = 1'b1;
        B = 1'b0;
        C = 1'b0;
        D = 1'b0;
        #5       
        A = 1'b1;
        B = 1'b0;
        C = 1'b0;
        D = 1'b1;
        #5 
        A = 1'b1;
        B = 1'b0;
        C = 1'b1;
        D = 1'b0;
        #5        
        A = 1'b1;
        B = 1'b0;
        C = 1'b1;
        D = 1'b1;
        #5        
        A = 1'b1;
        B = 1'b1;
        C = 1'b0;
        D = 1'b0;
        #5        
        A = 1'b1;
        B = 1'b1;
        C = 1'b0;
        D = 1'b1;
        #5        
        A = 1'b1;
        B = 1'b1;
        C = 1'b1;
        D = 1'b0;
        #5        
        A = 1'b1;
        B = 1'b1;
        C = 1'b1;
        D = 1'b1;
       end
endmodule
*/