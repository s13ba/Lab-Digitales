`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// University: Universidad Tecnica Federico Santa Maria
// Course: ELO212
// Students: 
// 
// Create Date: 
// Design Name: Guia 7
// Module Name: S7_actividad1
// Project Name: 
// Target Devices: xc7a100tcsg324-1
// Tool Versions: Vivado 2021.1
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module S7_actividad1 #(parameter N_DEBOUNCER = 10)(
    input  logic        clk,
    input  logic        resetN,
    input  logic        Enter,
    input  logic [15:0] DataIn,
    output logic [15:0] ToDisplay,  // valor de salida para el Display
    output logic [ 3:0] Flags,      // {N,Z,C,V}
    output logic [ 2:0] Status      // Indica de manera secuencial el estado en el que se encuentra
    );
    

    
endmodule
