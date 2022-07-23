`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.06.2022 02:03:44
// Design Name: 
// Module Name: S9_actividad4
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module S9_actividad4(
    input logic CLK100MHZ,
    input logic CPU_RESETN,
    input logic BTNC, BTND, BTNU,
    input logic [15:0]SW,
    output logic CA, CB, CC, CD, CE, CF, CG,
    output logic [15:0]LED,
    output logic [7:0] AN
    );
    
    assign LED[12:4] = 'b0;
    
    S7_actividad3 uS7_actividad3(
        .clk(CLK100MHZ),
        .resetN(CPU_RESETN),
        .Enter(BTNC),
        .Undo(BTND),
        .DisplayFormat(BTNU),
        .DataIn(SW),
        .Segments({CA, CB, CC, CD, CE, CF, CG}),   
        .Anodes(AN),
        .Flags(LED[3:0]),
        .Status(LED[15:13])
    );
endmodule
