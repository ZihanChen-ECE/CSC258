module part2(SW, LEDR);
	input [8:0] SW;
	output [9:0] LEDR;
	wire [3:0] a;
	wire [3:0] b;
	wire [3:0] s;
	wire [2:0] cm;
	wire ci, co;
	
	assign a = SW[3:0];
	assign b = SW[7:4];
	assign ci = SW[8];
	
	Onebit_fullAdder fAdder0 (a[0],b[0],ci, s[0], cm[0]);
	Onebit_fullAdder fAdder1 (a[1],b[1],cm[0], s[1], cm[1]);
	Onebit_fullAdder fAdder2 (a[2],b[2],cm[1], s[2], cm[2]);
	Onebit_fullAdder fAdder3 (a[3],b[3],cm[2], s[3], co);
	
	assign LEDR[3:0] = s[3:0];
	assign LEDR[4] = co;
	assign LEDR[9:5] = 5'b0;
	
	
	
	

endmodule


module Onebit_fullAdder(a,b,ci,s,co);
	input a,b,ci;
	output s, co;
	wire m;
	
	//XOR gate for a and b
	assign m = (~a & b) | (a & ~b);
	 
	//2 to 1 mux for m (as s), b (as x) and ci (as y)
	mux_2to1 mux0 (b, ci, m, co);
	
	//XOR gate for ci and m
	
	assign s = (~ci & m) | (ci & ~m);


endmodule

module mux_2to1(x,y,s,M);
	
	input x,y,s;
	output M;
	
	wire m_0, m_1;
	
	assign m_0 = (x & ~s);
	assign m_1 = (y & s);
	
	assign M = (m_0 | m_1);

endmodule 