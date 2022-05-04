`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////////
// University: Universidad Tecnica Federico Santa Maria
// Course: ELO212
// Students: Cristobal Caqueo, Bastian Rivas, Claudio Zanetta
// 
// Create Date: 03/05/2022
// Design Name: Guia 4
// Module Name: S4_actividad1
// Project Name: nbit_counter
// Target Devices: xc7a100tcsg324-1
// Tool Versions: Vivado 2021.1
// Description: Contador de N bits (por defecto 4)
// 
// Dependencies: Lab Digitales
// 
// Revision: 0.01
// Revision 0.01 - File Created
// Additional Comments: Obtenida de la pregunta 3.7, guía 2
// 
//////////////////////////////////////////////////////////////////////////////////

module nbit_counter #(parameter N=4)(
     input  logic          clk, reset,
     output logic [N-1:0]  count

    );
    always_ff @(posedge clk) begin //flip flop
    //se activa al pasar por el canto de subida del reloj
        if (reset) //si señal reset es 1...
            count <= 'd0; //contador se reinicia
        else
            count <= count+1; //sino, va sumando en cada canto positivo
    end
endmodule
