`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.05.2022 23:57:11
// Design Name: 
// Module Name: test_cont_n_bit
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

	
		
