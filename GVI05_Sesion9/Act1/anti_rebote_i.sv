`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.06.2022 00:19:21
// Design Name: 
// Module Name: anti_rebote_i
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


module anti_rebote_i#(parameter DELAY1 = 100000000, DELAY2 = 5000000, DELAY3 = 100000, count_8 = 8, COUNTER_MAX = 200000)(
    input logic clock,
    input logic reset,
    input logic reset2,
    input logic BTNC,
    output logic [6:0]  segments,   // {CA, CB, CC, CD, CE, CF, CG}
    output logic [7:0]  anodos      // {AN7, AN6, AN5, AN4, AN3, AN2, AN1, AN0}
    );
    
    logic to_counter_high, to_counter_std, to_counter_low;
    logic [7:0] PB_high, PB_std, PB_low;
    logic clk_250;
    
    PB_Debouncer_FSM#(.DELAY(DELAY1)) PB_Debouncer_FSM_high(
    .clk(clock),
    .rst(reset),
    .PB(BTNC),
    .PB_pressed_pulse(to_counter_high) 
    );
    
    PB_Debouncer_FSM#(.DELAY(DELAY2)) PB_Debouncer_FSM_std(
    .clk(clock),
    .rst(reset),
    .PB(BTNC),
    .PB_pressed_pulse(to_counter_std) 
    );
    
    PB_Debouncer_FSM#(.DELAY(DELAY3)) PB_Debouncer_FSM_low(
    .clk(clock),
    .rst(reset),
    .PB(BTNC),
    .PB_pressed_pulse(to_counter_low) 
    );
    
    nbit_counter#(.N(count_8)) counter_n_bit_high( //contador que coordina al mux y al decodificador 
         .clk(clock),
         .reset(reset),
         .PB_in(to_counter_high),
         .count(PB_high)
         );
         
    nbit_counter#(.N(count_8)) counter_n_bit_std( //contador que coordina al mux y al decodificador 
         .clk(clock),
         .reset(reset),
         .PB_in(to_counter_std),
         .count(PB_std)
         );
         
    nbit_counter#(.N(count_8)) counter_n_bit_low( //contador que coordina al mux y al decodificador 
         .clk(clock),
         .reset(reset),
         .PB_in(to_counter_low),
         .count(PB_low)
         );
    
    
    driver_7_seg driver_7_seg(
        .clock(clk_250),
        .reset(reset2),
        .PB_high(PB_high),
        .PB_std(PB_std),
        .PB_low(PB_low),
        .segments(segments),
        .anodos(anodos)  
        );
        
    clock_divider#(.COUNTER_MAX(COUNTER_MAX)) clock_divider(
        .clk_in(clock),
        .reset(reset),
        .clk_out(clk_250)
    );
    
    
endmodule
