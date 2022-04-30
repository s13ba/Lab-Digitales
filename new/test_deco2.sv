`timescale 1ns / 1ps/*
//Testbench exhaustiva para el convertidor BCD a seg

module test_deco2();
    logic a,b;
    logic [3:0]y;
    
    deco_binario_2 DUT(
        .a(a),
        .b(b),
        .y(y)
        );
        
    initial begin 
    //Test en sí: usar números del 0 al 3 y ver salidas
        {a,b} = 2'b00;
        #5
        {a,b} = 2'b01;
        #5
        {a,b} = 2'b10;
        #5
        {a,b} = 2'b11;
    end
endmodule*/