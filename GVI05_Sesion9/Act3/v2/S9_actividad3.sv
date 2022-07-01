`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.06.2022 02:03:44
// Design Name: 
// Module Name: S9_actividad4
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


module S9_actividad3 #(parameter N_DEBOUNCER = 5000000, counter = 100000)( //Modulo top que va a la plaquita
    input logic CLK100MHZ,
    input logic CPU_RESETN,
    input logic BTNR, BTND, BTNU, BTNL,
    input logic [15:0]SW,
    output logic CA, CB, CC, CD, CE, CF, CG,
    output logic [15:0]LED,
    output logic [7:0] AN
    );
    
    logic reset;
    assign reset = ~CPU_RESETN;
    
    
    logic   [7:0]   A,  B;
    assign A =  SW[7 :0];
    assign B =  SW[15:8];
    //assign LED[12:4] = 'b0;
    
    logic [1:0] OpCode;
    logic [1:0] RLDU;
    logic [7:0] Result;
    logic [3:0] Flags;
    
    ALU_comb#(.M(8)) ALU (
        .A(A), 
        .B(B),
        .OpCode(OpCode),
        .Result(Result),
        .Status(Flags)
        );
        
    logic deb_BTNU;
    logic deb_BTND;
    logic deb_BTNR;
    logic deb_BTNL;
    
    
    PB_Debouncer_FSM #(.DELAY(N_DEBOUNCER))BTNU_Debouncer(
        .clk                  (CLK100MHZ),
	    .rst                  (reset), 
	    .PB                   (BTNU),
	    .PB_pressed_status    (deb_BTNU),
	    .PB_pressed_pulse     (), // solo nos interesa el pulso
        .PB_released_pulse    ()
        );
        
    PB_Debouncer_FSM #(.DELAY(N_DEBOUNCER))BTND_Debouncer(
        .clk                  (CLK100MHZ),
	    .rst                  (reset), 
	    .PB                   (BTND),
	    .PB_pressed_status    (deb_BTND),
	    .PB_pressed_pulse     (), // solo nos interesa el pulso
        .PB_released_pulse    ()
        );
        
    PB_Debouncer_FSM #(.DELAY(N_DEBOUNCER))BTNR_Debouncer(
        .clk                  (CLK100MHZ),
	    .rst                  (reset), 
	    .PB                   (BTNR),
	    .PB_pressed_status    (deb_BTNR),
	    .PB_pressed_pulse     (), // solo nos interesa el pulso
        .PB_released_pulse    ()
        );
        
    PB_Debouncer_FSM #(.DELAY(N_DEBOUNCER))BTNL_Debouncer(
        .clk                  (CLK100MHZ),
	    .rst                  (reset), 
	    .PB                   (BTNL),
	    .PB_pressed_status    (deb_BTNL),
	    .PB_pressed_pulse     (), // solo nos interesa el pulso
        .PB_released_pulse    ()
        );
       
    logic [3:0]to_decs;
    assign to_decs = {deb_BTNL, deb_BTNR, deb_BTND, deb_BTNU};
          
    Dec_mod_debouncer_1 Dec_mod_debouncer_1(
        .sel(to_decs),
        .out(OpCode)
        );
        
    Dec_mod_debouncer_2 Dec_mod_debouncer_2(
        .sel(to_decs),
        .out(RLDU)
        ); 
    logic [15:0] AB;
    assign AB = {B,A};
    logic [7:0] M_Leds;
    
    LED_ctrl LED_ctrl(
    .sel(OpCode),
    .data(Result),
    .out(M_Leds)
    );
    
    logic [15:0] Flags_1;
    assign Flags_1 = {M_Leds, 4'b0, Flags};
    
    
    logic [6:0] segments_0;
    logic [6:0] segments_1;
    logic [7:0] anodes_0;
    logic [7:0] anodes_1;
    
    Seg_ctrl Seg_ctrl(
        .sel(RLDU),
        .data0(segments_0),
        .data1(segments_1),
        .out({CA, CB, CC, CD, CE, CF, CG})
    );
    
    AN_ctrl AN_ctrl(
        .sel(RLDU),
        .data0(anodes_0),
        .data1(anodes_1),
        .out(AN)
    );
    
    logic clock_300;
    
    clock_divider#(.COUNTER_MAX(counter)) clock_divider(
        .clk_in(CLK100MHZ),
        .reset(reset),
        .clk_out(clock_300)
    );
    
    driver_7_seg_uno#(.N(8), .count_max(1)) driver_7_seg_uno(
        .clock(clock_300),
        .reset(reset),
        .BCD_in(Result),
        .segments(segments_0),
        .anodos(anodes_0)
    );
    driver_7segmentos_2(
        .clock(clock_300),
        .reset(reset),
        .BCD_in(AB),
        .segments(segments_1),
        .anodes_1(anodes_1)
    );
    
    mux_led mux_led(
        .sel(RLDU),
        .data0(AB),
        .data1(Flags_1),
        .out(LED)
    );
    
endmodule
