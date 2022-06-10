`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// University: Universidad Tecnica Federico Santa Maria
// Course: ELO212
// Students: Cristobal Caqueo, Bastian Rivas, Claudio Zanetta
// 
// Create Date: 05/06/2022
// Design Name: Guia 7
// Module Name: S7_actividad2
// Project Name: guia7_p2
// Target Devices: xc7a100tcsg324-1
// Tool Versions: Vivado 2021.1
// Description: Calculadora con RPN. Ahora con Undo!
// 
// Dependencies: Lab Digitales
// 
// Revision: 0.01
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////

module S7_actividad2 #(parameter N_DEBOUNCER = 10)(
    input  logic        clk,
    input  logic        resetN,
    input  logic        Enter,
    input  logic        Undo,
    input  logic [15:0] DataIn,
    output logic [15:0] ToDisplay,  // valor de salida para el Display
    output logic [ 3:0] Flags,      // {N,Z,C,V}
    output logic [ 2:0] Status      // Indica de manera secuencial el estado en el que se encuentra
    );
    
    logic reset;

    assign reset = ~resetN; // resetN: reset negado


    // Debouncer: Recibe Enter y retorna un pulso unico en Enter_deb

    logic Enter_deb;

    PB_Debouncer_FSM #     (
    .DELAY                 (N_DEBOUNCER)
    ) Enter_Debouncer            (
        .clk                  (clk),
	    .rst                  (reset), 
	    .PB                   (Enter),
	    .PB_pressed_status    (),
	    .PB_pressed_pulse     (Enter_deb), // solo nos interesa el pulso
        .PB_released_pulse    ()
);

    // Debouncer: Lo mismo pero para Undo

    logic deb_undo;

    PB_Debouncer_FSM #     (
    .DELAY                 (N_DEBOUNCER)
    ) Undo_Debouncer            (
        .clk                  (clk),
	    .rst                  (reset), 
	    .PB                   (Undo),
	    .PB_pressed_status    (),
	    .PB_pressed_pulse     (deb_undo), // solo nos interesa el pulso
        .PB_released_pulse    ()
);

    // RPN: Recibe un pulso de Enter (Enter_deb) y un pulso de Undo (deb_undo) 
    //      Retorna estado, load A, B y OpCode, updateRes y ToDisplaySel
    logic LoadOpA, LoadOpB, LoadOpCode, updateRes, ToDisplaySel;

    ReversePolishFSM_Undo Reverse_Polish_FSM_Undo (
        .clk             (clk),
        .Reset           (Reset),
        .Enter_pulse     (Enter_deb),
        .deb_undo        (deb_undo),
        .Status          (Status),
        .LoadOpA         (LoadOpA),
        .LoadOpB         (LoadOpB),
        .LoadOpCode      (LoadOpCode),
        .ToDisplaySel    (ToDisplaySel),
        .updateRes       (updateRes)
);

    // ALU: Recibe un numero de 16 bits, load A, B, OpCode y updateRes (ademas de clk y resetN)
    //      Retorna 4 bits de Flags y un resultado de 16 bits
    logic [15:0] Result;
    ALU_reg_mod #   (
        .N          (16)
)   ALU             (
        .clk        (clk),
        .reset      (reset),
        .LoadOpA    (LoadOpA),
        .LoadOpB    (LoadOpB),
        .LoadOpCode (LoadOpCode),
        .updateRes  (updateRes),
        .DataIn     (DataIn),
        .Flags      (Flags),
        .Result     (Result)
);

    // Display Selector: Recibe 2 numeros de 16 bits y un selector ToDisplaySel
    //                   Retorna uno de los numeros de 16 bits
    mux_2_1_16b #(
    .N               (16)
    ) DisplaySelector (
    .A         (DataIn),
    .B         (Result),
    .sel       (ToDisplaySel),
    .out       (ToDisplay)
);


endmodule



/*
// Modulos auxiliares:

module mux_2_1_16b #(parameter N = 16)(
    input  logic [N-1:0] DataIn,
    input  logic [N-1:0] Result,
    input  logic         ToDisplaySel,

    output logic [N-1:0] ToDisplay  // valor de salida para el Display
    );

    always_comb begin
        if (ToDisplaySel)
            ToDisplay = Result;
        else
            ToDisplay = DataIn;
        
    end

endmodule

module mux_2_1_16b #(parameter N = 16)(
    input  logic [N-1:0] A,
    input  logic [N-1:0] B,
    input  logic         sel,

    output logic [N-1:0] out  // valor de salida para el Display
    );

    always_comb begin
        if (sel)
            out = B;
        else
            out = A;
        
    end

endmodule

*/
    

