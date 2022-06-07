`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.06.2022 21:57:28
// Design Name: 
// Module Name: ReversePolishFSM
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


module ReversePolishFSM(
    input logic clk, Reset, Enter_pulse,
    output logic [2:0]Status,
    output logic LoadOpA, LoadOpB, LoadOpCode, ToDisplaySel, updateRes
    );
    enum logic [2:0] {S0, S1, S2, S3, S4, S5, S6} state, next_state;
    
    always_ff @(posedge clk) begin
        if(Reset)
            state <= S0;
        else
            state <= next_state;
    end
    
    always_comb begin
        case(state)
            S0: begin
                if(Enter_pulse)
                    next_state = S1;
                else
                    next_state = S0;   
            end
            S1: next_state = S2;
            S2: begin
                if(Enter_pulse)
                    next_state = S3;
                else
                    next_state = S2;
            end
            S3: next_state = S4;
            S4: begin
                if(Enter_pulse)
                        next_state = S5;
                    else
                        next_state = S4;
             end
             S5: next_state = S6;
             S6: begin
                if(Enter_pulse)
                        next_state = S0;
                    else
                        next_state = S6;
            end
            default: next_state = S0;
        endcase
    end
    always_comb begin
        case(state)
            S0: begin
                Status = 3'b000;
                LoadOpA = 1'b0;
                LoadOpB = 1'b0;
                LoadOpCode = 1'b0;
                ToDisplaySel = 1'b0;
                updateRes = 1'b0;
            end
            S1: begin
                Status = 3'b001;
                LoadOpA = 1'b1;
                LoadOpB = 1'b0;
                LoadOpCode = 1'b0;
                ToDisplaySel = 1'b0;
                updateRes = 1'b0; 
            end
            S2: begin
                Status = 3'b010;
                LoadOpA = 1'b0;
                LoadOpB = 1'b0;
                LoadOpCode = 1'b0;
                ToDisplaySel = 1'b0;
                updateRes = 1'b0;
            end
            S3: begin
                Status = 3'b011;
                LoadOpA = 1'b0;
                LoadOpB = 1'b1;
                LoadOpCode = 1'b0;
                ToDisplaySel = 1'b0;
                updateRes = 1'b0;
            end
            S4: begin
               Status = 3'b100;
               LoadOpA = 1'b0;
               LoadOpB = 1'b0;
               LoadOpCode = 1'b0;
               ToDisplaySel = 1'b0;
               updateRes = 1'b0; 
            end
            S5: begin
              Status = 3'b101;
              LoadOpA = 1'b0;
              LoadOpB = 1'b0;
              LoadOpCode = 1'b1;
              ToDisplaySel = 1'b0;
              updateRes = 1'b0;  
            end
            S6: begin
               next_state = S0;
               Status = 3'b110;
               LoadOpA = 1'b0;
               LoadOpB = 1'b0;
               LoadOpCode = 1'b0;
               ToDisplaySel = 1'b1;
               updateRes = 1'b1; 
            end
            default: begin
                Status = 3'b000;
                LoadOpA = 1'b0;
                LoadOpB = 1'b0;
                LoadOpCode = 1'b0;
                ToDisplaySel = 1'b0;
                updateRes = 1'b0;
            end 
       endcase    
    end      
    
endmodule
