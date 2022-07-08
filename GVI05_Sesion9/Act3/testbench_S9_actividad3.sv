`timescale 1ns / 1ps
// Testbench para la ALU combinacional de la pregunta 3 de la guia 9.
// Apreta 1 boton a la vez para ver que operacion hace y como la muestra
// Pulsar 2 botones o mas lo lleva de vuelta a su estado default

module testbench_S9_actividad3();
    //// Inputs ////
    logic        CLK100MHZ;
    logic        CPU_RESETN;
    logic        BTNU, BTND, BTNR, BTNL;
    logic [15:0] SW; // {B,A}

    //// Outputs ////
    logic [6:0]  segments;   // {CA, CB, CC, CD, CE, CF, CG}
    logic [7:0]  anodos;      // {AN7, AN6, AN5, AN4, AN3, AN2, AN1, AN0}
   
    S9_actividad3#() DUT(
        .clock(clock),
        .reset(reset),
        .reset2(reset2),
        .BTNC(BTNC),
        .segments(segments),
        .anodos(anodos)  
    );
    always #5 clock =~clock;
    
    initial begin
    clock = 0;
    BTNC = 1;
    #10 
    BTNC = 0;
    reset = 1;
    reset2 = 1;
    #10;
    BTNC = 1;
    #10
    BTNC = 0;
    #10
    BTNC = 1;
    #10
    BTNC = 0;
    #10
    BTNC = 1;
    reset = 0;
    #10
    BTNC = 0;
    #10
    BTNC = 1;
    #10
    BTNC = 0;
    #10
    BTNC = 1;
    #10
    BTNC = 0;
    #10
    BTNC = 1;
    #10
    BTNC = 0;
    #10
    BTNC = 1;
    #10
    BTNC = 0;
    #10
    BTNC = 1;
    #10
    BTNC = 0;
    #10
    BTNC = 1;
    #10
    BTNC = 0;
    #10
    BTNC = 1;
    #10
    BTNC = 0;
    #10
    BTNC = 1;
    #10
    BTNC = 0;
    #10
    BTNC = 1;
    #10
    BTNC = 0;
    #10
    BTNC = 1;
    #10
    BTNC = 0;
    #10
    BTNC = 1;
    #10
    BTNC = 0;
    #10
    reset2 = 0;
    BTNC = 1;
    #10
    BTNC = 0;
    #10
    BTNC = 1;
    #10
    BTNC = 0;
    #10
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
 
    
    
    
    end
endmodule
