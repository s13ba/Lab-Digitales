`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.06.2022 00:19:21
// Design Name: 
// Module Name: Contador_1_debouncer
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


module Contador_1_debouncer#(parameter PB_DELAY = 5_000_000, count_8 = 8, DISPLAY_COUNTER = 100000)(
    input logic clock,
    input logic reset,
    input logic reset2,
    input logic BTNC,
    output logic [6:0]  segments,   // {CA, CB, CC, CD, CE, CF, CG}
    output logic [7:0]  anodos      // {AN7, AN6, AN5, AN4, AN3, AN2, AN1, AN0}
    );
    
    logic PB_pressed_pulse, PB_pressed_status, PB_released_pulse;
    logic [7:0] press_count, hold_count, release_count;
    //logic clk_250;
    

    PB_Debouncer_FSM#(.DELAY(PB_DELAY)) PB_Debouncer_FSM_std(
        .clk                (clock),
        .rst                (reset),
        .PB                 (BTNC),
        .PB_pressed_pulse   (PB_pressed_pulse),
        .PB_pressed_status  (PB_pressed_status), 
        .PB_released_pulse  (PB_released_pulse)
    );
    
    nbit_counter#(.N(count_8)) Pulse_counter( 
         .clk   (clock),
         .reset (reset),
         .PB_in (PB_pressed_pulse),
         .count (press_count)
         );
        
    logic GND;
    assign GND = 0;

    level_counter# (.count_max(count_8)) Level_counter(
        .lv_in      (PB_pressed_status), 
        .CLK100MHZ  (clock), 
        .reset      (reset), 
        .slowReset  (GND),
        .hold_count (hold_count)
    );
         
    nbit_counter#(.N(count_8)) Release_counter( 
         .clk   (clock),
         .reset (reset),
         .PB_in (PB_released_pulse),
         .count (release_count)
         );
    
    
    driver_7_seg driver_7_seg(
        .clock(clk_250),
        .reset(reset2),
        .PB_high(press_count),
        .PB_std(hold_count),
        .PB_low(release_count),
        .segments(segments),
        .anodos(anodos)  
        );

    clock_divider#(.COUNTER_MAX(DISPLAY_COUNTER)) clock_divider(
        .clk_in(clock),
        .reset(reset),
        .clk_out(clk_250)
    );
    
    
endmodule
