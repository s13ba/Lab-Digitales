module mux_8_1_1 #(parameter N=3)(	//8 entradas, 1 salida
    input logic [3:0] A, B, C, D, E, F, G, H, //8 entradas de 4b
    input logic [N-1:0] sel, //selector de 3b
    output logic [3:0]out //salida 4b
    
 );
 
    always_comb begin
        case (sel)
            3'd0: out = A;
            3'd1: out = B;
            3'd2: out = C;
            3'd3: out = D;
            3'd4: out = E;
            3'd5: out = F;
            3'd6: out = G;
            3'd7: out = H;
		default: out = A;
        endcase
    end
endmodule