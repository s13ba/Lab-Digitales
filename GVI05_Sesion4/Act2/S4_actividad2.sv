`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// University: Universidad Tecnica Federico Santa Maria
// Course: ELO212
// Students: 
// 
// Create Date: 04/05/2022
// Design Name: Guia 4
// Module Name: S4_actividad2
// Project Name: Contador_N_bits
// Target Devices: xc7a100tcsg324-1
// Tool Versions: Vivado 2021.1
// Description: Contador incremental/decremental binario de ancho parametrizable. Cuenta con una entrada 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module S4_actividad2 #(parameter N=32)(
	input logic clock, reset, dec, enable, load,
	input logic [N-1:0] load_value,
	output logic [N-1:0]counterN

	);
	always_ff@(posedge clock) begin					//flip flop que se activa con cantos de subida de clk
		if (reset) begin					//el reset tiene prioridad por sobre todas las otras señales
			counterN=0;
		end
		else if (load) begin					//si load está en alto, independiente de si enable también lo está, counterN=load_value
			counterN = load_value;
		end				
		else if (enable*~load) begin			//solo si load está en bajo a la vez que enable está en alto, se procede con las otras opciones
			if (dec) begin					//si dec está en alto, el contador opera de manera decremental
				counterN = counterN - 1;
			end
			else begin					//si dec está en bajo, opera de manera incremental
				counterN = counterN + 1;
			end
		end
		else if (dec*~load*~enable) begin //si solamente dec está en alto, el contador se mantiene con su valor anterior
			counterN = counterN;
		end
		else begin						//si no hay ninguna señal en alto, el contador se queda igual
			counterN = counterN;
		end
	end
endmodule
	
