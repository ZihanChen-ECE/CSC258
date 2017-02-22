module part2(SW, LEDR, HEX0, CLOCK_50);
	input [9:0] SW;
	input CLOCK_50;
	output [9:0] LEDR;
	output [0:6] HEX0;
	wire [3:0] d;
	wire par_load, enable, reset_n;
	wire [1:0] ctr;
	assign d[3:0] = SW[5:2];
	assign par_load = SW[7];
	assign enable = SW[8];
	assign reset_n = SW[9];
	assign ctr = SW[1:0];
	wire [3:0] Q;
	
	MyClock MC(CLOCK_50, ctr, d, par_load, enable, reset_n, Q);
	
	bcd7seg hex0(Q, HEX0);
	
	assign LEDR[3:0] = Q[3:0];
	assign LEDR[9:4] = 6'b0;
	

endmodule

module MyClock(CLK, ctr, d, par_load, enable, reset_n, q);
	input CLK, par_load, enable, reset_n;
	input [1:0] ctr;
	input [3:0] d;
	output reg [3:0] q;
	
	reg [27:0] fast_count;
	reg [27:0] MAX;
	
	always @(*)
	begin
		if(ctr == 2'b00)
			MAX <= 28'b0;
		else if (ctr == 2'b01)
			MAX <= 50000000;
		else if (ctr == 2'b10)
			MAX <= 100000000;
		else
			MAX <= 200000000;
		
	end
	
	always @(posedge CLK)
	begin
		if (!reset_n)
			fast_count <= 0;
		else
		begin
			if (fast_count == 0)
				fast_count <= MAX;
			else
				fast_count <= fast_count - 1'b1;
		end
	end
	
	always @(posedge CLK)
	begin
		if(reset_n == 1'b0)
		begin
			q <= 0;
		end
		else if (par_load == 1'b1)
			q <= d;
		else if (enable == 1'b1)
			if (fast_count == 0)
				begin 
					if (q == 4'b1111)
						q <= 0;
					else 
						q <= q+1'b1;
				
				end
	end
	
endmodule


module ToggleFF(T, Clock, Resetn, Q);
	input T, Clock, Resetn;
	output reg Q;
	
	always @(posedge Clock, negedge Resetn)
		if (Resetn == 1'b0)
			Q <= 1'b0;
		else if(T)
			Q <= ~Q;	

endmodule


module bcd7seg (B, H);
	input [3:0] B;
	output [0:6] H;

	wire [0:6] H;
	
	assign H[0] = ~((~B[2] & ~B[0]) | (~B[3] & B[1]) | (B[2] & B[1]) | (B[3] & ~B[0]) | (~B[3] & B[2] & B[0]) |(B[3] & ~B[2] & ~B[1]));
	
	assign H[1] = ~((~B[2] & ~B[0]) | (~B[2] & ~B[1]) | (~B[3] & ~B[1] & ~B[0]) | (B[3] & ~B[1] & B[0]) | (~B[3] & B[1] & B[0]));
	
	assign H[2] = ~((B[3] & ~B[2]) | (~B[1] & B[0]) | (~B[2] & ~B[1]) | (~B[3] & B[0]) | (~B[3] & B[2]));
	
	assign H[3] = ~((~B[3] & ~B[2] & ~B[0]) | (~B[2] & B[1] & B[0]) | (B[2] & ~B[1] & B[0]) | (B[3] & ~B[1]) | (B[2] & B[1] & ~B[0])); 
	
	assign H[4] = ~((~B[2] & ~B[0]) | (B[3] & B[2]) | (B[1] & ~B[0]) | (B[3] & B[1]));
	
	assign H[5] = ~((~B[1] & ~B[0]) | (B[3] & ~B[2]) |  (B[2] & ~B[0]) | (B[3] & B[1]) | (~B[3] & B[2])); 
	
	assign H[6] = ~((B[3] & ~B[2]) | (B[1] & ~B[0]) | (B[3] & B[0]) | (~B[3] & B[2] & ~B[1]) | (~B[2] & B[1]));
	
endmodule 