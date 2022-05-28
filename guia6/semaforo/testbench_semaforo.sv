`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// University: Universidad Tecnica Federico Santa Maria
// Course: ELO212
// Students: Cristobal Caqueo, Bastian Rivas, Claudio Zanetta
// 
// Create Date: 26/05/2022
// Design Name: Guia 6
// Module Name: testbench_semaforo
// Project Name: guia6
// Target Devices: xc7a100tcsg324-1
// Tool Versions: Vivado 2021.1
// Description: Testbench del semaforo
// 
// Dependencies: Lab Digitales
// 
// Revision: 0.01
// Revision 0.01 - File Created
// Additional Comments: Obtenido de la capsula sesion 6
// 
//////////////////////////////////////////////////////////////////////////////////

module testbench_semaforo();
    
	logic clk, reset, TA, TB;
	logic [2:0]LA, LB;

    semaforo DUT (
        .clk   (clk),
        .reset (reset),
        .TA    (TA),
        .TB    (TB),
        .LA    (LA),
        .LB    (LB)
    );

    always #5 clk=~clk;

    initial begin 
        clk = 0;
        reset = 1;
        TA = 1;
        TB = 0;

        #10 reset = 0;

        #10 TA = 0;
        #10 TA = 1;

        #20 TA = 0;
            TB = 1;

        #40 TA = 1;
            TB = 0;

        #5 reset = 1;
        #5 reset = 0;
        

    end


endmodule