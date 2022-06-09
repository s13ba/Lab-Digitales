`timescale 1ns / 1ps


module mux_2_1_16b #(parameter N = 16)(
    input  logic [N-1:0] DataIn,
    input  logic [N-1:0] Result,
    input  logic         ToDisplaySel,

    output logic [N-1:0] ToDisplay  // valor de salida para el Display
    );

    always_comb begin
        if (ToDisplaySel)
            ToDisplay = Result;
        else
            ToDisplay = DataIn;
        
    end

endmodule