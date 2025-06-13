/* 
Ahmed Aljewad & Logan Black
6/4
Implementing the processor on the DE2 board

*/

module Project(CLOCK_50, KEY, HEX7, HEX6, HEX5, HEX4, HEX3, HEX2, HEX1, HEX0, SW, LEDG, LEDR);

	input CLOCK_50;
	input [3:0] KEY; //KEY[2] = Clock, KEY[1] = Reset
	input [17:0] SW;
	output [0:6] HEX7, HEX6, HEX5, HEX4, HEX3, HEX2, HEX1, HEX0;
	output [3:0] LEDG;
	output [17:0] LEDR;
	
	logic Bo; // ButtonSync output
	logic Clk;
	
	//Processor outputs
	logic [15:0] IR_Out, ALU_A, ALU_B, ALU_Out;
	logic [7:0] NextState, State, PC_Out;
	
	logic [15:0] Zero; // Wire for unused mus inputs
	logic [15:0] M; // Mux output
	
	assign Zero = 16'd0;
	assign LEDR = SW;
	assign LEDG = KEY;
	
	//ButtonSync(Clock, Bi, Bo)
	ButtonSync unit0(CLOCK_50, KEY[2], Bo);
	
	//KeyFilter (Clk, In, Out)
	KeyFilter unit1(CLOCK_50, Bo, Clk);
	
	//Processor(Clk, ResetN, IR_Out, PC_Out, State, NextState, ALU_A, ALU_B, ALU_Out)
	Processor unit2(Clk, KEY[1], IR_Out, PC_Out, State[3:0], NextState[3:0], ALU_A, ALU_B, ALU_Out);
	
	//Mux_16w_8_to_1(M, S, A, B, C, D, E, F, G, H);
	Mux_16w_8_to_1 unit3(M, SW[17:15], {PC_Out, State}, ALU_A, ALU_B, ALU_Out, {8'd0, NextState}, Zero, Zero, Zero);

	//Decoder( Hex, V)
	Decoder unit4(HEX7, M[15:12]);
	Decoder unit5(HEX6, M[11:8]);
	Decoder unit6(HEX5, M[7:4]);
	Decoder unit7(HEX4, M[3:0]);
	
	Decoder unit8(HEX3, IR_Out[15:12]);
	Decoder unit9(HEX2, IR_Out[11:8]);
	Decoder unit10(HEX1, IR_Out[7:4]);
	Decoder unit11(HEX0, IR_Out[3:0]);


endmodule 