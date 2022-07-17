`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.06.2022 21:15:40
// Design Name: 
// Module Name: UART_RX_CTRL_test
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
///////////

module UART_RX_CTRL_test();

    logic clk, reset, rx_ready;
    logic [7:0]rx_data;

    logic trigger, Enter_ALU;
    logic [15:0] Data_In;
    logic [3:0]LED;

    UART_RX_CTRL #(	
    .WAIT_FOR_REGISTER_DELAY(3) // tiempo de espera para iniciar la transmision luego de registrar el dato a enviar
	) DUT (
		.clk		(clk), 
		.reset		(reset), 
		.rx_ready	(rx_ready),
		.rx_data	(rx_data),
		.trigger	(trigger), 
		.Enter_ALU	(Enter_ALU),
		.Data_In	(Data_In),
		.LED		(LED)
    );

    always #1 clk = ~clk;

    initial begin
        clk = 0;
        reset = 1;
        rx_ready = 0;
        rx_data = 8'hFE;
        #10 reset = 0;

        #20 rx_ready = 1;

        #5 rx_ready = 1;
        #5 rx_ready = 0;
        #5 rx_ready = 1;
        #5 rx_ready = 0;
        #5 rx_ready = 1;
        #5 rx_ready = 0;
        #5 rx_ready = 1;
    end

endmodule