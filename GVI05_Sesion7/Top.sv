// Modulo top que se le carga a la tarjeta.
// Instancia al modulo de la calculadora RPN con los parametros correctos

module calc_top(
    input   logic  [15:0]  SW,
    input   logic          CLK100MHZ, 
    input   logic          CPU_RESETN, BTNR, BTNL, BTND // Reset, Undo, Enter, DisplayFormat
    output  logic          CA, CB, CC, CD, CE, CF, CG,  // Segmentos 
    output  logic  [ 7:0]  AN,                          // Anodos
    output  logic  [15:0]  LED

);
    logic [15:0]  DataIn;
    assign DataIn = SW;

    logic [ 6:0]  Segments;
    assign Segments = {CA, CB, CC, CD, CE, CF, CG};

    logic [ 7:0]  Anodes;
    assign Anodes = AN;



    S7_actividad3 #(parameter N_DEBOUNCER = 10)(
        // input  logic        clk,
        // input  logic        resetN,
        // input  logic        Enter,
        // input  logic        Undo,
        // input  logic        DisplayFormat,
        // input  logic [15:0] DataIn,
        // output logic [ 6:0] Segments,   // solo segmentos, no considere el punto
        // output logic [ 7:0] Anodes,
        // output logic [ 3:0] Flags,
        // output logic [ 2:0] Status

        //inputs
        .clk            (CLK100MHZ),
        .resetN         (CPU_RESETN),
        .Enter          (BTNL),
        .Undo           (BTNR),
        .DisplayFormat  (BTND),
        .DataIn         (DataIn),

        //outputs
        .Segments       (Segments),
        .Anodes         (Anodes),
        .Flags          (Flags),
    );

endmodule