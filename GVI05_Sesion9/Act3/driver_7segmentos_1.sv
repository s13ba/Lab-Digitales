`timescale 1ns / 1ps

// Driver que muestra suma o resta en los últimos 2 displays
// Se activa con U xor D
module moduleName #(
    parameter N = 32 //Nro de bits
) (
    input   logic   [N-1:0] BCD_in,
    input   logic           clk,    reset,
    output  logic   [6:0]   Segments,
    output  logic   [7:0]   AN
);
    
    
endmodule