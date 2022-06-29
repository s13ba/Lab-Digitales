`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// University: Universidad Tecnica Federico Santa Maria
// Course: ELO212
// Students: Cristobal Caqueo, Bastian Rivas, Claudio Zanetta
// 
// Create Date: 03/05/2022
// Design Name: guia5_alu
// Module Name: Hex_to_7seg_driver
// Project Name: guia5_alu
// Target Devices: xc7a100tcsg324-1
// Tool Versions: Vivado 2021.1
// Description: Display de numeros hexadecimales en 8 displays de 7 segmentos
// 
// Dependencies: Lab Digitales
// 
// Revision: 1.11 - Parametrizado el contador del driver 7 seg
// Additional Comments: Puede recibir un numero de hasta 32 bits y rellena los no
//                      utilizados con ceros
// 
//////////////////////////////////////////////////////////////////////////////////

//Maximo: 32 bits

module driver_7_seg#(parameter N = 32, count_max = 3)(
    input  logic        clock,
    input  logic        reset,
    input  logic [7:0]  PB_high,
    input  logic [7:0]  PB_std,
    input  logic [7:0]  PB_low,     // informacion a mostrar
    output logic [6:0]  segments,   // {CA, CB, CC, CD, CE, CF, CG}
    output logic [7:0]  anodos      // {AN7, AN6, AN5, AN4, AN3, AN2, AN1, AN0}
    );
    // nro anodos=nroBCD/4
    
    // Concatenacion de numeros para rellenar por si es menor a 32 bits (8 segmentos)
     //numero a tratar
    
    
    //***Primera parte: Separar digitos del numero, convertir 1 digito a 7seg por la vez***
    
    //Digitos (hex) del numero ingresado:
    logic [3:0]sevenSeg_in; //Cable que conecta Mux con conversor BCD->7Seg
    logic [count_max-1:0]sel; //sel coordina al decodificador y al mux que maneja los digitos
    logic [3:0] BCD_1, BCD_2, BCD_3, BCD_4,
                BCD_5, BCD_6, BCD_7, BCD_8;
    //logic [7:0] anodos;

//Separacion por digito. BCD_n es el digito n
    assign BCD_1 = PB_low[3:0]; 
    assign BCD_2 = PB_low[7:4];
    assign BCD_3 = 4'b0;
    assign BCD_4 = PB_std[3:0];
    assign BCD_5 = PB_std[7:4];
    assign BCD_6 = 4'b0;
    assign BCD_7 = PB_high[3:0];
    assign BCD_8 = PB_high[7:4];    


    
    mux_8_1#(.N(count_max)) mux_8_1(                    //mux para separar digitos
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
    
    BCD_to_sevenSeg BCD_to_sevenSeg(    //conversor por digitos
        .BCD_in(sevenSeg_in),
        .sevenSeg(segments)
        );
        
        
    //***Segunda parte: mostrar un numero unico y escoger su display***
    
    nbit_counter#(.N(count_max)) counter_n_bit( //contador que coordina al mux y al decodificador 
         .clk(clock),
         .reset(reset),
         .PB_in(1),
         .count(sel)
         ); 
        
    deco_binario_3_cold#(.N(count_max)) decoder(        //decodificador que maneja los anodos
        .sel(sel),
        .out(anodos)
        );

    // Limitar numero de displays a encenderse

    // logic [7:0] controlAnodos;
    // logic [3:0] LSBdeco_out;
    // assign LSBdeco_out = anodos[3:0];
    // assign controlAnodos = {4'b1111, LSBdeco_out};
    
    // always_comb begin
    //     case (N)
    //         16: anodos = controlAnodos;
    //         32: anodos = anodos;
        
    //     default: anodos = anodos;
    //     endcase
    // end
    
endmodule