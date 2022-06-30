`timescale 1ns / 1ps 
// Testbench del contador de nivel

module level_counter_dummy # (parameter count_max=8)(
    input   logic                       lv_in, CLK100MHZ, reset, slowReset,
    output  logic   [count_max-1:0]     hold_count
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
        end else if (clk_counter == 36'hfefe-1) begin

            clk_counter <= 'd0;
            CLK2HZ <= ~CLK2HZ; //invierte en vez de subir y bajar cada cierta cantidad de cantos de subida
        end else begin

            clk_counter <= clk_counter + 'd1;
            CLK2HZ <= CLK2HZ;
        end
        end

    ////// Counter //////
    

    nbit_counter#(.N(count_max)) counter_n_bit( //contador que coordina al mux y al decodificador 
         .clk(CLK2HZ),
         .reset(slowReset),
         .PB_in(lv_in),
         .count(hold_count)
         ); 
        
    // always_ff @(posedge CLK2HZ) begin

    //     if (reset) // reset lleva contador a cero
    //         hold_count <= 'd0; //contador se reinicia
    //     else 
    //         if (lv_in)
    //             hold_count <= hold_count+1; //sino, va sumando en cada canto positivo
    //         else
    //             hold_count <= hold_count;
                
    // end
        
    


endmodule


module test_level_counter();

logic CLK100MHZ, reset, slowReset, lv_in;
logic [7:0] hold_count;


level_counter_dummy
DUT(
    .lv_in(lv_in), 
    .CLK100MHZ(CLK100MHZ), 
    .reset(reset),
    .slowReset(slowReset),
    .hold_count(hold_count)
);
always #5 CLK100MHZ=~CLK100MHZ; //10ns: 100 MHz

    initial begin
        CLK100MHZ= 0;
        slowReset = 1;
        reset = 1;
        #60 reset = 0;
        #200000 slowReset = 0;
        lv_in = 1;
        #999990
        lv_in = 0;
        #999 slowReset = 1;
    end

endmodule