`timescale 1ns / 1ps

// Transcripcion de los modulos de la guia 5 del lab

//***Primer modulo***

module counter1#(parameter N = 8)(
    input logic clock,  reset,
    output logic [N-1:0] counter
);

    always_ff @(posedge clock) begin
        if (reset)
            counter <= 'd0;
        else 
        //Logica combinacional

        counter <= counter + 'd1;
    end
endmodule


//***Segundo modulo***

module counter2#(parameter N = 8)(
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

//***Tercer Modulo***

module counter3#(parameter N = 8)(
    input logic clock, reset,
    output logic [N-1:0] counter
);

    logic [N-1:0] counter_next;

    always_comb begin
        //Combinacional la lleva aca. 
        //Controla reset y salida siguiente

        if (reset)
            counter_next = 'd0;
        else
            counter_next = counter + 'd1;
    end

    always_ff @(posedge clock) begin
        //Muestra actualizacion del valor
        counter <= counter_next;
    end
endmodule