/* TCES330 Spring 2025 
04/15
HW3 Q1 part 2
By Ahmed Aljewad
Implements a binary-to-7-segment display decoder.
The 4-bit input `V` represents a hexadecimal digit (0–F), and the
output `Hex` is a 7-bit signal that lights up the correct segment
*/

module Decoder( Hex, V);
	input [3:0] V; // input lines
	output logic [0:6]Hex; // the seven segments
	
	// Combinational logic for 7-segment decoding
	always_comb begin
		case(V)
		4'b0000: Hex = 7'b0000001; //output is 0
		4'b0001: Hex = 7'b1001111; //output is 1
		4'b0010: Hex = 7'b0010010; //output is 2
		4'b0011: Hex = 7'b0000110; //output is 3
		4'b0100: Hex = 7'b1001100; //output is 4
		4'b0101: Hex = 7'b0100100; //output is 5
		4'b0110: Hex = 7'b0100000; //output is 6
		4'b0111: Hex = 7'b0001111; //output is 7
		4'b1000: Hex = 7'b0000000; //output is 8
		4'b1001: Hex = 7'b0000100; //output is 9
		4'b1010: Hex = 7'b0001000; //output is A
		4'b1011: Hex = 7'b1100000; //output is b
		4'b1100: Hex = 7'b0110001; //output is C
		4'b1101: Hex = 7'b1000010; //output is d
		4'b1110: Hex = 7'b0110000; //output is E
		4'b1111: Hex = 7'b0111000; //output is F
		default: Hex = 7'b1111111; //all segements off
		endcase;

	end
endmodule

//testebench
module Decoder_tb;
	logic [3:0] V;
	logic [0:6] Hex;

	Decoder DUT(Hex, V);

	initial begin
	//loop through all possible values of V(0-15) to test the output 
		for (int i = 0; i < 16; i = i + 1) begin
			{V} = i; #10;

		end
		
	end
	
	//display V as a hexidecimal and the corresponding output as a 7 singal output
	initial begin 
	$display("time\tV\tHex");
	$monitor($realtime, "\t%h\t%b", V, Hex);

	end

endmodule 