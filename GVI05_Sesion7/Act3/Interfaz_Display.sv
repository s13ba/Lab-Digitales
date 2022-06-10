`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.06.2022 18:25:37
// Design Name: 
// Module Name: Interfaz_Display
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


module Interfaz_Display#(parameter N = 16, width_sel = 3, Max_bits = 32)(
    input logic clk,
    input logic reset,
    input logic [N-1:0]ToDisplay,
    input logic DisplayFormat,
    output logic [6:0] Segments,
    output logic [7:0] Anodes
    );
    
    logic [Max_bits-1:0]hex_num;
    logic [Max_bits-1:0]To_BCD;
    
     if (N == 32) 
        assign hex_num = ToDisplay;
    else 
        assign hex_num = {16'd0,ToDisplay};
    
    driver_7_seg #(.N(Max_bits),.count_max(width_sel))driver_7_seg(
        .clock(clk),
        .reset(reset),
        .BCD_in(To_BCD),
        .segments(Segments),
        .anodos(Anodes)
    );
    
    logic [Max_bits-1:0]dec_num;
    
	unsigned_to_bcd u32_to_bcd_inst (
		.clk(clk),
		.reset(reset),
		.trigger(1'b1),
		.in(hex_num),
		.idle(idle),
		.bcd(dec_num)
	);
	
    mux_2_1_16b #(.N(Max_bits))(
        .A(hex_num),
        .B(dec_num),
        .out(To_BCD),
        .sel(DisplayFormat)
    );
endmodule
