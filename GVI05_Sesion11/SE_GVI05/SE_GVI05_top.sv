`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/07/2018 07:05:14 PM
// Design Name: 
// Module Name: SE_GVI05_top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Modulo top que ve la tarjeta para el SE de la calculadora con UART
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module SE_GVI05_top
(
	input  logic               CLK100MHZ,
	input  logic               CPU_RESETN,

	input  logic               uart_rx, // JD 1

	output logic               uart_tx, // JD 3
	output logic               uart_tx_busy, // JD 4
	output logic               uart_tx_usb,
	output logic               rx_ready, // JD 2

	output logic    [15:0]     LED,
	
	output  logic   [6:0]      Segments,
    output  logic   [7:0]      AN
);



    assign uart_tx_usb = uart_tx;
    assign uart_tx_busy = tx_busy;
	logic GND;
	assign GND = 1'b0;

	/* Debouncer del reset negado */
	logic reset;
	assign reset = ~CPU_RESETN; // Algunos modulos usan reset, otros CPU_RESETN
							// Esto permite conectar segun el reset correcto




	/* M�dulo UART a 115200/8 bits datos/No paridad/1 bit stop */

	logic [7:0] rx_data;
	logic [7:0] tx_data;

	uart_basic #(
		.CLK_FREQUENCY(100000000), // reloj base de entrada
		.BAUD_RATE(115200)
	) uart_basic_inst (
		.clk          (CLK100MHZ),
		.reset        (reset),
		.rx           (uart_rx),
		.rx_data      (rx_data),
		.rx_ready     (rx_ready),
		.tx           (uart_tx), // medible
		.tx_start     (tx_start),
		.tx_data      (tx_data),
		.tx_busy      (tx_busy) //medible
	);


// Logica de control para recibir los bytes desde la UART

	logic			trigger, Enter_ALU;
	logic	[15:0]	Data_In;
	logic	[ 3:0]	RX_CTRL_status;

	UART_RX_CTRL #(	
		.INTER_BYTE_DELAY(1000000),   // ciclos de reloj de espera entre el envio de 2 bytes consecutivos
		.WAIT_FOR_REGISTER_DELAY(100) // tiempo de espera para iniciar la transmision luego de registrar el dato a enviar
	) UART_RX_CTRL_inst (
		.clk		(CLK100MHZ), 
		.reset		(reset), 
		.rx_ready	(rx_ready),
		.rx_data	(rx_data),
		.trigger	(trigger), 
		.Enter_ALU	(Enter_ALU),
		.Data_In	(Data_In),
		.LED		(RX_CTRL_status)
    );
    

// ALU en notacion polaca inversa. 
// Tambien maneja lo que se ve en el display
	logic 			VCC = 1'b1;
	logic	[ 3:0]	ALU_Flags;
	logic	[15:0]	resultado;

	ALURPNconDriver ALU
	(
		.clk(CLK100MHZ),
		.resetN(CPU_RESETN),         // Ojo! Reset negado
		
		.Enter(Enter_ALU),
		.Undo(GND),
		.DisplayFormat(VCC),  // "1" para mostrar en decimal sin signo
		.DataIn(Data_In),
		
		.Segments(Segments),       // solo segmentos, no considere el punto
		.Anodes(AN),
		.Flags(ALU_Flags),
		.Status(),
		.resultado(resultado)
    );
    


	// Logica de control para transmitir las secuencias por la UART

	UART_TX_CTRL
	#(	.INTER_BYTE_DELAY(1000000),   // ciclos de reloj de espera entre el envio de 2 bytes consecutivos
		.WAIT_FOR_REGISTER_DELAY(100) // tiempo de espera para iniciar la transmision luego de registrar el dato a enviar
	) UART_TX_CTRL_inst(
		.clock(CLK100MHZ),
		.reset(reset),
		.Trigger_TX_result(trigger), // Gatillo de transmision del resultado hacia el ME
		.resultado(resultado),       // Dato que se desea transmitir de 16 bits
		
		.tx_data(tx_data),        // Datos entregados al driver UART para transmision
		.tx_start(tx_start)       // Pulso para iniciar transmision por la UART
    );

// LEDs: 4 MS para los estados del RX_CTRL y 4 LS para las flags de la ALU
	assign LED = {RX_CTRL_status,8'h00,ALU_Flags};

endmodule