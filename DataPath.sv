/*
 * TCES 330 Spring 2025
 * Project Files DataPath
 * @author Ahmed Aljewad & Logan Black
 * @version 28 MAY 2025
 * Top level module that instantiates all required components to form a completed DataPath
 */
 
 `timescale 1 ps / 1 ps
 
 module DataPath(
			Clock, 
			D_Addr, 
			D_W_en, 
			RF_s, 
			RF_W_Addr, 
			RF_W_en, 
			RF_Ra_Addr, 
			RF_Rb_Addr, 
			ALU_s0, 
			ALU_inA, 
			ALU_inB, 
			ALU_out);
 
	// input
	input Clock;					// Clock
	input D_W_en;					// RAM Write Enable
	input RF_s;						// MUX Select Bit
	input RF_W_en;					// Register File Write Enable
	input [2:0] ALU_s0;			// ALU Select Bits
	input [3:0] RF_W_Addr;		// Register File Write Address
	input [3:0] RF_Ra_Addr;		// Register File Read "a" Address
	input [3:0] RF_Rb_Addr;		// Register File Read "b" Address
	input [7:0] D_Addr;			// RAM Address
	
	// output
	output [15:0] ALU_inA;		// Read "a" Data
	output [15:0] ALU_inB;		// Read "b" Data
	output [15:0] ALU_out;		// ALU Output
	
	// internal wires
	logic [15:0] R_Data;			// RAM Output
	logic [15:0] W_Data;			// MUX Output
	logic [15:0] RF_A_Out;		// RF A output
	logic [15:0] RF_B_Out;		// RF B output
	logic [15:0] ALU_result;	// ALU Result
	
	// Instantiates the RAM
	RAM unit0(
			.address(D_Addr), 
			.clock(Clock), 
			.data(RF_A_Out), 
			.wren(D_W_en), 
			.q(R_Data)
			);
	
	// Instantiates the MUX
	Mux_2_to_1 unit1(
					.S(RF_s), 
					.A(ALU_result), 
					.B(R_Data), 
					.M(W_Data)
					);
					
	// Instantiates the Register File
	RegisterFile unit2(
						.Clk(Clock), 
						.Wren(RF_W_en), 
						.WrAddr(RF_W_Addr), 
						.RdAddrA(RF_Ra_Addr), 
						.RdAddrB(RF_Rb_Addr), 
						.WrData(W_Data), 
						.RdDataA(RF_A_Out), 
						.RdDataB(RF_B_Out)
						);
	
	// Instantiates the ALU
	ALU unit3(
			.A(RF_A_Out), 
			.B(RF_B_Out), 
			.Sel(ALU_s0), 
			.Q(ALU_result)
			);
			
	assign ALU_inA = RF_A_Out;
	assign ALU_inB = RF_B_Out;
	assign ALU_out = ALU_result;
 
 endmodule
 
 // testbench
 module DataPath_tb();
	
	// DUT input
	logic Clock;					// Clock
	logic D_W_en;					// RAM Write Enable
	logic RF_s;						// MUX Select Bit
	logic RF_W_en;					// Register File Write Enable
	logic [2:0] ALU_s0;			// ALU Select Bits
	logic [3:0] RF_W_Addr;		// Register File Write Address
	logic [3:0] RF_Ra_Addr;		// Register File Read "a" Address
	logic [3:0] RF_Rb_Addr;		// Register File Read "b" Address
	logic [7:0] D_Addr;			// RAM Address
	
	// DUT output
	logic [15:0] ALU_inA;	// Read "a" Data
	logic [15:0] ALU_inB;	// Read "b" Data
	logic [15:0] ALU_out;	// ALU Output
	
	// DUT
	DataPath DUT(
				.Clock(Clock), 
				.D_W_en(D_W_en), 
				.RF_s(RF_s), 
				.RF_W_en(RF_W_en), 
				.ALU_s0(ALU_s0), 
				.RF_W_Addr(RF_W_Addr), 
				.RF_Ra_Addr(RF_Ra_Addr), 
				.RF_Rb_Addr(RF_Rb_Addr), 
				.D_Addr(D_Addr), 
				.ALU_inA(ALU_inA), 
				.ALU_inB(ALU_inB), 
				.ALU_out(ALU_out)
				);
	
	// Clock Generation
	always begin
		Clock = 1'b0; #10;
		Clock = 1'b1; #10;
	end
	
	// Begin Testing
	initial begin
		
		// Initialize write enable to low
		D_W_en = 1'b0;
      RF_W_en = 1'b0;
		#20;
		
		/* 
		 * NOTE: RAM values have been explicitly initialized to specific values
		 * for this test. Assignments as follows: addresses 8'd0 = 20 and 8'd1 = 25.
		 */
		
		// Load from RAM Address 8'd0 into RF Address 4'd0
		@(negedge Clock)
			D_Addr = 8'd0; #20;
			RF_s = 1'd1; #20;
			RF_W_Addr = 4'd0; RF_W_en = 1'd1; #20;
			RF_Ra_Addr = 4'd0; RF_W_en = 1'd0; #20;
			assert(ALU_inA == 20) begin
				$display("ALU_inA = %d in register %b", ALU_inA, RF_Ra_Addr);
			end else begin
				$error("AN ERROR OCURRED AROUND LINE 149!");
			end
		
		
		// Load from RAM Address 8'd1 into RF Address 4'd1
		@(negedge Clock)
			D_Addr = 8'd1; #20;
			RF_W_Addr = 4'd1; RF_W_en = 1'd1; #20; 
			RF_Rb_Addr = 4'd1; RF_W_en = 1'd0; #20;
			assert(ALU_inB == 25) begin
				$display("ALU_inB = %d in register %b", ALU_inB, RF_Rb_Addr);
			end else begin
				$error("AN ERROR OCURRED AROUND LINE 160!");
			end
		
		
		// Perform ALU Operations
		@(negedge Clock)
			ALU_s0 = 3'd1; #20;
			assert(ALU_out == 45) begin
				$display("ALU_out = %d", ALU_out);
			end else begin
				$error("AN ERROR OCURRED AROUND LINE 168!");
			end
			
			
		// Store ALU result in RF Address 4'd2
		@(negedge Clock)
			RF_s = 1'd0; #20;
			RF_W_Addr = 4'd2; RF_W_en = 1'd1; #20;
			RF_Ra_Addr = 4'd2; RF_W_en = 1'd0; #20;
			assert(ALU_inA == 45) begin
				$display("Value to store in RAM = %d in register %b", ALU_inA, RF_Ra_Addr);
			end else begin
				$error("AN ERROR OCURRED AROUND LINE 178!");
			end
		
		
		// Store ALU result from RF Address 4'd2 into RAM address 8'd2
		@(negedge Clock)
			D_Addr = 8'd2; D_W_en = 1'd1; #20;
			D_W_en = 1'd0; #20;
			
			
		// Write the previously stored RAM value @ address 8'd2 to RF to verify correctness
		@(negedge Clock)
			RF_s = 1'd1; #20;
			RF_W_Addr = 4'd3; RF_W_en = 1'd1; #20;
			RF_Rb_Addr = 4'd3; RF_W_en = 1'd0; #20;
			assert(ALU_inB == 16'd45) begin
				$display("RESULT OK!");
				$display("20 successfully extracted from RAM address 8'd0");
				$display("25 successfully extracted from RAM address 8'd1");
				$display("20 successfully stored in RF address 4'd0");
				$display("25 successfully stored in RF address 4'd1");
				$display("ALU add operation result == 45");
				$display("45 successfully stored in RAM address 8'd2");
				$display("45 successfully extracted from RAM address 8'd2");
				$display("45 successfully stored in RF address 4'd3");
			end else begin
				$error("ERROR!");
			end
			
		$stop;
	
	end
	
	
 endmodule
 