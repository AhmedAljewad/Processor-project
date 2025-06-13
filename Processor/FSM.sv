/*
 * TCES 330 Spring 2025
 * Project Files FSM
 * @author Logan Black & Ahmed Aljewad
 * @version 30 MAY 2025
 * This module functions as a finite state machine for the control unit
 */
 
 `timescale 1 ps / 1 ps
 
module FSM(Clk, resetN, IR, PC_up, PC_clr, IR_ld, D_Addr, D_wr, RF_s, RF_W_addr, 
RF_W_en, RF_Ra_addr, RF_Rb_addr, ALU_s0, OutState, NextState);

    // Inputs
	input Clk, resetN;
	input [15:0] IR;
	// Outputs
	output logic PC_up, PC_clr, IR_ld, D_wr, RF_s, RF_W_en;
	output logic [3:0] RF_W_addr, RF_Ra_addr, RF_Rb_addr;
	output logic [2:0] ALU_s0;
	output logic [7:0] D_Addr;
	output logic [3:0] OutState, NextState;
    // States
	logic [3:0] Current_State, Next_State;
	
	// Show states as outputs
	assign OutState = Current_State;
	assign NextState = Next_State;

    // State names, 4 bits for 10 states
	localparam Init = 4'h0,
		   Fetch = 4'h1,
		   Decode = 4'h2,
		   LOAD_A = 4'h3,
		   LOAD_B = 4'h4,
		   ADD = 4'h5,
		   SUB = 4'h6,
		   STORE = 4'h7,
		   NOOP = 4'h8,
		   HALT = 4'h9;

    // Control logic based on current state
	always_comb begin
	
	// Set all outputs to default values
	PC_clr = 1'b0;
	PC_up = 1'b0;
	IR_ld = 1'b0;
	D_wr = 1'b0;
	RF_s = 1'b0;
	RF_W_en = 1'b0;
	RF_W_addr = 4'd0;
	RF_Ra_addr = 4'd0;
	RF_Rb_addr = 4'd0;
	ALU_s0 = 3'd0;
	D_Addr = 8'd0;

		case(Current_State)
		// Reset PC and go to Fetch
		Init: begin
			Next_State = Fetch;
			PC_clr = 1'b1;
		      end
		      
        // Load IR and go to Decode
		Fetch: begin
			Next_State = Decode;
			IR_ld = 1'b1;
			PC_up = 1'b1;
		       end
		       
        // Choose next state based on opcode
		Decode: begin 
			case(IR[15:12])
				4'd0: Next_State = NOOP;
				4'd1: Next_State = STORE; 
				4'd2: Next_State = LOAD_A;
				4'd3: Next_State = ADD;
				4'd4: Next_State = SUB;
				4'd5: Next_State = HALT;
				default: Next_State = Fetch;
			endcase
			end
			
        // Start memory load, set address and enable write to register
		LOAD_A: begin 
			Next_State = LOAD_B;
			D_Addr = IR[11:4];
			RF_s = 1'b1;
			RF_W_addr = IR[3:0];
			RF_W_en = 1'b1;
			end
			
        // Same as LOAD_A (can be used for another operand)
		LOAD_B: begin 
			Next_State = Fetch;
			D_Addr = IR[11:4];
			RF_s = 1'b1;
			RF_W_addr = IR[3:0];
			RF_W_en = 1'b1;
			end
			
        // Add values from Ra and Rb, store in destination register
		ADD: begin 
		     Next_State = Fetch;
		     RF_W_addr = IR[3:0];
		     RF_W_en = 1'b1;
		     RF_Ra_addr = IR[11:8];
		     RF_Rb_addr = IR[7:4];
		     ALU_s0 = 3'd1;
		     RF_s = 1'b0;
		     end
		     
		// Subtract Rb from Ra, store result in destination register
		SUB: begin
		     Next_State = Fetch;
		     RF_W_addr = IR[3:0];
		     RF_W_en = 1'b1;
		     RF_Ra_addr = IR[11:8];
		     RF_Rb_addr = IR[7:4];
		     ALU_s0 = 3'd2;
		     RF_s = 1'b0;
		     end
		     
        // Write value from Ra to memory address
		STORE: begin 
		       Next_State = Fetch;
		       D_Addr = IR[7:0];
		       D_wr = 1'b1;
		       RF_Ra_addr = IR[11:8];
		       end
		       
		// Do nothing, just go to next instruction
		NOOP: Next_State = Fetch;
		
		// Stay here forever, stop executing
		HALT: Next_State = HALT;
		
		// Unknown state, reset
		default: Next_State = Init;

		endcase
	end
	
    // Flip-flop logic to update current state
	always_ff @(posedge Clk) begin
		if(!resetN) Current_State <= Init; // On reset go to Init
		else Current_State <= Next_State; // Go to next state
	end
	


endmodule 

// Testbench
module FSM_tb();
	logic Clk, resetN;
	logic [15:0] IR;
	logic PC_up, PC_clr, IR_ld, D_wr, RF_s, RF_W_en;
	logic [3:0] RF_W_addr, RF_Ra_addr, RF_Rb_addr;
	logic [2:0] ALU_s0;
	logic [7:0] D_Addr;
	logic [3:0] OutState;
	logic [3:0] NextState;

    // Testbench signals
	FSM DUT(Clk, resetN, IR, PC_up, PC_clr, IR_ld, D_Addr, D_wr, RF_s, RF_W_addr, 
	RF_W_en, RF_Ra_addr, RF_Rb_addr, ALU_s0, OutState, NextState);

    // 50 MHz clock
	always begin 
	Clk = 1'b0; #10;
	Clk = 1'b1; #10;
	end

	initial begin
	resetN = 1'b0; #20;
	resetN = 1'b1; #20;

	// Test Store
	IR = 16'h1234; wait(OutState == 4'h7); #20;
	assert(D_Addr == IR[7:0] && D_wr == 1'b1 && RF_Ra_addr == IR[11:8]) begin
    $display("STORE is successful: D_Addr = %b, RF_Ra_addr = %b", D_Addr, RF_Ra_addr);
	end else begin
    $display("STORE FAILED");
	end

	// Test ADD
	IR = 16'h3ABC; wait(OutState == 4'h5); #20;
	assert(ALU_s0 == 3'd1 && RF_W_en == 1'b1 && RF_W_addr == IR[3:0] && RF_Ra_addr == IR[11:8] && RF_Rb_addr == IR[7:4]) begin
    $display("ADD is successful, RF_W_addr = %b, RF_Ra_addr = %b, RF_Rb_addr = %b", RF_W_addr, RF_Ra_addr, RF_Rb_addr);
	end else begin
	$display("ADD FAILED");
	end

	// Test SUB
	IR = 16'h43AF; wait(OutState == 4'h6); #20;
	assert(ALU_s0 == 3'd2 && RF_W_en == 1'b1 && RF_W_addr == IR[3:0] && RF_Ra_addr == IR[11:8] && RF_Rb_addr == IR[7:4]) begin
    $display("SUB is successful, RF_W_addr = %b, RF_Ra_addr = %b, RF_Rb_addr = %b", RF_W_addr, RF_Ra_addr, RF_Rb_addr);
	end else begin
    $display("SUB FAILED");
	end

	// Test NOOP
	IR = 16'h0234; wait(OutState == 4'h8); #20;
	assert(RF_W_en == 1'b0 && D_Addr == 8'd0 && ALU_s0 == 3'd0) begin
   	$display("NOOP is successful no changes occurred");
	end else begin
    $display("NOOP FAILED");
	end
	
	// Test Halt
	IR = 16'h5234; wait(OutState == 4'h9); #20;
	assert(OutState == 4'h9 && PC_up == 0 && IR_ld == 0 && RF_W_en == 0 && D_wr == 0) begin
    $display("HALT is successful, FSM stayed in HALT and signals are low");
    end else begin
    $display("HALT FAILED");
    end
    
	$stop;
	end


endmodule