`timescale 1ns / 1ps/*
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 21.04.2022 23:58:50
// Module Name: test_topmodule
// Description: Testbench pal módulo q muestra números en un 7seg y detecta fibianarios
// Revision:1
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module test_topmodule();
    logic clk, reset, fibInv; //fib,
    logic [6:0] sevenSegInv; //sevenSeg,
    //logic [3:0] count;
    
    top_module DUT(
        .clk(clk),
        .reset(reset),
        .fibInv(fibInv),
        .sevenSegInv(sevenSegInv) 
    );
    
    always #5 clk=~clk; //señal de reloj
    
    initial begin //inicializa al reloj
        clk = 0;
        reset = 1;
        #10 reset = 0;
    end
endmodule*/
