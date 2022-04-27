`timescale 1ns / 1ps
//la wea exhaustiva pal mux
module muxtestbench();
    logic [3:0]A,B,C,D,E,out;
    logic [2:0]sel;
    /*
    mux_4_1 DUT(
        .A (A),
        .B (B),
        .C (C),
        .D (D),
        .out(out),
        .sel(sel)
    );*/

    mux_5_1 DUT(
        .A (A),
        .B (B),
        .C (C),
        .D (D),
        .E (E),
        .out(out),
        .sel(sel)
    );
initial begin
    A = 4'b1000;
    B = 4'b1111;
    C = 4'b0011;
    D = 4'b0010;
    E = 4'b0101;
    sel = 3'b000;
    #5
    sel = 3'b001;
    #5
    sel = 3'b010;
    #5
    sel = 3'b011;
    #5
    sel = 3'b100;
    #5
    sel = 3'b111;

end
endmodule