module deco_binario_3_cold_1 #(parameter N=3)(
    input  logic [N-1:0]sel,
    output logic [7:0]out
    );

    always_comb begin

        case(sel)
            3'd0: out = 8'b11111110;
            3'd1: out = 8'b11111101;
            3'd2: out = 8'b11111011;
            3'd3: out = 8'b11110111;
            3'd4: out = 8'b11101111;
            3'd5: out = 8'b11011111;
            3'd6: out = 8'b10111111;
            3'd7: out = 8'b01111111;
		    default: out = 8'b11111111;
        endcase

    end
    
endmodule