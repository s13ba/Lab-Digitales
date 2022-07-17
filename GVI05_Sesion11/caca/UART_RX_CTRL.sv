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


module UART_RX_CTRL#(	parameter INTER_BYTE_DELAY = 1000000,   // ciclos de reloj de espera entre el envio de 2 bytes consecutivos
	parameter WAIT_FOR_REGISTER_DELAY = 100 // tiempo de espera para iniciar la transmision luego de registrar el dato a enviar
)(
    input logic clk, reset, rx_ready,
    input logic [7:0]rx_data,
    output logic trigger, Enter_ALU,
    output logic [15:0] Data_In,
    output logic [3:0]LED

    );
    
    logic [7:0] OP1_LSB, OP1_MSB, OP2_LSB, OP2_MSB, CTRL;
    logic [7:0] OP1_LSB_out, OP1_MSB_out, OP2_LSB_out, OP2_MSB_out, CTRL_out;
    logic save1, save2, save3, save4, save5;
    logic [15:0] OP1, OP2, OP_code;
    logic [1:0] Op_selector;
    logic [31:0]  hold_state_timer;
    
    
    
    enum logic [3:0] {Wait_OP1_LSB, Store_OP1_LSB, Wait_OP1_MSB, Store_OP1_MSB, Wait_OP2_LSB, Store_OP2_LSB, Wait_OP2_MSB, Store_OP2_MSB, Wait_CMD, Store_CMD, Delay_1_cycle, Trigger_TX_result} state, next_state;
    always_ff @(posedge clk) begin
        if(reset)
            state <= Wait_OP1_LSB;
        else
            state <= next_state;
    end
    
    assign LED = state;
    
    always_comb begin
        next_state = state;
        save1 = 0;
        save2 = 0;
        save3 = 0;
        save4 = 0;
        save5 = 0;
        trigger = 0;
        Op_selector = 2'b00;
        Enter_ALU = 0;
        OP1_LSB = 0;
        OP1_MSB = 0;
        OP2_LSB = 0;
        OP2_MSB = 0;
        CTRL = 0;
        
        case(state)
            Wait_OP1_LSB: begin
                          Op_selector = 2'b00;
                          if(rx_ready)
                            next_state = Store_OP1_LSB;
            end
            
            Store_OP1_LSB: begin
                           OP1_LSB = rx_data;
                           save1 = 1;
                           Op_selector = 2'b00;   
                            if(hold_state_timer >= WAIT_FOR_REGISTER_DELAY)
				                        next_state = Wait_OP1_MSB;            
            end
            
            Wait_OP1_MSB: begin
                          Op_selector = 2'b00;
                          if(rx_ready)
                            next_state = Store_OP1_MSB;                
            end
            
            Store_OP1_MSB: begin
                           OP1_MSB = rx_data;
                           save2 = 1;
                           Op_selector = 2'b00;
                           if(hold_state_timer >= WAIT_FOR_REGISTER_DELAY)
				                        next_state = Wait_OP2_LSB;               
            end
            
            Wait_OP2_LSB: begin
                          Op_selector = 2'b01;
                          Enter_ALU = 1;
                          if(rx_ready)
                            next_state = Store_OP2_LSB;                
            end
            
            Store_OP2_LSB: begin
                           OP2_LSB = rx_data;
                           save3 = 1;
                           Op_selector = 2'b01;
                           if(hold_state_timer >= WAIT_FOR_REGISTER_DELAY)
				               next_state = Wait_OP2_MSB;
            end
            
            Wait_OP2_MSB: begin
                          Op_selector = 2'b01;
                          if(rx_ready)
                            next_state = Store_OP2_MSB;                 
            end
            
            Store_OP2_MSB: begin
                           
                           OP2_MSB = rx_data;
                           save4 = 1;
                           Op_selector = 2'b01;
                           if(hold_state_timer >= WAIT_FOR_REGISTER_DELAY)
				               next_state = Wait_CMD;                        
            end

            Wait_CMD: begin
                      Op_selector = 2'b01;
                      Enter_ALU = 1;
                      if(rx_ready)
                            next_state = Store_CMD;                
            end
            
            Store_CMD: begin
                       next_state = Delay_1_cycle;
                       CTRL = rx_data;
                       save5 = 1;
                       Op_selector = 2'b10;
                       if(hold_state_timer >= WAIT_FOR_REGISTER_DELAY)
				               next_state = Delay_1_cycle;
                       
            end
            
            Delay_1_cycle: begin
                           next_state = Trigger_TX_result;
                           Op_selector = 2'b10;
                           Enter_ALU = 1;
            end

            Trigger_TX_result: begin
                               next_state = Wait_OP1_LSB;
                               trigger = 1;
                               Op_selector = 2'b10;
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
        .Q(OP2_MSB_out)
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
    
        
    always_comb begin
        case(Op_selector)
            2'b00: Data_In = OP1;
            2'b01: Data_In = OP2;
            2'b10: Data_In =  OP_code;
            default: Data_In = OP1;
        endcase
    end
    
    
    always_ff @(posedge clk) begin
    	if(state == Store_OP1_LSB || state == Store_OP1_MSB || state == Store_OP2_LSB || state == Store_OP2_MSB || state == Store_CMD) begin
    		hold_state_timer <= hold_state_timer + 1;
    	end else begin
    		hold_state_timer <= 0;
    	end
	end
    
    
endmodule
