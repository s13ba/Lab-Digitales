`timescale 1ns / 1ps
module ALU_reg #(parameter N = 16) (
	input logic [N-1:0]data_in,
	input logic clk, reset, load_A, load_B, load_Op, updateRes,
	output logic [6:0] Segments,
	output logic [7:0] Anodes,
	output logic [3:0] LEDs

	);

    logic [1:0] data_Op;
	assign data_Op = data_in [1:0];
	logic [N-1 : 0] A;
	logic [N-1 : 0] B;
	logic [1:0] Op;

	registro_1_bit #(.N(N)) registro_A (
		.D(data_in),
		.clk(clk),
		.reset(reset),
		.load(load_A),
		.Q(A)
	);

	registro_1_bit #(.N(N)) registro_B (
		.D(data_in),
		.clk(clk),
		.reset(reset),
		.load(load_B),
		.Q(B)
	);

	registro_1_bit #(.N(2)) registro_Op (
		.D(data_Op),
		.clk(clk),
		.reset(reset),
		.load(load_Op),
		.Q(Op)
	);

	logic [N-1:0] Result;
	logic [3:0]   Flags;
	logic [N-1:0] SevenSegIn;

	ALU #(.M(N),.S(2)) ALU (
		.A(A),
		.B(B),
		.OpCode(Op),
		.Result(Result),
		.Status(Flags)
	);

	registro_1_bit #(.N(N)) registro_Result (
		.D(Result),
		.clk(clk),
		.reset(reset),
		.load(updateRes),
		.Q(SevenSegIn)
	);


	registro_1_bit #(.N(4)) registro_Flags(
		.D(Flags),
		.clk(clk),
		.reset(reset),
		.load(updateRes),
		.Q(LEDs)
	);


	driver_7_seg driver_7_seg(
		.clk(clk),
		.reset(reset),
		.BCD_in(SevenSegIn),
		.segments(Segments),
		.anodos(Anodes)

	);
	
endmodule

`timescale 1ns / 1ps
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


`timescale 1ns / 1ps
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

`timescale 1ns / 1ps
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

`timescale 1ns / 1ps
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
    input  logic        clk,
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
         .clk(clk),
         .reset(reset),
         .count(sel)
         ); 
        
    deco_binario_3_cold#(.N(count_max)) decoder(        //decodificador que maneja los anodos
        .sel(sel),
        .out(anodos)
        );

    // Limitar numero de displays a encenderse

    // logic [7:0] controlAnodos;
    // logic [3:0] LSBdeco_out;
    // assign LSBdeco_out = anodos[3:0];
    // assign controlAnodos = {4'b1111, LSBdeco_out};
    
    // always_comb begin
    //     case (N)
    //         16: anodos = controlAnodos;
    //         32: anodos = anodos;
        
    //     default: anodos = anodos;
    //     endcase
    // end
    
endmodule


`timescale 1ns / 1ps
module registro_1_bit #(parameter N=1)(
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