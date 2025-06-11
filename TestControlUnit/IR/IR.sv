/*
 * TCES 330 Spring 2025
 * Project Files IR
 * @author Logan Black & Ahmed Aljewad
 * @version 30 MAY 2025
 * This module functions as an instruction register for the control unit
 */
 
 `timescale 1 ps / 1 ps
 
 module IR(
			Clock, 
			Load, 
			Data_in, 
			Data_out
			);
			
	// input		
	input Clock;				// System Clock
	input Load;					// Acts as enable from FSM
	input [15:0] Data_in;	// Instruction input from IROM
	
	// output
	output logic [15:0] Data_out;	// Instruction output to FSM
	
	always @(posedge Clock) begin
		if (Load) begin
			Data_out <= Data_in;
		end 
	end
	
 endmodule
 
 // testbench
 module IR_tb();
 
 	logic Clock;				// System Clock
	logic Load;					// Acts as enable from FSM
	logic [15:0] Data_in;	// Instruction input from IROM
	
	// output
	logic [15:0] Data_out;	// Instruction output to FSM
	
	// DUT instantiation
	IR DUT(
			.Clock(Clock),
			.Load(Load),
			.Data_in(Data_in),
			.Data_out(Data_out)
			);
			
	// Initialize system clock
	always begin
		Clock = 1'b0; #10;
		Clock = 1'b1; #10;
	end
	
	// Begin testing
	initial begin
	
		// initialize values to drive an initial state into Data_out
		Load = 1'b1;
		Data_in = 16'd0;
		
		// Set Load to LOW to begin testing of hold state
		@(negedge Clock)
		Load = 1'b0;
		
		// Test Data_out hold state when load is low
		for (int i = 0; i < 3; i++) begin
			Data_in = $urandom_range(1, 16'hFFFF);
			
			@(posedge Clock);
			#1;
			assert(Data_out == 16'd0) begin
				$display("Load LOW test# %d OK!",i+1);
			end else begin
				$error("Load LOW test FAILED!");
			end
			@(negedge Clock);
		end
		
		// Set load to HIGH to begin testing of changing states
		Load = 1'b1;
		
		// Test Data_out change state when load is high
		for (int j = 0; j < 3; j++) begin
			Data_in = $urandom_range(1, 16'hFFFF);
			
			@(posedge Clock);
			#1;
			assert(Data_out == Data_in) begin
				$display("Load HIGH test# %d OK!",j+1);
			end else begin
				$error("Load HIGH test FAILED!");
			end
			@(negedge Clock);
		end
		
		$stop;
	
	end
 
 endmodule
 