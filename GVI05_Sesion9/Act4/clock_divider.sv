`timescale 1ns / 1ps
//Pregunta 5.2


module clock_divider
#(parameter COUNTER_MAX = 100000) //nro de cantos de subida hasta invertir clk_out
( input logic clk_in,
  input logic reset,
  output logic clk_out );

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