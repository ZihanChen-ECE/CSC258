module PART1(SW, LEDR);

	output [9:0] LEDR;
	input [2:0] SW;
	
	wire x,y,s;
	wire m_0, m_1;
	
	assign s = SW[0];
	assign x = SW[1];
	assign y = SW[2];
	
	assign m_0 = (x & ~s);
	assign m_1 = (y & s);
	
	assign LEDR[0] = (m_0 | m_1);
	assign LEDR[9:1] = 9'b0;
	
endmodule