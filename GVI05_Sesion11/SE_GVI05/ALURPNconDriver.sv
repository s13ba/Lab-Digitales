`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// University: Universidad Tecnica Federico Santa Maria
// Course: ELO212
// Students: 
// 
// Create Date: 
// Design Name: Guia 7
// Module Name: ALURPNconDriver
// Project Name: 
// Target Devices: xc7a100tcsg324-1
// Tool Versions: Vivado 2021.1
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ALURPNconDriver #(parameter N_DEBOUNCER = 5000000)(
    input  logic        clk,
    input  logic        resetN,         // Ojo! Reset negado
    input  logic        Enter,
    input  logic        Undo,
    input  logic        DisplayFormat,  // "1" para mostrar en decimal sin signo
    input  logic [15:0] DataIn,
    output logic [ 6:0] Segments,       // solo segmentos, no considere el punto
    output logic [ 7:0] Anodes,
    output logic [ 3:0] Flags,
    output logic [ 2:0] Status,
    output logic [15:0] resultado
    );
    
    // Calculadora con Undo de la actividad anterior
    // Ojo! Usa el resetN
    logic [15:0] ToDisplay;

    S7_actividad2 #(
    .N_DEBOUNCER    (N_DEBOUNCER)
    ) u_S7_actividad2 (
    .clk            (clk),
    .resetN         (resetN),
    .Enter          (Enter),
    .Undo           (Undo),
    .DataIn         (DataIn),
    .ToDisplay      (ToDisplay),
    .Flags          (Flags),
    .Status         (Status),
    .resultado      (resultado)
    );

    logic  reset;
    assign reset=~resetN;
    // Controlador del display

    Interfaz_Display #(
    .N                   (16),
    .width_sel           (3),
    .Max_bits            (32)
    ) u_Interfaz_Display (
    .clk                 (clk),
    .reset               (reset),
    .ToDisplay           (ToDisplay),
    .DisplayFormat       (DisplayFormat),
    .Segments            (Segments),
    .Anodes              (Anodes)
);


    
endmodule

//////  Modulos internos //////

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// University: Universidad Tecnica Federico Santa Maria
// Course: ELO212
// Students: Cristobal Caqueo, Bastian Rivas, Claudio Zanetta
// 
// Create Date: 05/06/2022
// Design Name: Guia 7
// Module Name: S7_actividad2
// Project Name: guia7_p2
// Target Devices: xc7a100tcsg324-1
// Tool Versions: Vivado 2021.1
// Description: Calculadora con RPN. Ahora con Undo!
// 
// Dependencies: Lab Digitales
// 
// Revision: 0.01
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////

module S7_actividad2 #(parameter N_DEBOUNCER = 5000000)(
    input  logic        clk,
    input  logic        resetN,
    input  logic        Enter,
    input  logic        Undo,
    input  logic [15:0] DataIn,
    output logic [15:0] ToDisplay,  // valor de salida para el Display
    output logic [ 3:0] Flags,      // {N,Z,C,V}
    output logic [ 2:0] Status,      // Indica de manera secuencial el estado en el que se encuentra
    output logic [15:0] resultado      // Resultado de 16 bits en HEX
    );
    
    logic reset;

    assign reset = ~resetN; // resetN: reset negado


    // Debouncer: Recibe Enter y retorna un pulso unico en Enter_deb

    logic Enter_deb;

    PB_Debouncer_FSM #     (
    .DELAY                 (N_DEBOUNCER)
    ) Enter_Debouncer            (
        .clk                  (clk),
	    .rst                  (reset), 
	    .PB                   (Enter),
	    .PB_pressed_status    (),
	    .PB_pressed_pulse     (Enter_deb), // solo nos interesa el pulso
        .PB_released_pulse    ()
);

    // Debouncer: Lo mismo pero para Undo

    logic deb_undo;

    PB_Debouncer_FSM #     (
    .DELAY                 (N_DEBOUNCER)
    ) Undo_Debouncer            (
        .clk                  (clk),
	    .rst                  (reset), 
	    .PB                   (Undo),
	    .PB_pressed_status    (),
	    .PB_pressed_pulse     (deb_undo), // solo nos interesa el pulso
        .PB_released_pulse    ()
);

    // RPN: Recibe un pulso de Enter (Enter_deb) y un pulso de Undo (deb_undo) 
    //      Retorna estado, load A, B y OpCode, updateRes y ToDisplaySel
    logic LoadOpA, LoadOpB, LoadOpCode, updateRes, ToDisplaySel;

    ReversePolishFSM_Undo Reverse_Polish_FSM_Undo (
        .clk             (clk),
        .Reset           (reset),
        .Enter_pulse     (Enter_deb),
        .deb_undo        (deb_undo),
        .Status          (Status),
        .LoadOpA         (LoadOpA),
        .LoadOpB         (LoadOpB),
        .LoadOpCode      (LoadOpCode),
        .ToDisplaySel    (ToDisplaySel),
        .updateRes       (updateRes)
);

    // ALU: Recibe un numero de 16 bits, load A, B, OpCode y updateRes (ademas de clk y resetN)
    //      Retorna 4 bits de Flags y un resultado de 16 bits
    logic [15:0] Result;
    assign resultado = Result;
    ALU_reg_mod #   (
        .N          (16)
)   ALU             (
        .clk        (clk),
        .reset      (reset),
        .LoadOpA    (LoadOpA),
        .LoadOpB    (LoadOpB),
        .LoadOpCode (LoadOpCode),
        .updateRes  (updateRes),
        .DataIn     (DataIn),
        .Flags      (Flags),
        .Result     (Result)
);

    // Display Selector: Recibe 2 numeros de 16 bits y un selector ToDisplaySel
    //                   Retorna uno de los numeros de 16 bits
    mux_2_1_16b #(
    .N               (16)
    ) DisplaySelector (
    .A         (DataIn),
    .B         (Result),
    .sel       (ToDisplaySel),
    .out       (ToDisplay)
);


endmodule


`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// University: Universidad Tecnica Federico Santa Maria
// Course: ELO212
// Students: Cristobal Caqueo, Bastian Rivas, Claudio Zanetta
// 
// Create Date: 3/06/2022
// Design Name: ALU con registros
// Module Name: ALU_reg_mod
// Project Name: guia7
// Target Devices: xc7a100tcsg324-1
// Tool Versions: Vivado 2021.1
// Description: Unidad ALU con registros. 
// Basada en ALU_reg pero sin driver Hex to 7seg
// 
// Dependencies: Lab Digitales
// 
// Revision: 0.11
// Revision 0.11 - Adaptados los nombres de los cables para coincidir con los del 
// 				   modulo de la guia 7. Removido Hex to 7 seg
// Additional Comments: 
// 
//////////////////////////////////////////////////////////////////////////////////

/*  Snippet para instanciar
ALU_reg_mod uALU_reg_mod # (
  .N                       (16)
)                          (
  .clk                     (clk),
  .reset                  (reset),
  .LoadOpA                 (LoadOpA),
  .LoadOpB                 (LoadOpB),
  .LoadOpCode              (LoadOpCode),
  .updateRes               (updateRes),
  .DataIn                  (DataIn),
  .Flags                   (Flags),
  .Result                  (Result)
); 
*/

// Modulo principal: ALU con registros
module ALU_reg_mod #(parameter N = 16) (
	input logic clk, reset, LoadOpA, LoadOpB, LoadOpCode, updateRes,
	input logic	 [N-1:0]	DataIn,
	output logic [3:0] 		Flags,
	output logic [N-1:0]	Result

	);

    logic [1:0] 	data_Op;
	assign data_Op = DataIn [1:0];
	logic [N-1 : 0] A;
	logic [N-1 : 0] B;
	logic [1:0]		Op;

	registro_n_bit # (.N(N)) registro_A (
		.D              (DataIn),
		.clk            (clk),
		.reset          (reset),
		.load           (LoadOpA),
		.Q              (A)
	);

	registro_n_bit # (.N(N)) registro_B (
		.D              (DataIn),
		.clk            (clk),
		.reset          (reset),
		.load           (LoadOpB),
		.Q              (B)
	);

	registro_n_bit # (.N(2)) registro_Op (
		.D              (data_Op),
		.clk            (clk),
		.reset          (reset),
		.load           (LoadOpCode),
		.Q              (Op)
	);

	logic [N-1:0] ALU_Result;
	logic [3:0]   ALU_Flags;

	ALU #            (.M(N),.S(2)) ALU (
		.A              (A),
		.B              (B),
		.OpCode         (Op),
		.Result         (ALU_Result),
		.Status         (ALU_Flags)
	);

	registro_n_bit # (.N(N)) registro_Result (
		.D              (ALU_Result),
		.clk            (clk),
		.reset          (reset),
		.load           (updateRes),
		.Q              (Result)
	);


	registro_n_bit # (.N(4)) registro_Flags(
		.D              (ALU_Flags),
		.clk            (clk),
		.reset          (reset),
		.load           (updateRes),
		.Q              (Flags)
	);
	
endmodule




//////////////////////////////////////////////////////////////////////////////////
// University: Universidad Tecnica Federico Santa Maria
// Course: ELO212
// Students: Cristobal Caqueo, Bastian Rivas, Claudio Zanetta
// 
// Create Date: 04/05/2022
// Design Name: Guia 4
// Module Name: ALU
// Project Name: n_bit_ALU
// Target Devices: xc7a100tcsg324-1
// Tool Versions: Vivado 2021.1
// Description: Unidad ALU que suma, resta, aplica OR y AND. Por defecto usa 8 bits
// 
// Dependencies: Lab Digitales
// 
// Revision: 0.03
// Revision 0.01 - File Created
// Additional Comments: Cambiado Status[0] por Status[1] en la primera verificaci�n de overflow
// 
//////////////////////////////////////////////////////////////////////////////////


module ALU #(parameter M = 8, S = 2)(
    input  logic [M-1:0]    A, B,
    input  logic [1:0]      OpCode,       
    output logic [M-1:0]    Result,
    output logic [3:0]      Status // = {N, Z, C, V}
    );
    
 	logic[M:0] resultado; 

	always_comb begin
	//Result=0;  //valores iniciales para evitar latches
	//Status=0;  //Como todo es cero (incluyendo el flag Z), la salida de TODOS ceros se puede interpretar como un error
	
		if ( OpCode == 2'b00 ) begin						//OpCode = 00, se suma.
			resultado = A + B;
			Result = resultado [M-1:0];						//Se crea una se�al resultado, con un bit extra, para identificar cuando hay overflow
			
			//Flag Manager:
			if ( Result == 0 ) begin  //Cero (Z)
				Status[2] = 1;
			end 
			else begin
				Status[2] = 0;
			end 
			
			if ( Result[M-1] == 1 ) begin					//Si se est� trabajando con complemento de 2, el bit m�s significativo es el bit del signo, y si este es 1, el n�mero es negativo. Corresponde al usuario interpretar este resultado
				Status[3] = 1;  //Negativo (N)
			end else begin
				Status[3] = 0;
			end 
			
			if ( resultado[M] == 1 ) begin					//Si el bit m�s significativo de resultado es 1, quiere decir que hubo carry/borrow.
				Status[1] = 1; //Carry/Borrow (C)
			end 
			else begin
				Status[1] = 0;
			end 
			
			if ( A[M-1] == 0 && B[M-1] == 0 && Result[M-1] == 1 ) begin		//Si se a un n�mero positivo (negativo) se le suma un n�mero positivo (negativo), y el resultado es negativo (positivo), el resultado excedi� la capacidad de representaci�n.
				Status[0] = 1; //Overflow (V)
			end else if ( A[M-1] == 1 && B[M-1] == 1 && Result[M-1] == 0 ) begin
				Status[0] = 1;
			end else begin
				Status[0] = 0;
			end
			//end Flag Manager
		end


		else if ( OpCode == 2'b01 ) begin								//Si OpCode es 01, se resta A y B.
			resultado = A - B;
			Result = resultado[M-1:0];
			
			if ( Result == 0 ) begin
				Status[2] = 1;
			end else begin
				Status[2] = 0;
		    end
		    
			if ( Result[M-1] == 1) begin
				Status[3] = 1;
			end 
			else begin
				Status[3] = 0;
			end 
			
          if (resultado[M] == 1) begin
                    Status[1] = 1;
                end else begin
                    Status[1] = 0;
                end
                
          if ( A[M-1] == 1 && B[M-1] == 0 && Result[M-1] == 0 ) begin		//Si a un n�mero positivo (negativo) se le resta un n�mero negativo (positivo), y el resultado es negativo (positivo), el resultado excedi� la capacidad de representaci�n.
                    Status[0] = 1;
                end 
                else if ( A[M-1] == 0 && B[M-1] == 1 && Result[M-1] == 1 ) begin
                    Status[0] = 1;
                end 
                else begin
                    Status[0] = 0;
                end
                
            end
    

		else if ( OpCode == 2'b10 ) begin								//Si OpCode es 10, se hace el OR entre A y B.
			Result = A | B;	
			Status[0] = 0;									//C y V permanecen apagados.
			Status[1] = 0;
			
			if ( Result == 'd0 ) begin
				Status[2] = 1;
			end else begin
				Status[2] = 0;
			end 
			
			if ( Result[M-1] == 1 ) begin
				Status[3] = 1;
			end else begin
				Status[3] = 0;
		    end
		end


		else if ( OpCode == 2'b11 ) begin								//Si OpCode es 11, se hace el AND entre A y B.
			Result = A & B;								
			Status[0] = 0;									//C y V permanecen apagados
			Status[1] = 0;
			
			if ( Result == 'd0 ) begin
				Status[2] = 1;
			end else begin
				Status[2] = 0;
			end 
			
			if ( Result[M-1] == 1 ) begin
				Status[3] = 1;
			end else begin
				Status[3] = 0;
			end
		end
		else begin
		  	   Result=0;  //valores iniciales para evitar latches
	           Status=0;
		end
	end   
    
endmodule




module registro_n_bit #(parameter N=1)(
	input logic [N-1:0] D, 
	input logic clk, reset, load,
	output logic [N-1:0] Q

	);

	always_ff @(posedge clk) begin
		if (reset) begin
			Q = 1'b0;
		end else if (load) begin
			Q = D;
		end else begin
			Q = Q;
		end
	end
endmodule




//// Interfaz Display ////
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.06.2022 18:25:37
// Design Name: 
// Module Name: Interfaz_Display
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Interfaz_Display#(parameter N = 16, width_sel = 3, Max_bits = 32)(
    input logic clk,
    input logic reset,
    input logic [N-1:0]ToDisplay,
    input logic DisplayFormat,
    output logic [6:0] Segments,
    output logic [7:0] Anodes
    );
    
    logic [Max_bits-1:0]hex_num;
    logic [Max_bits-1:0]To_BCD;
    
     if (N == 32) 
        assign hex_num = ToDisplay;
    else 
        assign hex_num = {16'd0,ToDisplay};
    
    driver_7_seg #(.N(Max_bits),.count_max(width_sel))driver_7_seg(
        .clock(clk),
        .reset(reset),
        .BCD_in(To_BCD),
        .segments(Segments),
        .anodos(Anodes)
    );
    
    logic [Max_bits-1:0]dec_num;
    
	unsigned_to_bcd u32_to_bcd_inst (
		.clk(clk),
		.reset(reset),
		.trigger(1'b1),
		.in(hex_num),
		.idle(idle),
		.bcd(dec_num)
	);
	
    mux_2_1_16b #(.N(Max_bits))
    Format_ctrl(
        .A(hex_num),
        .B(dec_num),
        .out(To_BCD),
        .sel(DisplayFormat)
    );
endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// University: Universidad Tecnica Federico Santa Maria
// Course: ELO212
// Students: Cristobal Caqueo, Bastian Rivas, Claudio Zanetta
// 
// Create Date: 03/05/2022
// Design Name: guia5_alu
// Module Name: Hex_to_7seg_driver
// Project Name: guia5_alu
// Target Devices: xc7a100tcsg324-1
// Tool Versions: Vivado 2021.1
// Description: Display de numeros hexadecimales en 8 displays de 7 segmentos
// 
// Dependencies: Lab Digitales
// 
// Revision: 1.11 - Parametrizado el contador del driver 7 seg
// Additional Comments: Puede recibir un numero de hasta 32 bits y rellena los no
//                      utilizados con ceros
// 
//////////////////////////////////////////////////////////////////////////////////

//Maximo: 32 bits

module driver_7_seg#(parameter N = 16, count_max = 2)(
    input  logic        clock,
    input  logic        reset,
    input  logic [N-1:0]BCD_in,     // informacion a mostrar
    output logic [6:0]  segments,   // {CA, CB, CC, CD, CE, CF, CG}
    output logic [7:0]  anodos      // {AN7, AN6, AN5, AN4, AN3, AN2, AN1, AN0}
    );
    // nro anodos=nroBCD/4
    
    // Concatenacion de numeros para rellenar por si es menor a 32 bits (8 segmentos)
    logic [31:0] data; //numero a tratar

    if (N == 32) 
        assign data = BCD_in;    
    else 
        assign data = {'d0,BCD_in};
    
    logic clock_div ;
    
    
    //***Primera parte: Separar digitos del numero, convertir 1 digito a 7seg por la vez***
    
    //Digitos (hex) del numero ingresado:
    logic [3:0]sevenSeg_in; //Cable que conecta Mux con conversor BCD->7Seg
    logic [count_max-1:0]sel; //sel coordina al decodificador y al mux que maneja los digitos
    logic [3:0] BCD_1, BCD_2, BCD_3, BCD_4,
                BCD_5, BCD_6, BCD_7, BCD_8;
    //logic [7:0] anodos;

//Separacion por digito. BCD_n es el digito n
    assign BCD_1 = data[3:0]; 
    assign BCD_2 = data[7:4];
    assign BCD_3 = data[11:8];
    assign BCD_4 = data[15:12];

    assign BCD_5 = data[19:16];
    assign BCD_6 = data[23:20];
    assign BCD_7 = data[27:24];
    assign BCD_8 = data[31:28];    


    
    mux_8_1#(.N(count_max)) mux_8_1(                    //mux para separar digitos
         .A(BCD_1),
         .B(BCD_2),
         .C(BCD_3),
         .D(BCD_4),
         
         .E(BCD_5),
         .F(BCD_6),
         .G(BCD_7),
         .H(BCD_8),
         
         .sel(sel),
         .out(sevenSeg_in)
         );  
    
    BCD_to_sevenSeg BCD_to_sevenSeg(    //conversor por digitos
        .BCD_in(sevenSeg_in),
        .sevenSeg(segments)
        );
        
        
    //***Segunda parte: mostrar un numero unico y escoger su display***
    
    nbit_counter#(.N(count_max)) counter_n_bit( //contador que coordina al mux y al decodificador 
         .clk(clock_div),
         .reset(reset),
         .count(sel)
         ); 
        
    deco_binario_3_cold#(.N(count_max)) decoder(        //decodificador que maneja los anodos
        .sel(sel),
        .out(anodos)
        );
        
    clock_divider clock_divider(
    .clk_in(clock),
    .reset(reset),
    .clk_out(clock_div)
    );
    
endmodule

// === Modulos auxiliares === //

//////////////////////////////////////////////////////////////////////////////////
// University: Universidad Tecnica Federico Santa Maria
// Course: ELO212
// Students: Cristobal Caqueo, Bastian Rivas, Claudio Zanetta
// 
// Create Date: 03/05/2022
// Design Name: Guia 4
// Module Name: mux_8_1
// Project Name: mux_multiples_displays
// Target Devices: xc7a100tcsg324-1
// Tool Versions: Vivado 2021.1
// Description: Multiplexor de 8 entradas de 4 bits 
// 
// Dependencies: Lab Digitales
// 
// Revision: 1.02 parametrizao de pana
// Revision 0.01 - File Created
// Additional Comments: Usado para separar digitos hexadecimales de una palabra de 32 bits
// 
//////////////////////////////////////////////////////////////////////////////////
module mux_8_1#(parameter N = 3)(	//8 entradas, 1 salida
    input logic [3:0] A, B, C, D, E, F, G, H, //N entradas de 4b
    input logic [N-1:0] sel, //selector de N-1b
    output logic [3:0]out //salida 4b
    
 );
 
    always_comb begin
        case (sel)
            'd0: out = A;
            'd1: out = B;
            'd2: out = C;
            'd3: out = D;
            'd4: out = E;
            'd5: out = F;
            'd6: out = G;
            'd7: out = H;
        endcase
    end
endmodule




//////////////////////////////////////////////////////////////////////////////////
// University: Universidad Tecnica Federico Santa Maria
// Course: ELO212
// Students: Cristobal Caqueo, Bastian Rivas, Claudio Zanetta
// 
// Create Date: 03/05/2022
// Design Name: Guia 4
// Module Name: BCD_to_sevenSeg
// Project Name: mux_multiples_displays
// Target Devices: xc7a100tcsg324-1
// Tool Versions: Vivado 2021.1
// Description: Conversor de nibbles a numeros legibles en displays de 7 segmentos
// 
// Dependencies: Lab Digitales
// 
// Revision: 0.01
// Revision 0.01 - File Created
// Additional Comments: Módulo conversor BCD a 7seg de la pregunta 3.3 en la guía 2. 
//                      Modificado con 0 como ON para coincidir con la Nexys A7
// 
//////////////////////////////////////////////////////////////////////////////////
module BCD_to_sevenSeg(
    input logic [3:0] BCD_in, //números del 0 al F, 4bits. 
    output logic [6:0] sevenSeg //salida abcdefg según el datasheet de la plaquita, 7bits
    );
    
    always_comb begin
    
        //0:ON, 1:OFF
        case (BCD_in)
            4'd0: sevenSeg = 7'b0000001;
            4'd1: sevenSeg = 7'b1001111;
            4'd2: sevenSeg = 7'b0010010;
            4'd3: sevenSeg = 7'b0000110;
            4'd4: sevenSeg = 7'b1001100;
            4'd5: sevenSeg = 7'b0100100;
            4'd6: sevenSeg = 7'b0100000;
            4'd7: sevenSeg = 7'b0001111;
            4'd8: sevenSeg = 7'b0000000;
            4'd9: sevenSeg = 7'b0000100;
            4'd10:sevenSeg = 7'b0001000; //A
            4'd11:sevenSeg = 7'b1100000; //b
            4'd12:sevenSeg = 7'b0110001; //C
            4'd13:sevenSeg = 7'b1000010; //d
            4'd14:sevenSeg = 7'b0110000; //E
            4'd15:sevenSeg = 7'b0111000; //F
            default: sevenSeg = 7'b1111111; //por defecto apagaría todos 
        endcase
    end
endmodule


//Contador de N bits (por defecto 4)
//Pregunta 3.7 guía 2

module nbit_counter #(parameter N=4)(
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




//////////////////////////////////////////////////////////////////////////////////
// University: Universidad Tecnica Federico Santa Maria
// Course: ELO212
// Students: Cristobal Caqueo, Bastian Rivas, Claudio Zanetta
// 
// Create Date: 03/05/2022
// Design Name: Guia 4
// Module Name: deco_binario_3_cold
// Project Name: mux_multiples_displays
// Target Devices: xc7a100tcsg324-1
// Tool Versions: Vivado 2021.1
// Description: Decodificador de 3 bits, funciona con configuracion One-Cold
// 
// Dependencies: Lab Digitales
// 
// Revision: 0.01
// Revision 0.01 - File Created
// Additional Comments: Adaptado para trabajar con los 8 displays de la actividad 4.1
// 
//////////////////////////////////////////////////////////////////////////////////

module deco_binario_3_cold#(parameter N = 3)(
    input  logic [N-1:0]sel,
    output logic [7:0]out
    );

    always_comb begin

        case (sel)
            'd0: out = 8'b11111110;
            'd1: out = 8'b11111101;
            'd2: out = 8'b11111011;
            'd3: out = 8'b11110111;
            'd4: out = 8'b11101111;
            'd5: out = 8'b11011111;
            'd6: out = 8'b10111111;
            'd7: out = 8'b01111111;
        endcase

    end
    
endmodule

`timescale 1ns / 1ps
//Pregunta 5.2


module clock_divider
#(parameter COUNTER_MAX = 100000) //nro de cantos de subida hasta invertir clk_out
( input logic clk_in,
  input logic reset,
  output logic clk_out );

  localparam DELAY_WIDTH = $clog2(COUNTER_MAX); //clog define el nro de bits necesarios pa representar el contador
  logic [DELAY_WIDTH-1:0] counter = 'd0; //le epic contador

  always_ff @(posedge clk_in) begin //se pasea por los cantos de reloj
    if (reset == 1'b1) begin //reiniciar si hay reset

        counter <= 'd0;
        clk_out <= 0;
    end else if (counter == COUNTER_MAX-1) begin

        counter <= 'd0;
        clk_out <= ~clk_out; //invierte en vez de subir y bajar cada cierta cantidad de cantos de subida
    end else begin

        counter <= counter + 'd1;
        clk_out <= clk_out;
    end
    end
endmodule


/*
 * unsigned_to_bcd.v
 * 2017/04/18 - Felipe Veas <felipe.veasv [at] usm.cl>
 * 2021/06/10 - Patricio Henriquez <patricio.henriqueze [at] sansano.usm.cl>
 *
 *
 * Este módulo es una implementación del algoritmo double dabble,
 * comienza a convertir un número en binario cuando recibe un pulso
 * en su entrada 'trigger'. La salida idle pasa a LOW si el módulo se
 * encuentra realizando una conversión.
 */

// -- Plantilla de instanciación
//	unsigned_to_bcd u32_to_bcd_inst (
//		.clk(clk),
//		.reset(reset)
//		.trigger(1'b1),
//		.in(in),
//		.idle(idle),
//		.bcd(bcd)
//	);

`timescale 1ns / 1ps

module unsigned_to_bcd
(
	input  logic 		clk, 	 // Reloj
				reset,   // Reset
	input  logic 		trigger, // Inicio de conversión
	input  logic [31:0] 	in,      // Número binario de entrada
	output logic  		idle,    // Si vale 0, indica una conversión en proceso
	output logic [31:0] 	bcd 	 // Resultado de la conversión
);

	/*
	 * Por "buenas prácticas" parametrizamos las constantes numéricas de los estados
	 * del módulo y evitamos trabajar con números "mágicos" en el resto del código.
	 *
	 * https://en.wikipedia.org/wiki/Magic_number_(programming)
	 * http://stackoverflow.com/questions/47882/what-is-a-magic-number-and-why-is-it-bad
	 */
	 
	 
	localparam COUNTER_MAX = 32;
	
	(* fsm_encoding = "one_hot" *) enum logic [2:0] {S_IDLE, S_SHIFT, S_ADD3} state, state_next;

	logic [31:0] shift, shift_next;
	logic [31:0] bcd_next;
	logic [5:0] counter, counter_next; /* Contador 6 bit para las iteraciones */

	always_comb begin
		/*
		 * Por defecto, los estados futuros mantienen el estado actual. Esto nos
		 * ayuda a no tener que ir definiendo cada uno de los valores de las señales
		 * en cada estado posible.
		 */
		
		{state_next, shift_next, bcd_next, counter_next} = {state, shift, bcd, counter};
		idle = 1'b0; /* LOW para todos los estados excepto S_IDLE */

		case (state)
		S_IDLE: begin
			counter_next = 'd1;
			shift_next = 'd0;
			idle = 1'b1;

			if (trigger) begin
				state_next = S_SHIFT;
			end
		end
		S_ADD3: begin
			/*
			 * Sumamos 3 a cada columna de 4 bits si el valor de esta es
			 * mayor o igual a 5
			 */
			if (shift[31:28] >= 5)
				shift_next[31:28] = shift[31:28] + 4'd3;

			if (shift[27:24] >= 5)
				shift_next[27:24] = shift[27:24] + 4'd3;

			if (shift[23:20] >= 5)
				shift_next[23:20] = shift[23:20] + 4'd3;

			if (shift[19:16] >= 5)
				shift_next[19:16] = shift[19:16] + 4'd3;

			if (shift[15:12] >= 5)
				shift_next[15:12] = shift[15:12] + 4'd3;

			if (shift[11:8] >= 5)
				shift_next[11:8] = shift[11:8] + 4'd3;

			if (shift[7:4] >= 5)
				shift_next[7:4] = shift[7:4] + 4'd3;

			if (shift[3:0] >= 5)
				shift_next[3:0] = shift[3:0] + 4'd3;

			state_next = S_SHIFT;
		end
		S_SHIFT: begin
			/* Desplazamos un bit de la entrada en el registro shift */
			shift_next = {shift[30:0], in[COUNTER_MAX - counter_next]};

			/*
			 * Si el contador actual alcanza la cuenta máxima, actualizamos la salida y
			 * terminamos el proceso.
			 */
			if (counter == COUNTER_MAX) begin
				bcd_next = shift_next;
				state_next = S_IDLE;
			end else
				state_next = S_ADD3;

			/* Incrementamos el contador (siguiente) en una unidad */
			counter_next = counter + 'd1;
		end
		default: begin
			state_next = S_IDLE;
		end
		endcase
	end

	always @(posedge clk) begin
		if(reset) begin
			{shift, bcd, counter} <= 'd0;
			state <= S_IDLE;
		end
		else
			{state, shift, bcd, counter} <= {state_next, shift_next, bcd_next, counter_next};
	end

endmodule


`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.06.2022 19:43:30
// Design Name: 
// Module Name: mux_2_1_16b
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module mux_2_1_16b #(parameter N = 16)(
    input  logic [N-1:0] A,
    input  logic [N-1:0] B,
    input  logic         sel,

    output logic [N-1:0] out  // valor de salida para el Display
    );

    always_comb begin
        if (sel)
            out = B;
        else
            out = A;
        
    end

endmodule






module PB_Debouncer_FSM #(
    parameter DELAY=15                 // Number of clock pulses to check stable button pressing
    )
(
	input 	logic clk,                 // base clock
	input 	logic rst,                 // global reset
	input 	logic PB,                  // raw asynchronous input from mechanical PB         
	output 	logic PB_pressed_status,   // clean and synchronized pulse for button pressed
	output  logic PB_pressed_pulse,    // high if button is pressed
	output  logic PB_released_pulse    // clean and synchronized pulse for button released
 );

	logic    PB_sync_aux, PB_sync;

// Double flopping stage for synchronizing asynchronous PB input signal
// PB_sync is the synchronized signal
 always_ff @(posedge clk) begin
     if (rst) begin
         PB_sync_aux <= 1'b0;
         PB_sync     <= 1'b0;
     end
     else begin
         PB_sync_aux <= PB;
         PB_sync     <= PB_sync_aux;
     end
 end
/////////////// FSM Description
	
	localparam DELAY_WIDTH = $clog2(DELAY);
	
	logic [DELAY_WIDTH-1:0]    delay_timer; 
    
    enum logic[5:0] {PB_IDLE, PB_COUNT, PB_PRESSED, PB_STABLE, PB_RELEASED} state, next_state;

 //Timer keeps track of how many cycles the FSM remains in a given state
 //Automatically resets the counter "delay_timer" when changing state
  always_ff @(posedge clk) begin
	if (rst) delay_timer <= 0;
	else if (state != next_state) delay_timer <= 0; //reset the timer when state changes
	else delay_timer <= delay_timer + 1;
  end


    // Combinational logic for FSM
    // Calcula hacia donde me debo mover en el siguiente ciclo de reloj basado en las entradas
    always_comb begin
        //default assignments
        next_state          = PB_IDLE;
        PB_pressed_status   = 1'b0;
        PB_pressed_pulse    = 1'b0;
        PB_released_pulse   = 1'b0;
                
        case (state)
            PB_IDLE:        begin
                                if(PB_sync) begin   // si se inicia una operacion, empieza lectura de datos
                                    next_state= PB_COUNT;
                                end
                            end

            PB_COUNT:       begin
                                // Verifica si el timer alcanzo el valor predeterminado para este estado
                                if ((PB_sync && (delay_timer >= DELAY-1))) begin
                                    next_state = PB_PRESSED;
                                end 
                                else if (PB_sync)
                                    next_state = PB_COUNT;
                            end
                         
             PB_PRESSED:    begin
                                PB_pressed_pulse = 1'b1;
                                if (PB_sync)
                                    next_state = PB_STABLE;
                            end
             
             PB_STABLE:     begin
                                PB_pressed_status=1'b1;
                                next_state = PB_STABLE;
                         
                                if (~PB_sync)
                                    next_state = PB_RELEASED;
                            end

              PB_RELEASED:  begin
                                PB_released_pulse = 1'b1;
                                next_state = PB_IDLE;
                            end    
         endcase
    end    

    // sequential block for FSM. When clock ticks, update the state
    always@(posedge clk) begin
        if(rst) 
            state <= PB_IDLE;
        else 
            state <= next_state;
    end
    
endmodule





`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.06.2022 21:57:28
// Design Name: 
// Module Name: ReversePolishFSM_Undo
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ReversePolishFSM_Undo(
    input logic clk, Reset, Enter_pulse, deb_undo,
    output logic [2:0]Status,
    output logic LoadOpA, LoadOpB, LoadOpCode, ToDisplaySel, updateRes
    );
    typedef enum logic [2:0] {S0, S1, S2, S3, S4, S5, S6} state;
    state pr_state, next_state;
    
    always_ff @(posedge clk) begin
        if(Reset)
            pr_state <= S0;
        else
            pr_state <= next_state;
    end
    
    always_comb begin
        next_state = pr_state;
        case(pr_state)
            S0: begin
                Status = 3'b000;
                LoadOpA = 1'b0;
                LoadOpB = 1'b0;
                LoadOpCode = 1'b0;
                ToDisplaySel = 1'b1;
                updateRes = 1'b0;
                if(Enter_pulse)
                    next_state = S1;
                else
                    next_state = S0;   
            end
            S1: begin
                Status = 3'b001;
                LoadOpA = 1'b1;
                LoadOpB = 1'b0;
                LoadOpCode = 1'b0;
                ToDisplaySel = 1'b0;
                updateRes = 1'b0; 
                next_state = S2;
            end
            S2: begin
                Status = 3'b010;
                LoadOpA = 1'b0;
                LoadOpB = 1'b0;
                LoadOpCode = 1'b0;
                ToDisplaySel = 1'b0;
                updateRes = 1'b0;
                if(Enter_pulse*~deb_undo)
                    next_state = S3;
                else if(deb_undo*~Enter_pulse)
                    next_state = S0;
                else if (deb_undo*Enter_pulse)
                    next_state = S0;
                else
                    next_state = S2;
            end
            S3: begin
                Status = 3'b011;
                LoadOpA = 1'b0;
                LoadOpB = 1'b1;
                LoadOpCode = 1'b0;
                ToDisplaySel = 1'b0;
                updateRes = 1'b0;
                next_state = S4;
            end
            S4: begin 
                Status = 3'b100;
                LoadOpA = 1'b0;
                LoadOpB = 1'b0;
                LoadOpCode = 1'b0;
                ToDisplaySel = 1'b0;
                updateRes = 1'b0;
                if(Enter_pulse*~deb_undo)
                    next_state = S5;
                else if(deb_undo*~Enter_pulse)
                    next_state = S2;
                else if (deb_undo*Enter_pulse)
                    next_state = S2;
                else
                    next_state = S4;
            end
             S5: begin
                 Status = 3'b101;
                 LoadOpA = 1'b0;
                 LoadOpB = 1'b0;
                 LoadOpCode = 1'b1;
                 ToDisplaySel = 1'b1;
                 updateRes = 1'b0;
                 next_state = S6;
             end
             S6: begin
                next_state = S0;
                Status = 3'b110;
                LoadOpA = 1'b0;
                LoadOpB = 1'b0;
                LoadOpCode = 1'b0;
                ToDisplaySel = 1'b1;
                updateRes = 1'b1;
                next_state = S0;
                // if(Enter_pulse*~deb_undo)
                //     next_state = S0;
                // else if(deb_undo*~Enter_pulse)
                //     next_state = S4;
                // else if (deb_undo*Enter_pulse)
                //     next_state = S4;
                // else
                //     next_state = S6;
                end
            default: begin
                     Status = 3'b000;
                     LoadOpA = 1'b0;
                     LoadOpB = 1'b0;
                     LoadOpCode = 1'b0;
                     ToDisplaySel = 1'b0;
                     updateRes = 1'b0;
                     next_state = S0;
            end
        endcase
    end
    
endmodule
