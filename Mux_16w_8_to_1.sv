/*
 * TCES 330 - Spring 2025
 * Projcet Files 16 bit wide 8 to 1 mux
 * @author logan black
 * @version 03 June 2025
 * Creates a 16 bit wide 8 to 1 mux case statements
 */
module Mux_16w_8_to_1(M, S, A, B, C, D, E, F, G, H);
	input [2:0] S;
	input [15:0] A, B, C, D, E, F, G, H;
	output logic [15:0] M;
	
	always_comb begin
	
		case(S)
			3'd0: M = A;
			3'd1: M = B;
			3'd2: M = C;
			3'd3: M = D;
			3'd4: M = E;
			3'd5: M = F;
			3'd6: M = G;
			3'd7: M = H;
		endcase
		
	end
	
endmodule

`timescale 1 ps/1 ps
module Mux_16w_8_to_1_tb();
	logic [2:0] S;
	logic [15:0] A, B, C, D, E, F, G, H;
	logic [15:0] M;
	
	Mux_16w_8_to_1 DUT(M, S, A, B, C ,D ,E ,F, G, H);

	initial begin
	A = 16'd0;
	B = 16'd1;
	C = 16'd2;
	D = 16'd3;
	E = 16'd4;
	F = 16'd5;
	G = 16'd6;
	H = 16'd7;
	
	for (int i = 0; i < 8; i++) begin
		S = i; #10;
	end

end
endmodule
 