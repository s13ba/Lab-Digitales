`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.07.2022 18:01:43
// Design Name: 
// Module Name: UART_RX_CTRL
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


module UART_RX_CTRL(
    input logic clk, reset, rx_ready,
    input logic [7:0]rx_data,
    output logic trigger, enter,
    output logic [15:0] Data_In

    );
    
    logic [7:0] OP1_LSB, OP1_MSB, OP2_LSB, OP2_MSB, CTRL;
    logic [7:0] OP1_LSB_out, OP1_MSB_out, OP2_LSB_out, OP2_MSB_out, CTRL_out;
    logic save1, save2, save3, save4, save5;
    logic [15:0] OP1, OP2, OP_code;
    
    enum logic [15:0] {Wait_OP1_LSB, Store_OP1_LSB, Wait_OP1_MSB, Store_OP1_MSB, Wait_OP2_LSB, Store_OP2_LSB, Wait_OP2_MSB, Store_OP2_MSB, Wait_CMD, Store_CMD, Delay_1_cycle, Trigger_TX_result} state, next_state;
    always_ff @(posedge clk) begin
        if(reset)
            state <= Wait_OP1_LSB;
        else
            state <= next_state;
    end
    
    always_comb begin
        next_state = state;
        save1 = 0;
        save2 = 0;
        save3 = 0;
        save4 = 0;
        save5 = 0;
        trigger = 0;
        
        case(state)
            Wait_OP1_LSB: begin
                          if(rx_ready)
                            next_state = Store_OP1_LSB;
            
            end
            Store_OP1_LSB: begin
                           next_state = Wait_OP1_MSB;
                           OP1_LSB = rx_data;
                           save1 = 1;
                           
                           
            end
            
            Wait_OP1_MSB: begin
                          if(rx_ready)
                            next_state = Store_OP1_MSB;
            end
            
            Store_OP1_MSB: begin
                           next_state = Wait_OP2_LSB;
                           OP1_MSB = rx_data;
                           save2 = 1;
                           enter = 1;
            end
            
            Wait_OP2_LSB: begin
                          if(rx_ready)
                            next_state = Store_OP2_LSB;
            end
            
            Store_OP2_LSB: begin
                           next_state = Wait_OP2_MSB;
                           OP2_LSB = rx_data;
                           save3 = 1;
            end
            
            Wait_OP2_MSB: begin
                          if(rx_ready)
                            next_state = Store_OP2_MSB;
            end
            
            Store_OP2_MSB: begin
                           next_state = Wait_CMD;
                           OP2_MSB = rx_data;
                           save4 = 1;
                           enter = 1;         
            end
            
            
            Wait_CMD: begin
                      if(rx_ready)
                            next_state = Store_CMD;
            end
            
            Store_CMD: begin
                       next_state = Delay_1_cycle;
                       CTRL = rx_data;
                       save5 = 1;
                       enter = 1;
            end
            
            Delay_1_cycle: begin
                           next_state = Trigger_TX_result;
            end
            
            
            Trigger_TX_result: begin
                               next_state = Wait_OP1_LSB;
                               trigger = 1;
            end
             
            default : next_state = Wait_OP1_LSB;
        endcase
    end
                
    
    registros_n_bit #(.N(8)) OP1_LSB_reg(
        .D(OP1_LSB),
        .clk(clk),
        .reset(reset),
        .load(save1),
        .Q(OP1_LSB_out)
    );
    
    registros_n_bit #(.N(8)) OP1_MSB_reg(
        .D(OP1_MSB),
        .clk(clk),
        .reset(reset),
        .load(save2),
        .Q(OP1_MSB_out)
    );
    
    registros_n_bit #(.N(8)) OP2_LSB_reg(
        .D(OP2_LSB),
        .clk(clk),
        .reset(reset),
        .load(save3),
        .Q(OP2_LSB_out)
    );
    
    registros_n_bit #(.N(8)) OP2_MSB_reg(
        .D(OP2_MSB),
        .clk(clk),
        .reset(reset),
        .load(save4),
        .Q(OP1_MSB_out)
    );
    
     registros_n_bit #(.N(8)) CTRL_reg(
        .D(CTRL),
        .clk(clk),
        .reset(reset),
        .load(save5),
        .Q(CTRL_out)
    );
    
    assign OP1 = {OP1_MSB_out, OP1_LSB_out};
    assign OP2 = {OP2_MSB_out, OP2_LSB_out};
    assign OP_code = {8'b0, CTRL_out};
    
    
endmodule
