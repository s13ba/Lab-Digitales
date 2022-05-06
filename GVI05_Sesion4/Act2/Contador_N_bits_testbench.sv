`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// University: Universidad Tecnica Federico Santa Maria
// Course: ELO212
// Students: Cristobal Caqueo, Bastian Rivas, Claudio Zanetta
// 
// Create Date: 04.05.2022 23:57:11
// Design Name: Contador_N_bits_testbench
// Module Name: Contador_N_bits_testbench
// Project Name: Contador_N_bits_testbench
// Target Devices: xc7a100tcsg324-1
// Tool Versions: Vivado 2021.1
// Description: Testbench para el módulo Contador_N_bits
// 
// Dependencies: Lab Digitales
// 
// Revision: 0.01
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Contador_N_bits_testbench();
	logic clock, reset, dec, enable, load;
	logic [31:0] load_value, counterN;

	Contador_N_bits #(.N(32)) DUT(
		.clock(clock),
		.reset(reset),
		.dec(dec),
		.enable(enable),
		.load(load),
		.load_value(load_value),
		.counterN(counterN)
		);
    always #5 clock=~clock;         //señal de clock
	initial begin

        clock = 0;
		reset = 1;				    
		load = 0;
		enable = 0;
		dec = 0;
		load_value = 'd32;
		
		#10

		reset=0;
		load = 1;
		
		#20
		
		reset=1;
		
		#20
		
		reset=0;
		
		#20
		
		enable = 1;
		
		#20
		
		dec = 1;
		
		#20
		
		load = 0;
		enable = 0;
		dec = 0;
		
		#20
		
		reset = 1;
		load = 1;
		enable = 1;
		dec = 1;
		
		#20
		
		reset = 0;
		enable = 0;
		
		#20
		
		load = 0;
		enable = 1;
		dec = 0;
		
		#60
		
		reset = 1;
		
		#20
		
		reset = 0;
		dec = 1;
		
		#60
		
		load = 1;
		enable = 0;
		dec = 0;
		
		#20
		
		load_value = 'hFFFFFFFF;
		
		#20
		
		load = 0;
		enable = 1;
		
		#60
		
		reset = 1;
		enable = 0;
		dec = 1;
		
		#20
		
		reset = 0;
		
		#20
		
		reset = 1;
		enable = 1;
		
		#20
		
		reset = 0;
		load = 1;
		enable = 0;
		
		#20
		
		reset = 1;
		
		#20
		
		reset = 0;
		load = 0;
		enable = 1;
		dec = 0;
		
		#60
		
		enable = 0;
		dec = 1;
		
		#20
		
		reset = 1;
		load = 1;
		enable = 1;
		dec = 0;
			
	
    end	
endmodule

	
		
