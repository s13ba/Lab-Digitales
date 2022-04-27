module logica_simple(
    input logic A, B, C,
    output logic X, Y, Z
    );
    
    assign X=A;
    assign Y=~A;
    assign Z=B&C;
    
endmodule
