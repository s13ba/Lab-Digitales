//El módulo que junta al counter_4bit, fib_rec y BCD_to_sevenSeg 
//pa tirar un numerito al display
`timescale 1ns / 1ps

module top_module(
    input logic clk, reset,
    //logic [3:0] count,
    output logic [6:0]sevenSegInv,//por como funciona el display, hay q invertir la señal de salida
    output logic fibInv //declarar vars acá hace q miren pa afuera!!!1!
    
    );
    
//Cableado interno
    logic [3:0] cable4b;//cable de 4 bits que une a count con BCD_in
    logic [6:0] cable7b;
//Instanciar contador de 4 bits
counter_4bit counter( //<NombreModulo>(parámetros) <NombreInstancia> (weas)
    .clk  (clk),
    .reset(reset),
    .count(cable4b) //conecta solo 1 de los 4 pines 
);

//Instancia conversor BCD a 7 segmentos
BCD_to_sevenSeg BCD_to_7seg(//omitir el nombre hace q sea instanciado con su nombre original
    .BCD_in     (cable4b), //conecta solo 1 de los 4 pines 
    .sevenSeg   (cable7b) //parece irse a la mierda con los cambios de nombre
);

//Instancia reconocedor de fibinarios
fib_rec rec(
    .BCD_in (cable4b), //conecta solo 1 de los 4 pines 
    .fib    (fib)
);

//Inversión de las señales para cumplir lo que dice el datasheet sobre
//cátodo y ánodo low para encender el segmento
always_comb begin
    fibInv = ~fib;
    sevenSegInv = ~cable7b;    
end
endmodule
