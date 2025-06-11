/*
 * TCES 330 Spring 2025
 * Project Files 2 to 1 mux
 * @author Logan Black & Ahmed Aljewad
 * @version 28 MAY 2025
 * 2 to 1 16 bit mux built using case statement
 */
`timescale 1 ps / 1 ps
module Mux_2_to_1(
			S, 
			A, 
			B, 
			M
			);

	// input
	input S; 					// Select Signal
	input [15:0] A;			// 0 Side Input
	input [15:0] B;			// 1 Side Input
	
	// output
	output logic [15:0] M;	// MUx Output

	// assigns output M to A or B based on select signal case statement
	always_comb begin
		case (S)
			1'b0: M = A;
			1'b1: M = B;
		endcase
	end

endmodule

// test bench
module Mux_2_to_1_tb();

	// input
	logic s; 			// Select Signal
	logic [15:0] a;	// 0 Side Input
	logic [15:0] b;	// 1 Side Input
	
	// output
	logic [15:0] m;	// MUx Output

	// DUT instantiation
	Mux_2_to_1 DUT(
					.S(s), 
					.A(a), 
					.B(b), 
					.M(m)
					);

	// testing all variations of input and output
	initial begin
		s = 1'b0; a = 16'b0; b = 16'b0; #10;
								   b = 16'b1; #10;
					 a = 16'b1; b = 16'b0; #10;
								   b = 16'b1; #10;
		s = 1'b1; a = 16'b0; b = 16'b0; #10;
								   b = 16'b1; #10;
					 a = 16'b1; b = 16'b0; #10;
								   b = 16'b1; #10;
	end
	
endmodule
 