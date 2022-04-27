`timescale 1ns / 1ps //Frecuencia: 10ns=100MHz
/*
//Pregunta 5.3 guía 3
//testbench para el divisor de frecuencias modificado

module Clock_freq_divider();
    
    logic   clock_100M, reset;
    logic   clock_out_50M, clock_out_30M, clock_out_10M, clock_out_1M;
    
    //Instanciado de divisores de reloj pa cada frecuencia
    Clock_divider_mod#(.FREC_OUT(50))
        Freq50( .clk_in (clock_100M),
                .clk_out(clock_out_50M),
                .reset(reset)
            );
    Clock_divider_mod#(.FREC_OUT(30))
        Freq30( .clk_in (clock_100M),
                .clk_out(clock_out_30M),
                .reset(reset)
            );
    Clock_divider_mod#(.FREC_OUT(10))
        Freq10( .clk_in (clock_100M),
                .clk_out(clock_out_10M),
                .reset(reset)
            );
    Clock_divider_mod#(.FREC_OUT(1))
        Freq1( .clk_in (clock_100M),
                .clk_out(clock_out_1M),
                .reset(reset)
            );       
      
      always #10 clock_100M=~clock_100M; //10ns: 100 MHz
      
      initial begin
        clock_100M = 0;
        reset = 1;
        #50 reset = 0; 
      end
            
endmodule
*/