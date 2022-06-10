`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// University: Universidad Tecnica Federico Santa Maria
// Course: ELO212
// Students: Cristobal Caqueo, Bastian Rivas, Claudio Zanetta
// 
// Create Date: 3/06/2022
// Design Name: RPN_calc
// Module Name: RPN_calc_test
// Project Name: guia7
// Target Devices: xc7a100tcsg324-1
// Tool Versions: Vivado 2021.1
// Description: Testbench para la calculadora RPN de la primera pregunta de la guia 7
// 
// Dependencies: Lab Digitales
// 
// Revision: 0.11
// Revision 0.01
//
// Additional Comments: 
// 
//////////////////////////////////////////////////////////////////////////////////

module RPN_calc_test_undo();

//Simular hasta 1 100 ns

    // Inputs:
    logic        clk;
    logic        resetN;
    logic        Enter;
    logic [15:0] DataIn;

    // Outputs:

    logic [15:0] ToDisplay;  // valor de salida para el Display
    logic [ 3:0] Flags;      // {N,Z,C,V}
    logic [ 2:0] Status;      // Indica de manera secuencial el estado en el que se encuentra

    // El modulo a probar:
    S7_actividad1 #(
    .N_DEBOUNCER    (10)
    ) DUT (
    .clk            (clk),
    .resetN         (resetN),
    .Enter          (Enter),
    .DataIn         (DataIn),
    .ToDisplay      (ToDisplay),
    .Flags          (Flags),
    .Status         (Status)
);

    always #2 clk=~clk; // usar numero par de unidades de tiempo para evitar 
                          // hacer que cantos coincidan con cambios de senales!

    initial begin

        // Inicializar:

        clk     =   0;
        resetN  =   0;
        Enter   =   0; //Lectura de boton: 1 pulso despues de 48 ns mantenido
        #5 resetN = 1;

        // Carga de datos en A:

        DataIn  = 16'hFFFF;
        Enter   = 1;
        #48 Enter = 0;
        #10

        // Carga de datos en B:

        DataIn  = 16'h0101;
        Enter   = 1;
        #48 Enter = 0;
        #15

        // Carga de datos en Op y mostrar resultados:

        DataIn  = 16'h0000;
        Enter   = 1;
        #48 Enter = 0;
        #15

        //Volver al estado inicial:
        Enter   = 1;
        #50 Enter = 0;
        #15

        // Calcular con las 4 operaciones:
        // Repite lo anterior pero para todas las operaciones


    // Resta:
        // Carga de datos en A:

        DataIn  = 16'hFFFF;
        Enter   = 1;
        #50 Enter = 0;
        #15

        // Carga de datos en B:

        DataIn  = 16'h0101;
        Enter   = 1;
        #48 Enter = 0;
        #15

        // Carga de datos en Op y mostrar resultados:

        DataIn  = 16'h0001;
        Enter   = 1;
        #48 Enter = 0;
        #15

        //Volver al estado inicial:
        Enter   = 1;
        #50 Enter = 0;
        #15

    // OR:

        // Carga de datos en A:

        DataIn  = 16'hFFFF;
        Enter   = 1;
        #48 Enter = 0;
        #15

        // Carga de datos en B:

        DataIn  = 16'h0101;
        Enter   = 1;
        #48 Enter = 0;
        #15

        // Carga de datos en Op y mostrar resultados:

        DataIn  = 16'h0002;
        Enter   = 1;
        #48 Enter = 0;
        #15

        //Volver al estado inicial:
        Enter   = 1;
        #50 Enter = 0;
        #15

    // AND:

        // Carga de datos en A:

        DataIn  = 16'hFFFF;
        Enter   = 1;
        #48 Enter = 0;
        #15

        // Carga de datos en B:

        DataIn  = 16'h0003;
        Enter   = 1;
        #48 Enter = 0;
        #15

        // Carga de datos en Op y mostrar resultados:

        DataIn  = 16'h0000;
        Enter   = 1;
        #48 Enter = 0;
        #15

        //Volver al estado inicial:
        Enter   = 1;
        #50 Enter = 0;
        #15

        // Reset:

        #19 

        resetN = 0;

        #15

        resetN = 1;

    end

endmodule