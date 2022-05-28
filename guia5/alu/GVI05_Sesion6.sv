`timescale 1ns / 1ps
module S6_actividad1 #(parameter N = 16) (
	input logic [N-1:0]data_in,
	input logic clk, reset, load_A, load_B, load_Op, updateRes,
	output logic [6:0] Segments,
	output logic [7:0] Anodes,
	output logic [3:0] LEDs

	);

    logic [1:0] data_Op;
	assign data_Op = data_in [1:0];
	logic [N-1 : 0] A;
	logic [N-1 : 0] B;
	logic [1:0] Op;

	registro_1_bit #(.N(N)) registro_A (
		.D(data_in),
		.clk(clk),
		.reset(reset),
		.load(load_A),
		.Q(A)
	);

	registro_1_bit #(.N(N)) registro_B (
		.D(data_in),
		.clk(clk),
		.reset(reset),
		.load(load_B),
		.Q(B)
	);

	registro_1_bit #(.N(2)) registro_Op (
		.D(data_Op),
		.clk(clk),
		.reset(reset),
		.load(load_Op),
		.Q(Op)
	);

	logic [N-1:0] Result;
	logic [3:0]   Flags;
	logic [N-1:0] SevenSegIn;

	ALU #(.M(N),.S(2)) ALU (
		.A(A),
		.B(B),
		.OpCode(Op),
		.Result(Result),
		.Status(Flags)
	);

	registro_1_bit #(.N(N)) registro_Result (
		.D(Result),
		.clk(clk),
		.reset(reset),
		.load(updateRes),
		.Q(SevenSegIn)
	);


	registro_1_bit #(.N(4)) registro_Flags(
		.D(Flags),
		.clk(clk),
		.reset(reset),
		.load(updateRes),
		.Q(LEDs)
	);


	driver_7_seg driver_7_seg(
		.clock(clk),
		.reset(reset),
		.BCD_in(SevenSegIn),
		.segments(Segments),
		.anodos(Anodes)

	);
	
endmodule