/*
 * TCES 330 Spring 2025
 * Project Files Register File
 * @authors Logan Black & Ahmehd Aljewad
 * @version 22 MAY 2025
 * The register file for the TCES 330 class project
 */
`timescale 1 ps / 1 ps
module RegisterFile(Clk, Wren, WrAddr, RdAddrA, RdAddrB, WrData, RdDataA, RdDataB);
	input Clk;					// system clock
	input Wren;					// write enable
	input [3:0] WrAddr;		// write address
	input [3:0] RdAddrA;		// A-side read address
	input [3:0] RdAddrB;		// B-side read address
	input [15:0] WrData;		// write data
	output [15:0] RdDataA;	// A-side read data
	output [15:0] RdDataB;	// B-side read data

	logic [15:0] regfile [0:15]; // 16 bits per register, 16 total registers

	// read the registers
	assign RdDataA = regfile[RdAddrA];
	assign RdDataB = regfile[RdAddrB];

	// write the registers
	always @(posedge Clk) begin
		if (Wren) begin
			regfile[WrAddr] <= WrData;
		end
	end

	endmodule

// Testbench
module RegisterFile_tb();
	logic clk;					// system clock
	logic wren;					// write enable
	logic [3:0] wraddr;		// write address
	logic [3:0] rdaddra;		// A-side read address
	logic [3:0] rdaddrb;		// B-side read address
	logic [15:0] wrdata;		// write data
	logic [15:0] rddataa;	// A-side read data
	logic [15:0] rddatab;	// B-side read data
	
	logic [4:0] counter;		// counter for testing

	// DUT initialization
	RegisterFile DUT(clk, wren, wraddr, rdaddra, rdaddra, wrdata, rddataa, rddatab);

	// system clock
	always begin
		clk = 1'b0; #10;
		clk = 1'b1; #10;
	end
	
	// test cases
	initial begin
	
		wren = 1'd1;							// write enable initialized high
		rdaddra = 4'd0; rdaddrb = 4'd0;	// read address a & b initialized to 0
		
		// loading values into register
		for (counter = 4'd0; counter <= 4'd15; counter++) begin
			wraddr = counter; wrdata = counter; #40;
		end
		
		wren = 1'd0;							// set write enable to low
		
		// reading values from register
		for (counter = 4'd0; counter <= 4'd15; counter++) begin
			rdaddra = counter; rdaddrb = counter; #40;
			$display("Register address A %d contains value %d", rdaddra, rddataa);
			$display("Register address B %d contains value %d", rdaddrb, rddatab);
			assert((rdaddra == counter) && (rddataa == counter) && (rdaddrb == counter) && (rddatab == counter)) begin
				$display("Register file OK!");
			end else begin
				$error("Register file FAILED!");
			end
			
		end

		$stop;
	end
 
endmodule
 