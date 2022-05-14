//counter 2

//***Segundo modulo***

module contador2#(parameter N = 8)(
    input logic clock, reset,
    output logic [N-1:0] counter
);

    logic [N-1:0]   counter_next;

    always_comb begin
        //Define valor pa acutalizar al siguiente ciclo
        counter_next = counter + 'd1;
    end

    always_ff @(posedge clock) begin
        //Propaga valor en posedge clock
        //Manipula el CUANDO
        if (reset)
            counter <= 'd0;
        else  
            counter <= counter_next;
    end
endmodule