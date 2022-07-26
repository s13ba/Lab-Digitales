`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: El Basto
// 
// Create Date: 05/07/2018 07:05:14 PM
// Design Name: 
// Module Name: need top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: dice secso. corta
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module need_top(
    input logic CLK100MHZ, CPU_RESETN,
    output logic CA, CB, CC, CD, CE, CF, CG,
    output logic [7:0] AN
);
    logic [31:0] BCD_in;
    assign BCD_in = 32'h0005EC50;
    logic reset, CLK250HZ;
    assign reset= ~CPU_RESETN;


    clock_divider 
    #(.COUNTER_MAX(100000) ) 
    clk_250hz
    ( .clk_in(CLK100MHZ),
      .reset(reset),
      .clk_out(CLK250HZ)
       );

 driver_7_seg #(.N(32)
 ) Driver_7_seg_electric_boogaloo(
           .clock(CLK250HZ),
           .reset(reset),
           .BCD_in(BCD_in),     // informacion a mostrar
           .segments({CA, CB, CC, CD, CE, CF, CG}),   // {CA, CB, CC, CD, CE, CF, CG}
           .anodos(AN)      // {AN7, AN6, AN5, AN4, AN3, AN2, AN1, AN0}
    );

endmodule