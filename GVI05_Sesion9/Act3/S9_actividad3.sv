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


module S9_actividad3( //Modulo top que va a la plaquita
    input logic CLK100MHZ,
    input logic CPU_RESETN,
    input logic BTNC, BTND, BTNU,
    input logic [15:0]SW,
    output logic CA, CB, CC, CD, CE, CF, CG,
    output logic [15:0]LED,
    output logic [7:0] AN
    );
    
    logic   [7:0]   A,  B;
    assign A =  SW[7 :0];
    assign B =  SW[15:8];
    assign LED[12:4] = 'b0;
    
    logic [1:0] OpCode;
    ALU_comb#(.M(8)) ALU (
        .A(A), 
        .B(B),
    input  logic [1:0]      OpCode,       
    output logic [M-1:0]    Result,
    output logic [3:0]      Status // = {N, Z, C, V}
        
        .*);
endmodule
