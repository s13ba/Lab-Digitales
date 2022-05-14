`timescale 1ns / 1ps
module contador_testbench();

	logic clock, reset;
	logic [7:0]counter1, counter2, counter3;

	always #5 clock = ~clock;

	counter3 DUT_counter3(
		.clock(clock),
		.reset(reset),
		.counter(counter3)

	);


	counter2 DUT_counter2(
		.clock(clock),
		.reset(reset),
		.counter(counter2)

	);


	counter1 DUT_counter1(
		.clock(clock),
		.reset(reset),
		.counter(counter1)

	);	

	initial begin
        clock=0;
		reset = 1;

	#10

		reset = 0;
		
    #500
        
        reset=1;
        
    #50
    
        reset=0;
    end

endmodule
