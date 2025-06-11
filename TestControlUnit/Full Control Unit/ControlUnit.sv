/*
 * TCES 330 Spring 2025
 * Project Files Control Unit
 * @author Logan Black & Ahmed Aljewad
 * @version 01 JUNE 2025
 * Top level module for the control unit
 */
 
 `timescale 1 ps / 1 ps
 
 module ControlUnit(
			Clock,
			ResetN,
			PC_out,
			IR_out,
			OutState,
			NextState,
			Dmem_addr, 
			D_wr_en, 
			RF_sel, 
			RF_wr_addr, 
			RF_wr_en, 
			RF_RA_addr, 
			RF_RB_addr, 
			ALU_sel0
			);
			
			
	// input
	input Clock;					// System Clock
	input ResetN;					// FSM reset signal
	
	
	// output
	output [7:0] Dmem_addr;		// Data memory address
	output D_wr_en;				// RAM write enable
	output RF_sel;					// Data Path MUX select signal
	output [3:0] RF_wr_addr;	// Register file write address
	output RF_wr_en;				// Register file write enable
	output [3:0] RF_RA_addr;	// Register file A side address
	output [3:0] RF_RB_addr;	// Register file B side address
	output [2:0] ALU_sel0;		// ALU select signal
	output [7:0] PC_out;			// PC output address
	output [15:0] IR_out;		// IR data output
	output [3:0] OutState;		// FSM state output
	output [3:0] NextState;		// FSM next state
	
	
	// FSM internal wires
	logic PC_up;					// PC count up enable signal
	logic PC_clear;				// PC clear signal
	logic IR_load;					// IR load enable signal
	logic [7:0] D_addr;			// Data Memory address
	logic D_wr;						// RAM write enable
	logic RF_s;						// RF select signal
	logic [3:0] RF_W_addr;		// RF write address
	logic RF_W_en;					// RF write enable
	logic [3:0] RF_Ra_addr;		// RF A side address
	logic [3:0] RF_Rb_addr;		// RF B side address
	logic [2:0] ALU_s0;			// ALU select signal
	logic [3:0] State_out;		// FSM state output
	logic [3:0] State_next;		// FSM next state
	
	
	// PC internal wires
	logic [6:0] PC_addr_out;	// PC address out
	
	
	// Instruction Memory internal wires
	logic [15:0] ROM_data_out;	// ROM data out
	
	
	// IR internal wires
	logic [15:0] IR_data_out;	// IR data output
	
	
	// wire to output assignment
	assign Dmem_addr = D_addr;
	assign D_wr_en = D_wr;
	assign RF_sel = RF_s;
	assign RF_wr_addr = RF_W_addr;
	assign RF_wr_en = RF_W_en;
	assign RF_RA_addr = RF_Ra_addr;
	assign RF_RB_addr = RF_Rb_addr;
	assign ALU_sel0 = ALU_s0;
	assign PC_out = PC_addr_out;
	assign IR_out = IR_data_out;
	assign OutState = State_out;
	assign NextState = State_next;
	
	
	// FSM instantiation
	FSM unit0(
			.Clk(Clock),
			.resetN(ResetN),
			.IR(IR_data_out),
			.PC_up(PC_up),
			.PC_clr(PC_clear),
			.IR_ld(IR_load),
			.D_Addr(D_addr),
			.D_wr(D_wr),
			.RF_s(RF_s),
			.RF_W_addr(RF_W_addr),
			.RF_W_en(RF_W_en),
			.RF_Ra_addr(RF_Ra_addr),
			.RF_Rb_addr(RF_Rb_addr),
			.ALU_s0(ALU_s0),
			.OutState(State_out),
			.NextState(State_next)
			);
			
			
	// PC instantiation
	PC unit1(
			.Clk(Clock),
			.Clr(PC_clear),
			.Up(PC_up),
			.Addr(PC_addr_out)
			);
			
			
	// Instruction Mem instantiation
	ROM unit2(
			.address(PC_addr_out),
			.clock(Clock),
			.q(ROM_data_out)
			);
			
			
	// Instruction Register instantiation
	IR unit3(
			.Clock(Clock),
			.Load(IR_load),
			.Data_in(ROM_data_out),
			.Data_out(IR_data_out)
			);
 
 endmodule
 
 
 // testbench
 module ControlUnit_tb();
 
 
 	// input
	logic Clock;				// System Clock
	logic ResetN;				// FSM reset signal
	
	
	// output
	logic [7:0] Dmem_addr;	// Data memory address
	logic D_wr_en;				// RAM write enable
	logic RF_sel;				// Data Path MUX select signal
	logic [3:0] RF_wr_addr;	// Register file write address
	logic RF_wr_en;			// Register file write enable
	logic [3:0] RF_RA_addr;	// Register file A side address
	logic [3:0] RF_RB_addr;	// Register file B side address
	logic [2:0] ALU_sel0;	// ALU select signal
	logic [7:0] PC_out;		// PC output address
	logic [15:0] IR_out;		// IR data output
	logic [3:0] OutState;	// FSM state output
	logic [3:0] NextState;	// FSM next state
	
	
	// DUT instantiation
	ControlUnit DUT(
						.Clock(Clock),
						.ResetN(ResetN),
						.PC_out(PC_out),
						.IR_out(IR_out),
						.OutState(OutState),
						.NextState(NextState),
						.Dmem_addr(Dmem_addr), 
						.D_wr_en(D_wr_en), 
						.RF_sel(RF_sel), 
						.RF_wr_addr(RF_wr_addr), 
						.RF_wr_en(RF_wr_en), 
						.RF_RA_addr(RF_RA_addr), 
						.RF_RB_addr(RF_RB_addr), 
						.ALU_sel0(ALU_sel0)
						);
						

	// Clock initialization
	always begin
		Clock = 1'b0; #10;
		Clock = 1'b1; #10;
	end
	
	
	// testing
	initial begin
	
		ResetN = 1'b0; #40;
		ResetN = 1'b1; #1000;
		ResetN = 1'b0; #40;
				
		$stop;
		
	end
	
	initial begin
    	$monitor("Clk = %b\tResetN = %b\tPC_out = %b\tIR_out = %h\tOutState = %h\tNextState = %h\tDmem_addr = %h\tD_wr_en = %b\tRF_sel = %b\tRF_wr_en = %b\tRF_RA_addr = %b	\tRF_RB_addr = %b\tRF_wr_addr = %b\tALU_sel0 = %b\n", Clock, ResetN, PC_out, IR_out, OutState, NextState, Dmem_addr, D_wr_en, RF_sel, RF_wr_en, RF_RA_addr, RF_RB_addr, 	RF_wr_addr, ALU_sel0);

    end
	
	
 endmodule
 