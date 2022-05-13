`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// University: Universidad Tecnica Federico Santa Maria
// Course: ELO212
// Students: Cristobal Caqueo, Bastian Rivas, Claudio Zanetta
// 
// Create Date: 03/05/2022
// Design Name: guia5_alu
// Module Name: Hex_to_7seg_driver
// Project Name: mux_multiples_displays
// Target Devices: xc7a100tcsg324-1
// Tool Versions: Vivado 2021.1
// Description: Display de numeros hexadecimales en 4 displays de 7 segmentos
// 
// Dependencies: Lab Digitales
// 
// Revision: 0.01
// Revision 0.01 - File Created
// Additional Comments: Modulo top que recibe un numero y lo muestra
// 
//////////////////////////////////////////////////////////////////////////////////

//Ver como parametrizar!!! Por defecto: 16 bits

module driver_7_seg(
    input  logic        clock,
    input  logic        reset,
    input  logic [15:0] BCD_in,
    output logic [6:0]  segments,   // {CA, CB, CC, CD, CE, CF, CG}
    output logic [7:0]  anodos      // {AN7, AN6, AN5, AN4, AN3, AN2, AN1, AN0}
    );
    // nro anodos=nroBCD/4

    //***Primera parte: Separar digitos del numero, convertir 1 digito a 7seg por la vez***
    
    //Digitos (hex) del numero ingresado:
    logic [3:0]sevenSeg_in; //Cable que conecta Mux con conversor BCD->7Seg
    logic [1:0]sel; //sel coordina al decodificador y al mux que maneja los digitos
    logic [3:0] BCD_1, BCD_2, BCD_3, BCD_4/*,
                BCD_5, BCD_6, BCD_7, BCD_8*/;

//Parametrizar!!!
    assign BCD_1 = BCD_in[3:0]; 
    assign BCD_2 = BCD_in[7:4];
    assign BCD_3 = BCD_in[11:8];
    assign BCD_4 = BCD_in[15:12];
/*
    assign BCD_5 = BCD_in[19:16];
    assign BCD_6 = BCD_in[23:20];
    assign BCD_7 = BCD_in[27:24];
    assign BCD_8 = BCD_in[31:28];    
*/

    
    mux_4_1 mux_4_1(                    //mux para separar digitos
         .A(BCD_1),
         .B(BCD_2),
         .C(BCD_3),
         .D(BCD_4),
         /*
         .E(BCD_5),
         .F(BCD_6),
         .G(BCD_7),
         .H(BCD_8),
         */
         .sel(sel),
         .out(sevenSeg_in)
         );  
    
    BCD_to_sevenSeg BCD_to_sevenSeg(    //conversor por digitos
        .BCD_in(sevenSeg_in),
        .sevenSeg(segments)
        );
        
        
    //***Segunda parte: mostrar un numero unico y escoger su display***
    
    nbit_counter#(.N(2)) counter_2_bit( //contador que coordina al mux y al decodificador 
         .clk(clock),
         .reset(reset),
         .count(sel)
         ); 
        
    deco_binario_2_cold decoder(        //decodificador que maneja los anodos
        .sel(sel),
        .out(anodos)
        );
    
endmodule