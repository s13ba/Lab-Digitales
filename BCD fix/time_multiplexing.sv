`timescale 1ns / 1ps

module time_multiplexing();
    
    logic clk, freq_reset, count_reset;
    logic [6:0]SevenSeg;
    logic [3:0]out_display;

logic clk_30, clk_1;

    Clock_divider_mod#(.FREC_OUT(1.0)) Freq1(
                .clk_in (clk),
                .clk_out(clk_1),
                .reset(freq_reset)
             );
    Clock_divider_mod#(.FREC_OUT(30.0)) Freq30(
                .clk_in (clk),
                .clk_out(clk_30),
                .reset(freq_reset)
             );
             
logic [1:0] count_2;
            
    nbit_counter#(.N(2)) counter_2_bit(
               .clk(clk_30),
               .reset(count_reset),
               .count(count_2)
               ); 
               
     
    deco_binario_2_cold deco(
                .sel(count_2),
                .y(out_display)
                );    
             
 logic [15:0]count_16;
 
    nbit_counter#(.N(16)) counter_16_bit(
               .clk(clk_1),
               .reset(count_reset),
               .count(count_16)
               );
         /*           
assign [3:0]BCD_1 = count_16[3:0];
assign [3:0]BCD_2 = count_16[7:4];
assign [3:0]BCD_3 = count_16[11:8];
assign [3:0]BCD_4 = count_16[15:12];
*/

logic [3:0]BCD_1, BCD_2, BCD_3, BCD_4;

assign BCD_1 = count_16[3:0];
assign BCD_2 = count_16[7:4];
assign BCD_3 = count_16[11:8];
assign BCD_4 = count_16[15:12];

logic [3:0]sevenSeg_in;

    mux_4_1 mux_4_1(
         .A(BCD_1),
         .B(BCD_2),
         .C(BCD_3),
         .D(BCD_4),
         .sel(count_2),
         .out(sevenSeg_in)
         );  
         
    BCD_to_sevenSeg_inv sevenSeg(
        .BCD_in(sevenSeg_in),
        .sevenSeg(SevenSeg)
        );
      always #5 clk=~clk; //10ns: 100 MHz
      initial begin
        clk = 0;
        freq_reset = 1;
        count_reset = 1;
        #20 freq_reset = 0; 
        #600 count_reset = 0;
      end    
      

endmodule
