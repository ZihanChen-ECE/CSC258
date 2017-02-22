module part2(SW, LEDR);
	
	input [5:0] SW;
	output [9:0] LEDR;
	
	wire s1,s0,u,v,w,x;
	wire m_0, m_1, m_2;
	
	assign s1 = SW[1];
	assign s0 = SW[0];
	assign u = SW[2];
	assign v = SW[3];
	assign w = SW[4];
	assign x = SW[5];
	
	mux_2to1 M2(v,x,s1,m_2);
	mux_2to1 M1(u,w,s1,m_1);
	mux_2to1 M0(m_1,m_2,s0,m_0);
	
	assign LEDR[0] = m_0;
	
	assign LEDR[9:1] = 9'b0;
	
	

endmodule 


module mux_2to1(x,y,s,M);
	
	input x,y,s;
	output M;
	
	wire m_0, m_1;
	
	assign m_0 = (x & ~s);
	assign m_1 = (y & s);
	
	assign M = (m_0 | m_1);

endmodule 