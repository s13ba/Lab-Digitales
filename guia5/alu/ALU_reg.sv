module ALU_reg #(Parameter N = 16) (
	input logic [N-1:0]data_in,
	input logic clk, reset, load_A, load_B, load_Op, updateRes
	output logic [6:0] Segments,
	output logic [7:0] Anodes,
	output logic [3:0] LEDs

	);

	assign [1:0] data_Op = data_in [1:0];
	logic [N-1 : 0] A;
	logic [N-1 : 0] B;
	logic [1:0] Op;

	module 1_bit_register #(.N(N)) registro_A (
		.D(data_A),
		.clk(clk),
		.reset(reset),
		.load(load_A),
		.Q(A)
	);

	module 1_bit_register #(.N(N)) registro_B (
		.D(data_B),
		.clk(clk),
		.reset(reset),
		.load(load_B),
		.Q(B)
	);

	module 1_bit_register #(.N(N)) registro_Op (
		.D(data_Op),
		.clk(clk),
		.reset(reset),
		.load(load_Op),
		.Q(A)
	);

	logic [N-1:0] Result;
	logic [3:0] Flags;
	logic [N-1:0] SevenSegIn;

	module ALU #(.M(N),.S(2)) ALU (
		.A(A),
		.B(B),
		.OpCode(Op),
		.Result(Result),
		.Status(Flags)
	);

	module 1_bit_register #(.N(N)) registro_Result (
		.D(Result),
		.clk(clk),
		.reset(reset),
		.load(updateRes),
		.Q(SevenSegIn)
	);


	module 1_bit_register #(.N(4)) registro_Result (
		.D(data_B),
		.clk(clk),
		.reset(reset),
		.load(updateRes),
		.Q(LEDs)
	);


	module 7_seg_driver (
		.clk(clk),
		.reset(reset),
		.BCD_in(SevenSegIn),
		.segments(Segments),
		.anodos(Anodes)

	);