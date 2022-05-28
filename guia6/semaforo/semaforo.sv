`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// University: Universidad Tecnica Federico Santa Maria
// Course: ELO212
// Students: Cristobal Caqueo, Bastian Rivas, Claudio Zanetta
// 
// Create Date: 26/05/2022
// Design Name: Guia 6
// Module Name: semaforo
// Project Name: guia6
// Target Devices: xc7a100tcsg324-1
// Tool Versions: Vivado 2021.1
// Description: Semaforo que detecta autos en un cruce
// 
// Dependencies: Lab Digitales
// 
// Revision: 0.01
// Revision 0.01 - File Created
// Additional Comments: Obtenido de la capsula sesion 6
// 
//////////////////////////////////////////////////////////////////////////////////


// Module header:-----------------------------
module semaforo(
	input 	logic clk, reset, TA, TB,
	output 	logic [2:0]LA, LB
);
 //Declarations:------------------------------

 //FSM states type:
    enum logic [3:0] {S0, S1, S2, S3} state, next_state;

 //Local params:
    localparam YELLOW = 3'b001; 
    localparam RED = 3'b010; 
    localparam GREEN = 3'b100; 

 //Statements:--------------------------------

 //FSM state register:
    always_ff @(posedge clk) begin
        if (reset)
            state <= S0;
         else 
            state <= next_state;
    end

 //FSM combinational logic:
 //Next state logic:
    always_comb begin
        case (state)
            S0: begin
                if (TA) 
                    next_state = S0;
                else 
                    next_state = S1;
            end

            S1: next_state = S2;
    
            S2: begin
                if (TB) 
                    next_state = S2;
                else 
                    next_state = S3;
            end
    
            S3: next_state = S0;
            default : next_state = S0;
        endcase
    end

//Output logic:
    always_comb begin
        LA = RED;
        LB = RED;

        case (state)
            S0: begin
                LA = GREEN;
            end

            S1: begin
                LA = YELLOW;
            end

    
            S2:  begin
                LB = GREEN;
            end
    
            S3: begin
                LB = YELLOW;
            end
            default : begin
                LA = GREEN;
            end
        endcase
    end

 endmodule