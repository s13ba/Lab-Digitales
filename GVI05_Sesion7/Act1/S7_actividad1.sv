`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// University: Universidad Tecnica Federico Santa Maria
// Course: ELO212
// Students: Cristobal Caqueo, Bastian Rivas, Claudio Zanetta
// 
// Create Date: 05/06/2022
// Design Name: Guia 7
// Module Name: S7_actividad1
// Project Name: Guia7
// Target Devices: xc7a100tcsg324-1
// Tool Versions: Vivado 2021.1
// Description: Conversor de nibbles a numeros legibles en displays de 7 segmentos
// 
// Dependencies: Lab Digitales
// 
// Revision: 0.01
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////

// Módulo principal: 
module S7_actividad1 #(parameter N_DEBOUNCER = 10)(
    input  logic        clk,
    input  logic        resetN,
    input  logic        Enter,
    input  logic [15:0] DataIn,
    output logic [15:0] ToDisplay,  // valor de salida para el Display
    output logic [ 3:0] Flags,      // {N,Z,C,V}
    output logic [ 2:0] Status      // Indica de manera secuencial el estado en el que se encuentra
    );

    logic reset;

    assign reset = ~resetN; // resetN: reset negado
    
    logic Enter_deb;

    // Debouncer: Recibe Enter y retorna un pulso unico en Enter_deb
    PB_Debouncer_FSM #     (
    .DELAY                 (N_DEBOUNCER)
    ) Debouncer            (
        .clk                  (clk),
	    .rst                  (reset), 
	    .PB                   (Enter),
	    .PB_pressed_status    (),
	    .PB_pressed_pulse     (Enter_deb), // solo nos interesa el pulso
        .PB_released_pulse    ()
);

    // RPN: Recibe un pulso de Enter (Enter_deb). 
    //      Retorna estado, load A, B y OpCode, updateRes y ToDisplaySel
    logic LoadOpA, LoadOpB, LoadOpCode, updateRes, ToDisplaySel;

    ReversePolishFSM Reverse_Polish_FSM     (
        .clk               (clk),
	    .Reset             (reset),
        .Enter_pulse       (Enter_deb),
        .Status            (Status),
        .LoadOpA           (LoadOpA),
        .LoadOpB           (LoadOpB),
        .LoadOpCode        (LoadOpCode),
        .updateRes         (updateRes),
        .ToDisplaySel      (ToDisplaySel)

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
    .DataIn          (DataIn),
    .Result          (Result),
    .ToDisplaySel    (ToDisplaySel),
    .ToDisplay       (ToDisplay)
);


endmodule




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