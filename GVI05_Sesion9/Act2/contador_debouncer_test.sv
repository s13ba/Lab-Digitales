`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.06.2022 01:33:30
// Design Name: 
// Module Name: pulsador_test
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


module contador_debouncer_test();
    logic clock;
    logic reset;
    logic reset2;
    logic BTNC;
    logic [6:0]segments;   // {CA, CB, CC, CD, CE, CF, CG}
    logic [7:0]anodos;      // {AN7, AN6, AN5, AN4, AN3, AN2, AN1, AN0}
   
    Contador_1_debouncer#(.PB_DELAY(5), .DISPLAY_COUNTER(200), .clk_counter_max(250)) 
        DUT(
            .clock   (clock),
            .reset   (reset),
            .reset2  (reset2),
            .BTNC    (BTNC),
            .segments(segments),
            .anodos  (anodos)  
    );
    always #5 clock =~clock;
    
    initial begin
    clock = 0;
    
    BTNC = 1;
    #100 
    BTNC = 0;
    reset = 1;
    reset2 = 1;
    #100;
    BTNC = 1;
    #100
    BTNC = 0;
    #100
    BTNC = 1;
    #100
    BTNC = 0;
    #100
    BTNC = 1;
    reset = 0;
    #100
    BTNC = 0;
    #100
    BTNC = 1;
    #100
    BTNC = 0;
    #100
    BTNC = 1;
    #100
    BTNC = 0;
    #100
    BTNC = 1;
    #100
    BTNC = 0;
    #100
    BTNC = 1;
    #100
    BTNC = 0;
    #100
    BTNC = 1;
    #100
    BTNC = 0;
    #100
    BTNC = 1;
    #100
    BTNC = 0;
    #100
    BTNC = 1;
    #100
    BTNC = 0;
    #100
    BTNC = 1;
    #100
    BTNC = 0;
    #100
    BTNC = 1;
    #100
    BTNC = 0;
    #100
    BTNC = 1;
    #100
    BTNC = 0;
    #100
    BTNC = 1;
    #100
    BTNC = 0;
    #500
    reset2 = 0;
    BTNC = 1;
    #100
    BTNC = 0;
    #100
    BTNC = 1;
    #100
    BTNC = 0;
    #100
    BTNC = 1;
    #100
    BTNC = 0;
    #100
    
    BTNC = 1;
    #100
    BTNC = 0;
    #100
    BTNC = 1;
    #100
    BTNC = 0;
    #100
    BTNC = 1;
    #100
    BTNC = 0;
    #100
    BTNC = 1;
    #100
    BTNC = 0;
    #100
    BTNC = 1;
    #100
    BTNC = 0;
    #100
    BTNC = 1;

    #10000
    reset2 = 1;
    #10000 reset = 1;
 
    
    
    
    end
endmodule
