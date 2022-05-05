`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// University: Universidad Tecnica Federico Santa Maria
// Course: ELO212
// Students: Cristobal Caqueo, Bastian Rivas, Claudio Zanetta
// 
// Create Date: 04/05/2022
// Design Name: Guia 4
// Module Name: S4_actividad3
// Project Name: n_bit_ALU
// Target Devices: xc7a100tcsg324-1
// Tool Versions: Vivado 2021.1
// Description: Unidad ALU que suma, resta, aplica OR y AND
// 
// Dependencies: Lab Digitales
// 
// Revision: 0.01
// Revision 0.01 - File Created
// Additional Comments: Por defecto trabaja con 8 bits
// 
//////////////////////////////////////////////////////////////////////////////////


module S4_actividad3 #(parameter M = 8)(
    input  logic [M-1:0]    A, B,
    input  logic [1:0]      OpCode,       
    output logic [M-1:0]    Result,
    output logic [3:0]      Status
    //output logic[M:0] resultado //pa verla en la sim
    );
    
 	logic[M:0] resultado; 

	always_comb begin
	Result=0;  //valores iniciales para evitar latches
	Status=0;  //no latches?
		if ( OpCode == 2'b00 ) begin							//OpCode = 00, se suma.
			resultado = A + B;
			Result = resultado [M-1:0];						//Se crea una se�al resultado, con un bit extra, para identificar cuando hay overflow
			if ( Result == 0 ) begin
				Status[2] = 1;
			end else begin
				Status[2] = 0;
			end if ( Result[M-1] == 1 ) begin					//Si se est� trabajando con complemento de 2, el bit m�s significativo es el bit del signo, y si este es 1, el n�mero es negativo. Corresponde al usuario interpretar este resultado
				Status[3] = 1;
			end else begin
				Status[3] = 0;
			end if ( resultado[M] == 1 ) begin					//Si el bit m�s significativo de resultado es 1, quiere decir que hubo overflow.
				Status[1] = 1;
			end else begin
				Status[0] = 0;
			end if ( A[M-1] == 0 && B[M-1] == 0 && Result[M-1] == 1 ) begin		//Si se a un n�mero positivo (negativo) se le suma un n�mero positivo (negativo), y el resultado es negativo (positivo), el resultado excedi� la capacidad de representaci�n.
				Status[0] = 1;
			end else if ( A[M-1] == 1 && B[M-1] == 1 && Result[M-1] == 0 ) begin
				Status[0] = 1;
			end else begin
				Status[0] = 0;
			end
		end
		if ( OpCode == 2'b01 ) begin								//Si OpCode es 01, se resta A y B.
			resultado = A - B;
			Result = resultado[M-1:0];
			if ( Result == 0 ) begin
				Status[2] = 1;
			end else begin
				Status[2] = 0;
		    end
			if ( Result[M-1] == 1) begin
				Status[3] = 1;
			end else begin
				Status[3] = 0;
			end if (resultado[M] == 1) begin
				Status[1] = 1;
			end else begin
				Status[1] = 0;
			end if ( A[M-1] == 1 && B[M-1] == 0 && Result[M-1] == 0 ) begin		//Si a un n�mero positivo (negativo) se le resta un n�mero negativo (positivo), y el resultado es negativo (positivo), el resultado excedi� la capacidad de representaci�n.
				Status[0] = 1;
			end else if ( A[M-1] == 0 && B[M-1] == 1 && Result[M-1] == 1 ) begin
				Status[0] = 1;
			end else begin
				Status[0] = 0;
			end
		end
		if ( OpCode == 2'b10 ) begin								//Si OpCode es 10, se hace el OR entre A y B.
			Result = A | B;	
			Status[0] = 0;									//C y V permanecen apagados.
			Status[1] = 0;
			if ( Result == 'd0 ) begin
				Status[2] = 1;
			end else begin
				Status[2] = 0;
			end if ( Result[M-1] == 1 ) begin
				Status[3] = 1;
			end else begin
				Status[3] = 0;
		    end
		end
		if ( OpCode == 2'b11 ) begin								//Si OpCode es 11, se hace el AND entre A y B.
			Result = A & B;								
			Status[0] = 0;									//C y V permanecen apagados
			Status[1] = 0;
			if ( Result == 'd0 ) begin
				Status[2] = 1;
			end else begin
				Status[2] = 0;
			end if ( Result[M-1] == 1 ) begin
				Status[3] = 1;
			end else begin
				Status[3] = 0;
			end
		end
	end   
    
endmodule