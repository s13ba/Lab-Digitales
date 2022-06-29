module LED_test(
    input  logic  [15:0]  SW,
    output logic  [15:0]  LED
);

    assign SW = LED;
    
    // logic switch, led;
    // assign switch = SW[0];
    // assign led = LED[0];

    // always_comb begin
    //     if (switch)
    //         led = 1'b1;
    //     else
    //         led = 1'b0;
    // end
    
endmodule