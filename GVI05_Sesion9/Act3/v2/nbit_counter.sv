module nbit_counter_1 #(parameter N=4)(
     input  logic          clk, reset,
     output logic [N-1:0]  count

    );
    always_ff @(posedge clk) begin //flip flop
    //se activa al pasar por el canto de subida del reloj
        if (reset) //si señal reset es 1...
            count <= 'd0; //contador se reinicia
        else
            count <= count+1; //sino, va sumando en cada canto positivo
    end
endmodule