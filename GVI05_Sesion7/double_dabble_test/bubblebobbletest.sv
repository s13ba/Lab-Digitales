`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.06.2022 21:15:40
// Design Name: 
// Module Name: bubblebobbletest
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


module bubblebobbletest();
    logic clk, reset, trigger;
    logic [31:0]in;
    logic [31:0]bcd;
    logic idle;
       
    unsigned_to_bcd DUT(
        .clk(clk),
		.reset(reset),
		.trigger(trigger),
		.in(in),
		.idle(idle),
		.bcd(bcd)
    );
    always #5 clk=~clk;
    
    initial begin
    //clock en 0
    // in = abcd
        clk = 0;
        in = 32'habcd;
    
    //reset se activa
        #10
        reset = 1;
    //se activa el trigger
        #10
        reset = 0;
        trigger = 1;
    
    //se activa el reset
        #10
        reset = 1;
    // se revisa salida
        #10
        reset = 0;
    
    //se cambia in a aabb
        #10
        trigger = 0;
        #500
        in = 32'haabb;
    
    // se cambia a ffff
        #200
        trigger = 1;
        in = 32'hffff;
      // se cambia a 0  
        #640
        in = 32'h0;
     // se cambia a ffffffff
        #640
        in= 32'hffffffff;
        #640
     // se cambia a 0
        in = 32'h0;
        
    
    /*
     unsigned_to_bcd DUT(
        .clk(clk),
		.reset(reset),
		.trigger(idle),
		.in(in),
		.idle(idle),
		.bcd(bcd)
    );
    always #5 clk=~clk;
    
    initial begin
    //clock en 0
    // in = 00000000000000001111111111111111
        clk = 0;
        in = 32'habcd;
    
    //reset se activa
        #10
        reset = 1;
    //se activa el trigger
        #10
        reset = 0;
        trigger = 1;
    
    //se activa el reset
        #10
        reset = 1;
    // se revisa salida
        #10
        reset = 0;
    
    //se cambia in a 11111111111111111111111111111111
        #20
        trigger = 0;
        #500
        in = 32'haabb;
    
    // se cambia a 0
        #200
        in = 32'hffff;
        
        #640
        in = 32'h0;
        #640
        in= 32'hffffffff;
        #640
        in = 32'h0;
   */     
    end
endmodule
