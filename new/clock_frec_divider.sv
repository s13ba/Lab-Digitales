`timescale 1ns / 1ps
//Pregunta 5.2
//Modificación del clock_divider, ahora con más tula! (y en base a frecuencias)

module Clock_divider_mod
#(parameter FREC_OUT = 30.0,
            FREC_IN = 100.0)  //frecuencias en MHz. Ojo que debe recibir valores racionales!!!!!!!

( input logic clk_in,
  input logic reset,
  output logic clk_out );
    
  localparam COUNTER_MAX = $ceil((FREC_IN / (2*FREC_OUT)));
  localparam DELAY_WIDTH = $clog2(COUNTER_MAX); //clog define el nro de bits necesarios pa representar el contador
  logic [DELAY_WIDTH-1:0] counter = 'd0; //le epic contador

  always_ff @(posedge clk_in) begin //se pasea por los cantos de reloj
    if (reset == 1'b1) begin //reiniciar si hay reset

        counter <= 'd0;
        clk_out <= 0;
    end else if (counter == COUNTER_MAX-1) begin

        counter <= 'd0;
        clk_out <= ~clk_out; //invierte en vez de subir y bajar cada cierta cantidad de cantos de subida
    end else begin

        counter <= counter + 'd1;
        clk_out <= clk_out;
    end
    end

endmodule