/*
 * TCES 330 Spring 2025
 * Project Files 16 bit ALU
 * @author Logan Black & Ahmed Aljewad
 * @version 28 MAY 2025
 * This module simulates a 16 bit ALU which performs various ALU operations
 */
 
`timescale 1 ps / 1 ps

module ALU(
			A,
			B,
			Sel,
			Q
			);

	// parameter set for desired bit width
	parameter Width = 16;
	
	// input & output
	input [2:0] Sel;					// Select Signal
	input [Width-1:0] A;				// A Side input
	input [Width-1:0] B;				// B Side input
	output logic [Width-1:0]  Q; 	// ALU Result. Q can be made 1 bit higher than input to handle overflow

	// ALU operation determined using case statement based on select signal
	always_comb begin
		case(Sel)
			3'b000: Q = 0;
			3'b001: Q = A + B;
			3'b010: Q = A - B;
			3'b011: Q = A;
			3'b100: Q = A ^ B;
			3'b101: Q = A | B;
			3'b110: Q = A & B;
			3'b111: Q = A + 1;
		endcase
	end

endmodule

// test bench
module ALU_tb();

	// bit width of 4 used for testing
	localparam width = 4;
	
	// input & output
	logic [2:0] sel;		// Select Signal
	logic [width-1:0] a;	// A Side input
	logic [width-1:0] b;	// B Side input
	logic [width-1:0] q; // q can be made 1 bit higher than input to display overflow bit
	
	// DUT instantiation
	ALU #(.Width(width)) DUT(
									.A(a), 
									.B(b), 
									.Sel(sel), 
									.Q(q)
									);
	
	// testing
	initial begin
		
		// testing edge case all 0
		a = 'h0; b = 'h0; 
		for (int i = 0; i < 8; i++) begin
			sel = i; #10;
		end
		
		// testing edge case all 1
		a = {width{1'b1}}; b = {width{1'b1}}; 
		for (int j = 0; j < 8; j++) begin
			sel = j; #10;
		end
		
		// testing random cases
		for (int k = 0; k < 8; k++) begin
			a = $urandom_range('b0, ('b1 << width) - 'b1); // 1'b1 << 4 - 1'b1 == 10000 - 1 == 1111.
			b = $urandom_range('b0, ('b1 << width) - 'b1); // dynamically adjusts range from 0 to maximum value of width.
			sel = k; #10;
		end
		
	end
	
endmodule
