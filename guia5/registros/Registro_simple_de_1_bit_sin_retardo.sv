module register_1_bit #(parameter N = 1)(
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