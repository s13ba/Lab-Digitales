`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.06.2022 23:35:42
// Design Name: 
// Module Name: S9_actividad1
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


module S9_actividad1(
    input logic CLK100MHZ,
    input logic BTNC, BTNU,
    output logic CA, CB, CC, CD, CE, CF, CG,
    output logic [7:0] AN
    );
    
    logic [6:0] segments;
    assign segments = {CA, CB, CC, CD, CE, CF, CG};
    
    logic [7:0] anodos;
    assign anodos = AN;
    
    anti_rebote_i anti_rebote_i(
        .clock(CLK100MHZ),
        .reset(BTNU),
        .reset2(BTNU),
        .BTNC(BTNC),
        .segments(segments),   
        .anodos(anodos)
    );
    
    
    
endmodule
