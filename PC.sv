module PC(Clk, Clr, Up, Addr);
	input Clk, Clr, Up;
	output logic [6:0] Addr;

	always_ff @(posedge Clk) begin 
	if (Clr) Addr <= 7'd0;
	
	else if (Up) begin
		if(Addr < 7'd127) Addr <= Addr + 1;
		else Addr <= 0;
	end

	end

endmodule

module PC_tb();
    logic Clk, Clr, Up;
    logic [6:0] Addr;
    
    PC DUT(Clk, Clr, Up, Addr);
    
    always begin 
    Clk=1'b0; #10;
    Clk=1'b1; #10;
    end
    
    initial begin
    Clr = 0; Up = 0; #20
    Up = 1; #20;
    $display("Address value = %d", Addr); #20;
    $display("Address value = %d", Addr);
    wait(Addr == 20);
    $display("Address is now %d", Addr);
    Clr = 1; #40;
    assert(Addr == 0) begin
    $display("Clear functionality works Address = %d", Addr);
    end else begin $display("Clear doesn't work :(");
    end
    
    $stop;
    end
    
endmodule
    