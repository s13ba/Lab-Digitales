`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.07.2022 18:59:00
// Design Name: 
// Module Name: registros_n_bit
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


module registros_n_bit #(parameter N = 8)(
	input logic    [N-1:0] D,
	input logic    clk, reset, load,
	
	output logic   [N-1:0] Q

	);

	always_ff @(posedge clk) begin
		if (reset) begin
			Q = 1'b0;
		end else if (load) begin
			Q = D;
		end else begin
			Q = Q;
		end
	end
endmodule
