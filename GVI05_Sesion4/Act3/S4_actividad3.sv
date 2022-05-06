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
// Description: Unidad ALU que suma, resta, aplica OR y AND. Por defecto usa 8 bits
// 
// Dependencies: Lab Digitales
// 
// Revision: 0.03
// Revision 0.01 - File Created
// Additional Comments: Cambiado Status[0] por Status[1] en la primera verificación de overflow
// 
//////////////////////////////////////////////////////////////////////////////////


module S4_actividad3 #(parameter M = 8)(
    input  logic [M-1:0]    A, B,
    input  logic [1:0]      OpCode,       
    output logic [M-1:0]    Result,
    output logic [3:0]      Status // = {N, Z, C, V}
    );
    
 	logic[M:0] resultado; 

	always_comb begin
	Result=0;  //valores iniciales para evitar latches
	Status=0;  //Como todo es cero (incluyendo el flag Z), la salida de TODOS ceros se puede interpretar como un error
	
		if ( OpCode == 2'b00 ) begin						//OpCode = 00, se suma.
			resultado = A + B;
			Result = resultado [M-1:0];						//Se crea una señal resultado, con un bit extra, para identificar cuando hay overflow
			
			//Flag Manager:
			if ( Result == 0 ) begin  //Cero (Z)
				Status[2] = 1;
			end 
			else begin
				Status[2] = 0;
			end 
			
			if ( Result[M-1] == 1 ) begin					//Si se está trabajando con complemento de 2, el bit más significativo es el bit del signo, y si este es 1, el número es negativo. Corresponde al usuario interpretar este resultado
				Status[3] = 1;  //Negativo (N)
			end else begin
				Status[3] = 0;
			end 
			
			if ( resultado[M] == 1 ) begin					//Si el bit más significativo de resultado es 1, quiere decir que hubo carry/borrow.
				Status[1] = 1; //Carry/Borrow (C)
			end 
			else begin
				Status[1] = 0;
			end 
			
			if ( A[M-1] == 0 && B[M-1] == 0 && Result[M-1] == 1 ) begin		//Si se a un número positivo (negativo) se le suma un número positivo (negativo), y el resultado es negativo (positivo), el resultado excedió la capacidad de representación.
				Status[0] = 1; //Overflow (V)
			end else if ( A[M-1] == 1 && B[M-1] == 1 && Result[M-1] == 0 ) begin
				Status[0] = 1;
			end else begin
				Status[0] = 0;
			end
			//end Flag Manager
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
			end 
			else begin
				Status[3] = 0;
			end 
			
          if (resultado[M] == 1) begin
                    Status[1] = 1;
                end else begin
                    Status[1] = 0;
                end
                
          if ( A[M-1] == 1 && B[M-1] == 0 && Result[M-1] == 0 ) begin		//Si a un número positivo (negativo) se le resta un número negativo (positivo), y el resultado es negativo (positivo), el resultado excedió la capacidad de representación.
                    Status[0] = 1;
                end 
                else if ( A[M-1] == 0 && B[M-1] == 1 && Result[M-1] == 1 ) begin
                    Status[0] = 1;
                end 
                else begin
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
			end 
			
			if ( Result[M-1] == 1 ) begin
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
			end 
			
			if ( Result[M-1] == 1 ) begin
				Status[3] = 1;
			end else begin
				Status[3] = 0;
			end
		end
	end   
    
endmodule
