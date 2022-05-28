`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// University: Universidad Tecnica Federico Santa Maria
// Course: ELO212
// Students: Cristobal Caqueo, Bastian Rivas, Claudio Zanetta
// 
// Create Date: 26/05/2022
// Design Name: Guia 6
// Module Name: testbench_edge_detector
// Project Name: guia6
// Target Devices: xc7a100tcsg324-1
// Tool Versions: Vivado 2021.1
// Description: Testbench del detector de cantos en base a una FSM
// 
// Dependencies: Lab Digitales
// 
// Revision: 0.01
// Revision 0.01 - File Created
// Additional Comments: Obtenido de la capsula sesion 6
// 
//////////////////////////////////////////////////////////////////////////////////

module testbench_edge_detector();
    
    logic clk, reset, L;
    logic P;

    edge_detector DUT (
    .clk   (clk),
    .reset (reset),
    .L     (L),
    .P     (P)
    );

    always #5 clk=~clk;

    initial begin 
        clk = 0;
        reset = 1;
        #10 reset = 0;
        L = 1;
        #35 L = 0;

        #15 L = 1;

        #15 reset = 1;

        #10 L = 0;


    end


endmodule