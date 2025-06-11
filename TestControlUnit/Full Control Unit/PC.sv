/*
 * TCES 330 Spring 2025
 * Project Files Control Unit PC
 * @author Ahmed Aljewad & Logan Black
 * @version 29 MAY 2025
 * PC module
 */
 
 `timescale 1 ps / 1 ps
 
module PC(Clk, Clr, Up, Addr);
	input Clk, Clr, Up;
	output logic [6:0] Addr;
    
    // Implement counter logic based on Up and Clear
	always_ff @(posedge Clk) begin 
	if (Clr) Addr <= 7'd0;
	
	else if (Up) begin
		if(Addr < 7'd127) Addr <= Addr + 1;
		else Addr <= 7'd0;
	end

	end

endmodule

//Testebench
module PC_tb();
    logic Clk, Clr, Up;
    logic [6:0] Addr;
    
    PC DUT(Clk, Clr, Up, Addr); // Main module instantiation
    
    always begin 
    Clk=1'b0; #10;
    Clk=1'b1; #10;
    end
    
    initial begin
    // Initilize Values
    Clr = 1'b0; Up = 1'b0; #20
    // Check that address increments
    Up = 1'b1; #20;
    $display("Address value = %d", Addr); #20;
    $display("Address value = %d", Addr);
    // Wait until address increments to 20
    wait(Addr == 20);
    $display("Address is now %d", Addr);
    // Check Clear functionality
    Clr = 1'b1; #40;
    assert(Addr == 0) begin
    $display("Clear functionality works Address = %d", Addr);
    end else begin $display("Clear doesn't work :(");
    end
    
    $stop;
    end

    
endmodule
    