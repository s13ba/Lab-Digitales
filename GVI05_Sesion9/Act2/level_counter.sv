`timescale 1ns / 1ps

module level_counter # (parameter count_bits=8)(
    input   logic                       lv_in, CLK100MHZ, reset,
    output  logic   [count_bits-1:0]    hold_count
);

    ////// Conversor de 100MHz a 2Hz //////

    localparam DELAY_WIDTH = 36; // para pasar de 100MHz a 2Hz
    logic [DELAY_WIDTH-1:0] clk_counter = 'd0; //le epic contador

    logic clk_in, CLK2HZ;
    
    assign clk_in  = CLK100MHZ;

    always_ff @(posedge clk_in) begin //se pasea por los cantos de reloj
        if (reset) begin //reiniciar si hay reset
        
            clk_counter <= 'd0;
            CLK2HZ <= 0;
        end else if (clk_counter == 36'hba43b7400-1) begin

            clk_counter <= 'd0;
            CLK2HZ <= ~CLK2HZ; //invierte en vez de subir y bajar cada cierta cantidad de cantos de subida
        end else begin

            clk_counter <= clk_counter + 'd1;
            CLK2HZ <= CLK2HZ;
        end
        end

    ////// Counter //////

    always_ff @(posedge CLK2HZ) begin

        if (reset) // reset lleva contador a cero
            hold_count <= 'd0; //contador se reinicia
        else 
            if (lv_in)
                hold_count <= hold_count+1; //sino, va sumando en cada canto positivo
            else
                hold_count <= hold_count;
                
    end
        
    


endmodule
