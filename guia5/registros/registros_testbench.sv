`timescale 1ns / 1ps

module registros_testbench();

    logic D, clk, reset1b, reset1b_delay, load, enable;
    logic Q_reg_1_bit, Q_reg_delay;


register_1_bit #(
    .N        (1)
) DUT_register_1_bit (
    .D        (D),
    .clk      (clk),
    .reset    (reset1b),
    .load     (load),
    .Q        (Q_reg_1_bit)
);


register_1_bit_delay DUT_register_1_bit_delay (
    .clk       (clk),
    .D         (D),
    .reset     (reset1b_delay),
    .enable    (enable),
    .Q         (Q_reg_delay)
);


//clock
    always #1 clk=~clk;

//el test

initial begin
    clk =   0;
    reset1b =  1;
    reset1b_delay =  1;
    enable = 0;     //del 1 bit delay
    load =  0;      //del 1 bit
    D   =   0;
    //lo de 1 bit:
    #4  D = 1;
    #2  reset1b   = 0; reset1b_delay = 0;
    #4  load    = 1;
    #4  enable  = 1;
    
    #8  load    = 0;
  
    #4  D = 0;

    #32 reset1b   = 1;

    #8  D = 1;

    #4  load    = 1;
        enable  = 1;

    #8  reset1b   = 0;  //74ns
    
    //140 ns
    #66 reset1b_delay=1;
    
    #70 reset1b_delay=0;
    
    #138 D=1;
         enable=1;
        
    #148 enable=0;


end
endmodule


