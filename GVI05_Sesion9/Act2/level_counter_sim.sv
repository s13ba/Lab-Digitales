`timescale 1ns / 1ps 
// Testbench del contador de nivel

module level_counter_sim# (parameter count_max=8, clk_counter_max = 33000000)(
    input   logic                       lv_in, CLK100MHZ, reset, slowReset,
    output  logic   [count_max-1:0]     hold_count
);

    ////// Conversor de 100MHz a 2Hz //////
     // Simulación: Usar slowReset para inicializar CLK

    logic CLK2HZ;
    logic GND = 0;

    clock_divider#(.COUNTER_MAX(clk_counter_max))  clk_100M_to_2Hz(   
        .clk_in (CLK100MHZ),
        .reset  (reset),
        .clk_out(CLK2HZ) );
    // Implementación física: CLK corre permanentemente
    // clock_divider#(.COUNTER_MAX(clk_counter_max))  clk_100M_to_2Hz(   
    //     .clk_in (CLK100MHZ),
    //     .reset  (GND),
    //     .clk_out(CLK2HZ) );
    ////// Counter //////
    nbit_counter#(.N(count_max)) counter_n_bit( 
         .clk   (CLK2HZ),  
         .reset (slowReset),
         .PB_in (lv_in),
         .count (hold_count)
         ); 
  


endmodule