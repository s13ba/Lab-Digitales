module fibinario(
    input logic A, B, C, D, //palabra de 4 dígitos en gray, cada literal es 1 dígito
    output logic Z //Z: es fibonario? 0: si, 1: no
    );

    assign Z = ~A&&~C || ~B&&~C || ~B&&~D; 
    
endmodule
