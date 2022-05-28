`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// University: Universidad Tecnica Federico Santa Maria
// Course: ELO212
// Students: Cristobal Caqueo, Bastian Rivas, Claudio Zanetta
// 
// Create Date: 26/05/2022
// Design Name: Guia 6
// Module Name: edge_detector
// Project Name: guia6
// Target Devices: xc7a100tcsg324-1
// Tool Versions: Vivado 2021.1
// Description: Detector de cantos en base a una FSM
// 
// Dependencies: Lab Digitales
// 
// Revision: 0.01
// Revision 0.01 - File Created
// Additional Comments: Obtenido de la capsula sesion 6
// 
//////////////////////////////////////////////////////////////////////////////////

module edge_detector(
    input logic clk, reset, L,
    output logic P
);

    enum logic [2:0] {S0, S1, S2} state, next_state;

    always_ff @(posedge clk) begin
        if(reset)
            state <= S0;
        else
            state <= next_state;       
    end

    always_comb begin
        case(state)
            S0: begin
                if (L)
                    next_state = S1;
                else
                    next_state = S0;
            end
            S1: begin
                if (L)
                    next_state = S2;
                else
                    next_state = S0;
            end
            S2: begin
                if (L)
                    next_state = S2;
                else
                    next_state = S0;
            end
            default : next_state = S0;
        endcase
    end

    always_comb begin
        case(state)
            S0 : P = 0;
            S1 : P = 1;
            S2 : P = 0;
            default : P = 0;
        endcase
    end
endmodule