`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// University: Universidad Tecnica Federico Santa Maria
// Course: ELO212
// Students: 
// 
// Create Date: 
// Design Name: Guia 7
// Module Name: S7_actividad3
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


module S7_actividad3 #(parameter N_DEBOUNCER = 10)(
    input  logic        clk,
    input  logic        resetN,
    input  logic        Enter,
    input  logic        Undo,
    input  logic        DisplayFormat,
    input  logic [15:0] DataIn,
    output logic [ 6:0] Segments,   // solo segmentos, no considere el punto
    output logic [ 7:0] Anodes,
    output logic [ 3:0] Flags,
    output logic [ 2:0] Status
    );
    

    
endmodule

