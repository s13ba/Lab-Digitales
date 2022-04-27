/*`timescale 1ns/1ps //`timescale

module test_simple();

    logic [3:0] BCD_in;
    logic fib;
    
    fib_rec DUT(
        .BCD_in(BCD_in),
        .fib(fib)
        );
        
    initial begin
        BCD_in = 4'b0000;
        #3
        BCD_in = 4'b0001;
        #3
        BCD_in = 4'b0011;
        #3
        BCD_in = 4'b0111;
    end
endmodule
        */