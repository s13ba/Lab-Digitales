//De la pregunta 3.5 de la guía 2

module counter_4bit(
    input  logic        clk, reset,
    output logic [3:0]  count
    );
    
    always_ff @(posedge clk) begin //flip flop
    //se activa al pasar por el canto de subida del reloj
        if (reset) //si señal reset es 1...
            count <= 4'b0; //contador se reinicia
        else
            count <= count+1; //sino, va sumando en cada canto positivo
    end
endmodule
