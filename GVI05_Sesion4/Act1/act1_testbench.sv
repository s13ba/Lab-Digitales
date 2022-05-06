`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// University: Universidad Tecnica Federico Santa Maria
// Course: ELO212
// Students: Cristobal Caqueo, Bastian Rivas, Claudio Zanetta
// 
// Create Date: 03/05/2022
// Design Name: Guia 4
// Module Name: S4_actividad1
// Project Name: mux_multiples_displays
// Target Devices: xc7a100tcsg324-1
// Tool Versions: Vivado 2021.1
// Description: Testbench para probar el funcionamiento del display de 8 dígitos
// 
// Dependencies: Lab Digitales
// 
// Revision: 0.01
// Revision 0.01 - File Created
// Additional Comments: Primero cuenta del 0 al F, luego va llenando de Fs los displays.
//                      Finalmente pone un reset para mostrar que se resetea en cualquier momento.
// 
//////////////////////////////////////////////////////////////////////////////////


module act1_testbench();
    logic clock;
    logic reset;
    logic [31:0] BCD_in;
    logic [6:0]  segments;
    logic [7:0]  anodos;
    
    S4_actividad1 DUT(
        .clock(clock),
        .reset(reset),
        .BCD_in(BCD_in),
        .segments(segments),
        .anodos(anodos)
        );
    
    always #1 clock=~clock; //cada display brilla por 5 ns
    
    initial begin
        clock   = 0;
        reset   = 1;
        BCD_in  = 32'h0; //empieza mostrando ceros  
        #10
        reset   = 0;
        
        //Contar del 0 a F
        #24
        BCD_in  = 'h1;
        #24
        BCD_in  = 'h2;
        #24
        BCD_in  = 'h3;
        #24
        BCD_in  = 'h4;
        #24
        BCD_in  = 'h5;
        #24
        BCD_in  = 'h6;
        #24
        BCD_in  = 'h7;
        #24
        BCD_in  = 'h8;
        #24
        BCD_in  = 'h9;
        #24
        BCD_in  = 'hA;
        #24
        BCD_in  = 'hB;
        #24
        BCD_in  = 'hC;
        #24
        BCD_in  = 'hD;
        #24
        BCD_in  = 'hE;
        #24
        BCD_in  = 'hF;
        
        //Llenar de numeros distintos de cero los displays
        #24
        BCD_in  = 'h000000FF;
        #24
        BCD_in  = 'h00000FFF;
        #24
        BCD_in  = 'h0000FFFF;
        #24
        BCD_in  = 'h000FFFFF;
        #24
        BCD_in  = 'h00FFFFFF;
        #24
        BCD_in  = 'h0FFFFFFF;
        #24
        BCD_in  = 'hFFFFFFFF;
        
        //Reset
        #24
        BCD_in  = 'h98765432;
        #10
        reset   = 1;
        #24;
        reset   = 0;
    end
endmodule
