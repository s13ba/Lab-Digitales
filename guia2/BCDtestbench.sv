`timescale 1ns / 1ps/*
//Testbench exhaustiva para el convertidor BCD a seg

module BCDtestbench();
    logic [3:0] BCD_in;
    logic [6:0] sevenSeg;
    
    BCD_to_sevenSeg DUT(
        .BCD_in(BCD_in),
        .sevenSeg(sevenSeg)
        );
        
    initial begin 
    //Test en sí: usar números del 0 al 9 y ver salidas
        BCD_in = 4'd0;
        #5
        BCD_in = 4'd1;
        #5
        BCD_in = 4'd2;
        #5
        BCD_in = 4'd3;
        #5
        BCD_in = 4'd4;
        #5
        BCD_in = 4'd5;
        #5
        BCD_in = 4'd6;
        #5
        BCD_in = 4'd7;
        #5
        BCD_in = 4'd8;
        #5
        BCD_in = 4'd9;
        
    end
endmodule
*/