`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// University: Universidad Tecnica Federico Santa Maria
// Course: ELO212
// Students: Cristobal Caqueo, Bastian Rivas, Claudio Zanetta
// 
// Create Date: 3/06/2022
// Design Name: RPN_calc
// Module Name: RPN_calc_test
// Project Name: guia7
// Target Devices: xc7a100tcsg324-1
// Tool Versions: Vivado 2021.1
// Description: Testbench para la calculadora RPN de la primera pregunta de la guia 7
// 
// Dependencies: Lab Digitales
// 
// Revision: 0.11
// Revision 0.01
//
// Additional Comments: 
// 
//////////////////////////////////////////////////////////////////////////////////

module S7_act3_testbench();
	logic clk, resetN, Enter, Undo, DisplayFormat;
	logic [15:0] DataIn;
	logic [6:0] Segments;
	logic [7:0] Anodes;
	logic [3:0] Flags;
	logic [2:0] Status;					//Se declaran las señales de entrada al módulo

	S7_actividad3 #(
    .N_DEBOUNCER      (10)
) DUT (
    .clk              (clk),
    .resetN           (resetN),
    .Enter            (Enter),
    .Undo             (Undo),
    .DisplayFormat    (DisplayFormat),
    .DataIn           (DataIn),
    .Segments         (Segments),
    .Anodes           (Anodes),
    .Flags            (Flags),
    .Status           (Status)
);

	//Se busca comprobar el funcionamiento de la última sección del módulo, puesto que todo el resto se comprobó que funcionaba.
	//


	always #2 clk = ~clk;				//Se genera la señal de clock

	initial begin					
		
		clk = 0;				
		resetN = 0;				//Se inicia con un reset para inicializar los flip flops
		Enter = 0;	
		Undo = 0;
		DisplayFormat = 0;			//se muestra el número en hexadecimal
		DataIn = 0;
		
	#10

		resetN = 1;				//Se "apaga" el reset

	#5

		DataIn = 16'hFFFF;			//Se debe ver 0000FFFF en los displays

	#15

		DisplayFormat = 1;			//Se debe ver 00065535 en los displays

	#300						//Hay que darle tiempo al módulo para que haga la conversión

		Enter = 1;				//Se guarda DataIn en el registro A
		DisplayFormat = 0;			//Se debe ver 0000FFFF en los displays

	#48						//Enter debe estar en alto lo suficiente para que alcance a ser detectado por el debouncer
	
		Enter = 0;
		DataIn = 16'h005A;			//Se debe ver 0000005A en los displays

	#15

		DisplayFormat = 1;			//Se debe ver 00000090 en los displays

	#300

		Enter = 1;				//Se guarda DataIn en el registro b
		DisplayFormat = 0;			//Se debe ver 000005A en los displays

	#48

		Enter = 0;
		DataIn = 16'h0001;			//Se debe ver 00000001 en los displays
							//Operación: Resta
	#15

		DisplayFormat = 1;			//Se debe ver 00000001 en los displays

	#300

		Enter = 1;				//Se guarda DataIn en el registro OpCode
		DisplayFormat = 0;			//Se debe ver 00000001 en los displays

	#48

		Enter = 0;				//Se debe ver el resultado (FFA5) en los displays
	
	#15

		DisplayFormat = 1;			//Se debe ver 65445 en los displays

	#300
		
		Undo = 1;				//De vuelta al estado Entering OpCode
		DisplayFormat = 0;			//Se debe ver 00000001 en los displays (DataIn)

        // Carga de datos en A:

        DataIn  = 16'hFFFF;
        Enter   = 1;
        #50 Enter = 0;
        #15

        // Carga de datos en B:

        DataIn  = 16'h0101;
        Enter   = 1;
        #48 Enter = 0;
        #15

        // Carga de datos en Op y mostrar resultados:

        DataIn  = 16'h0001;
        Enter   = 1;
        #48 Enter = 0;
        #15

        //Volver al estado inicial:
        Enter   = 1;
        #50 Enter = 0;
        #15

	

	end
endmodule














