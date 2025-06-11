/*
 * TCES 330 Spring 2025
 * Project Files Register + Ram
 * @author Ahmed Aljewad & Logan Black
 * @version 28 MAY 2025
 * Module to test RAM + Register File
 */
 
 `timescale 1 ps / 1 ps

 module RegRam(
        Clock, 
        D_Addr, 
        D_W_En, 
        RF_W_Addr, 
        RF_W_en, 
        RF_Ra_Addr, 
        RF_Rb_Addr, 
        Ra_Data, 
        Rb_Data);

	// input
	input Clock;				// System Clock
	input D_W_En;				// RAM Write Enable
	input RF_W_en;				// RF Write Enable
	input [3:0] RF_W_Addr;	// RF Write Address
	input [3:0] RF_Ra_Addr;	// RF A Side Address
	input [3:0] RF_Rb_Addr;	// RF B Side Address
	input [7:0] D_Addr;		// RAM Address
	
	// output
	output [15:0] Ra_Data;	// RF A Side Data
	output [15:0] Rb_Data;	// RF B Side Data

	// internal wires
	logic [15:0] W_Data;		// RAM Input Write Data
	logic [15:0] R_Data;		// RAM Output Read Data
	
	// RAM
	RAM RAM_inst(
	        .address(D_Addr), 
	        .clock(Clock), 
	        .data(W_Data), 
	        .wren(D_W_En), 
	        .q(R_Data)
	        );
	
	// initialize Register File
	RegisterFile unit0(
	                .Clk(Clock), 
	                .Wren(RF_W_en), 
	                .WrAddr(RF_W_Addr), 
	                .WrData(R_Data), 
	                .RdAddrA(RF_Ra_Addr), 
	                .RdAddrB(RF_Rb_Addr), 
	                .RdDataA(Ra_Data), 
	                .RdDataB(Rb_Data)
	                );
	
 endmodule 

 // testbench
 module RegRam_tb();

	// input
	logic Clock;				// System Clock
	logic D_W_En;				// RAM Write Enable
	logic RF_W_en;				// RF Write Enable
	logic [3:0] RF_W_Addr;	// RF Write Address
	logic [3:0] RF_Ra_Addr;	// RF A Side Address
	logic [3:0] RF_Rb_Addr;	// RF B Side Address
	logic [7:0] D_Addr;		// RAM Address
	
	// output
	logic [15:0] Ra_Data;	// RF A Side Data
	logic [15:0] Rb_Data;	// RF B Side Data
	
	// internal wires
   logic [15:0] SumData;	// Used for display

	// DUT instantiation
   RegRam DUT(
				Clock, 
				D_Addr, 
				D_W_En, 
				RF_W_Addr, 
				RF_W_en, 
				RF_Ra_Addr, 
				RF_Rb_Addr, 
				Ra_Data, 
				Rb_Data
				);
    
	 // System Clock
    always begin 
		Clock =1'b0; #10;
		Clock =1'b1; #10;
    end 
    
    initial begin
		RF_W_en = 1'b1; 		// initialize RF_W_en to high
		
		D_Addr = 8'd0; 		// Get preloaded data from RAM
		RF_W_Addr = 4'd0; 	// Set RF write address
		D_W_En = 1'b1; 		// Set D_W_En to high
		RF_Ra_Addr = 4'd0;	// Set RF_Ra_Addr to 0000
		
		@(posedge Clock) $display("reading RAM %d", DUT.R_Data);
		#21; 
		D_Addr = 8'd1; 		// Get preloaded data from RAM
		RF_W_Addr = 4'd1; 	// Set RF write address
		#41;
		
		RF_Ra_Addr = 4'd0;	// Set A side address
		RF_Rb_Addr = 4'd1; 	// Set B side address
		#10; 
		
		SumData = Ra_Data + Rb_Data; // Add A and B side
		#20;
		$display("RF[0] + RF[1] = %d", SumData);
    
		$stop;
    
    end

endmodule
