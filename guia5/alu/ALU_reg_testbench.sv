`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// University: Universidad Tecnica Federico Santa Maria
// Course: ELO212
// Students: Cristobal Caqueo, Bastian Rivas, Claudio Zanetta
// 
// Create Date: 17/05/2022
// Design Name: guia5_alu
// Module Name: ALU_reg_testbench
// Project Name: guia5_alu
// Target Devices: xc7a100tcsg324-1
// Tool Versions: Vivado 2021.1
// Description: Testbench de la ALU con registro de la guia 5
//              La intencion es insertar valores y verificar el funcionamiento de los registros
// 
// Dependencies: Lab Digitales
// 
// Revision: 0.01 
// Revision 0.01 - File Created
// Additional Comments: 
// 
//////////////////////////////////////////////////////////////////////////////////

module ALU_reg_testbench();

    logic   clk, reset, load_A, load_B, load_Op, updateRes;  
    logic   [6:0]     Segments; 
    logic   [7:0]     Anodes;
    logic   [3:0]     LEDs;
    logic   [15:0]    data_in;  //Se va a usar el valor por defecto de 16 bits (4 displays)


        ALU_reg #(
        .N                 (16)
    ) DUT (
        .data_in           (data_in),
        .clk               (clk),
        .reset             (reset),
        .load_A            (load_A),
        .load_B            (load_B),
        .load_Op           (load_Op),
        .updateRes         (updateRes),
        .Segments          (Segments),
        .Anodes            (Anodes),
        .LEDs              (LEDs)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset = 1;

        #10 reset = 0;

        #10

        //Cargar primer dato en A: 

        data_in = 16'hffff;

        #10 load_A = 1;

        #10 load_A = 0;

        #10

        //Cargar segundo dato en B:

        data_in = 16'h1010;

        #10 load_B = 1;

        #10 load_B = 0;

        #10

        //Cargar operacion a hacer

        data_in = 16'd0; //00: Suma

        #10 load_Op = 1;

        #10 load_Op = 0;

        #10

        //Mostrar resultado

        updateRes = 1;

        #10 updateRes = 0;

        //Reset sincronico

        #200 reset = 1;

        #2  reset = 0;

        #5  reset = 1;

        #10 reset = 0;

        //updateRes para mostrar LED de cero

        #10 updateRes = 1;
        #10 updateRes = 0;
        
    end
    
endmodule