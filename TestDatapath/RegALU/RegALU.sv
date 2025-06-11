/*
 * TCES 330 Spring 2025
 * @author Ahmed Aljewad & Logan Black
 * @version 28 MAY 2025
 * Module to test Register File and ALU
 */
 
 `timescale 1 ps / 1 ps

 module RegALU(
			Clk, 
			ALU_s0, 
			RF_W_Addr, 
			RF_W_en, 
			RF_Ra_Addr, 
			RF_Rb_Addr, 
			ALU_result
			);

	// input
	input Clk;								//
	input RF_W_en;							//
	input [2:0] ALU_s0;					//
	input [3:0] RF_W_Addr;				//
	input [3:0] RF_Ra_Addr;				//
	input [3:0] RF_Rb_Addr;				//

	// output
	output logic [15:0] ALU_result;	//
	
	// internal wires
	logic [15:0] Ra_data;				//
	logic [15:0] Rb_data;				//
	logic [15:0] RF_W_data;				//

	assign ALU_result = RF_W_data;
	
	// instantiates Register File
	RegisterFile unit0(
						Clk, 
						RF_W_en, 
						RF_W_Addr, 
						RF_Ra_Addr, 
						RF_Rb_Addr, 
						RF_W_data, 
						Ra_data, 
						Rb_data
						);
	
	// instantiates ALU
	ALU unit1(
			Ra_data, 
			Rb_data, 
			ALU_s0, 
			RF_W_data
			);
	
 endmodule 

 module RegALU_tb();
	logic Clk;
	logic RF_W_en;
	logic [2:0] ALU_s0;
	logic [3:0] RF_W_Addr;
	logic [3:0] RF_Ra_Addr;
	logic [3:0] RF_Rb_Addr;
	logic [15:0] ALU_result;
	
    RegALU DUT(
				Clk, 
				ALU_s0, 
				RF_W_Addr, 
				RF_W_en, 
				RF_Ra_Addr, 
				RF_Rb_Addr, 
				ALU_result
				);
    
    
    always begin 
    Clk=1'b0; #10;
    Clk=1'b1; #10;
    end
    
    initial begin
    
    // Load 0 into register 0
    ALU_s0 = 3'd0;
	RF_W_en = 1'b1;
    RF_W_Addr = 4'd0;
	RF_Ra_Addr = 4'd0;
	RF_Rb_Addr = 4'd0;
    @(posedge Clk) $display("RF[0] now contains 0");
	
	// Load 0 into register 1
	@(negedge Clk);
    RF_W_Addr = 4'd1;

    @(posedge Clk) $display("RF[1] now contains 0");
	
	// Increment register 0 value by 1
	@(negedge Clk);
    ALU_s0 = 3'd7;
    RF_Ra_Addr = 4'd0;
    RF_W_Addr = 4'd0;
    @(posedge Clk) $display("RF[0] now contains 1");

	// Increment register 1 value by 1
	@(negedge Clk);
	ALU_s0 = 3'd1;
    RF_Ra_Addr = 4'd0;
	RF_Rb_Addr = 4'd1;
    RF_W_Addr = 4'd1;
    @(posedge Clk) $display("RF[1] now contains 1");
	
	// Add both register values
	@(negedge Clk);
	ALU_s0 = 3'd1;
    RF_Ra_Addr = 4'd0;
	RF_Rb_Addr = 4'd1;
    RF_W_Addr = 4'd2;
    @(posedge Clk) $display("RF[2] now contains 2");

	// Subtract
	@(negedge Clk);
	ALU_s0 = 3'd2;
    RF_Ra_Addr = 4'd2;
	RF_Rb_Addr = 4'd0;
    RF_W_Addr = 4'd2;
    @(posedge Clk) $display("RF[2] now contains 1");
        
        $stop;
    
    end

 endmodule
 