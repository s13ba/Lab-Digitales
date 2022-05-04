`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// University: Universidad Tecnica Federico Santa Maria
// Course: ELO212
// Students: Cristobal Caqueo, Bastian Rivas, Claudio Zanetta
// 
// Create Date: 03/05/2022
// Design Name: Guia 4
// Module Name: S4_actividad1
// Project Name: mux_multiples_displays
// Target Devices: xc7a100tcsg324-1
// Tool Versions: Vivado 2021.1
// Description: Display de numeros hexadecimales en 8 displays de 7 segmentos
// 
// Dependencies: Lab Digitales
// 
// Revision: 0.01
// Revision 0.01 - File Created
// Additional Comments: Modulo top que recibe un numero y lo muestra
// 
//////////////////////////////////////////////////////////////////////////////////


module S4_actividad1(
    input  logic        clock,
    input  logic        reset,
    input  logic [31:0] BCD_in,
    output logic [6:0]  segments,
    output logic [7:0]  anodos
    );
    
    //***Primera parte: Separar digitos del numero, convertir 1 digito a 7seg por la vez***
    
    //Digitos (hex) del numero ingresado:
    
    logic [3:0] BCD_1, BCD_2, BCD_3, BCD_4,
                BCD_5, BCD_6, BCD_7, BCD_8;

    assign BCD_1 = BCD_in[3:0]; 
    assign BCD_2 = BCD_in[7:4];
    assign BCD_3 = BCD_in[11:8];
    assign BCD_4 = BCD_in[15:12];

    assign BCD_5 = BCD_in[19:16];
    assign BCD_6 = BCD_in[23:20];
    assign BCD_7 = BCD_in[27:24];
    assign BCD_8 = BCD_in[31:28];    
    
    mux_8_1 mux_8_1(
         .A(BCD_1),
         .B(BCD_2),
         .C(BCD_3),
         .D(BCD_4),
         .E(BCD_5),
         .F(BCD_6),
         .G(BCD_7),
         .H(BCD_8),
         .sel(sel),
         .out(sevenSeg_in)
         );  
    
    logic [3:0]sevenSeg_in; //Cable que conecta Mux con conversor BCD->7Seg
    
    BCD_to_sevenSeg BCD_to_sevenSeg(
        .BCD_in(sevenSeg_in),//No confundir pin de entrada del conversor con el numero que viene de afuera. 
                            //Considerar cambiar el nombre si trae conflictos
        .sevenSeg(segments)
        );
        
    //***Segunda parte: mostrar un numero unico y escoger su display***
    
    logic [2:0]sel; //sel coordina al decodificador y al mux que maneja los digitos
    
    nbit_counter#(.N(3)) counter_3_bit(
         .clk(clock),
         .reset(reset),
         .count(sel)
         ); 
        
    deco_binario_3_cold decoder(
        .sel(sel),
        .out(anodos)
        );
    
endmodule