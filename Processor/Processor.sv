/*
 * TCES 330 Spring 2025
 * Project Files Processor
 * @author Logan Black & Ahmed Aljewad
 * @version 30 MAY 2025
 * Top level module for the six instruction processor used on the DE2 board
 */
 
 `timescale 1 ps / 1 ps
module Processor(Clk, ResetN, IR_Out, PC_Out, State, NextState, ALU_A,
ALU_B, ALU_Out);
	input Clk; // processor clock
	input ResetN; // system reset
	output [15:0] IR_Out; // Instruction register	
	output [6:0] PC_Out; // Program counter
	output [3:0] State; // FSM current state
	output [3:0] NextState; // FSM next state
	output [15:0] ALU_A; // ALU A-Side Input
	output [15:0] ALU_B; // ALU B-Side Input
	output [15:0] ALU_Out; // ALU current output
	
	
    // Wires for submodules
	logic [7:0] D_Addr;
	logic D_Wr;
	logic RF_s;
	logic RF_W_en;
	logic [3:0] RF_Ra_Addr;
	logic [3:0] RF_Rb_Addr;
	logic [3:0] RF_W_Addr;
	logic [2:0] ALU_s0;
	logic [7:0] PC_Out_internal;

	assign PC_Out = PC_Out_internal[6:0];

	// Control unit instantiation
	ControlUnit unit0 (
		.Clock(Clk),
		.ResetN(ResetN),         // Active-low reset for FSM
		.PC_out(PC_Out_internal),
		.IR_out(IR_Out),
		.OutState(State),
		.NextState(NextState),
		.Dmem_addr(D_Addr),
		.D_wr_en(D_Wr),
		.RF_sel(RF_s),
		.RF_wr_en(RF_W_en),
		.RF_RA_addr(RF_Ra_Addr),
		.RF_RB_addr(RF_Rb_Addr),
		.RF_wr_addr(RF_W_Addr),
		.ALU_sel0(ALU_s0) 
		);
		
	// Datapath instantiation
	DataPath unit1(
		.Clock(Clk),
		.D_Addr(D_Addr),
		.D_W_en(D_Wr), 
		.RF_s(RF_s), 
		.RF_W_Addr(RF_W_Addr), 
		.RF_W_en(RF_W_en), 
		.RF_Ra_Addr(RF_Ra_Addr), 
		.RF_Rb_Addr(RF_Rb_Addr), 
		.ALU_s0(ALU_s0), 
		.ALU_inA(ALU_A), 
		.ALU_inB(ALU_B), 
		.ALU_out(ALU_Out)
		);

endmodule
