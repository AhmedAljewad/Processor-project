/* TCES330 Spring 2025 
06/3
ButtonSync
By Ahmed Aljewad & Logan Black
*/

module ButtonSync(Clock, Bi, Bo);
	// Declare inputs and outputs
	input Clock, Bi;
	output Bo;
	logic [1:0] CurrentState, NextState;
	// State encoding using local parameters
	localparam A = 3'h0,
		   B = 3'h1,
		   C = 3'h2;
				  
	// Next-state logic
	always_comb begin
		case (CurrentState)
			A: if (Bi) NextState = B;
			else NextState = A;
			
			B: if (Bi) NextState = C;
			else NextState = A;
			
			C: if (Bi) NextState = C;
			else NextState = A;
			
			
			default: NextState = 3'h0;
		endcase
	end
	
	always_ff @(posedge Clock) begin
		CurrentState <= NextState;
	end

	assign Bo = (CurrentState == B);
	
endmodule 
