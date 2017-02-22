module part2(SW, LEDR, KEY, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5);
		input [9:0] SW;
		input [0:0] KEY;
		output [9:0] LEDR;
		output [0:6] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
		wire [3:0] A;
		assign A = SW[3:0];
		reg [3:0] B;
		wire[2:0] ALUfunction;
		assign ALUfunction = SW[7:5];
		wire reset_n;
		assign reset_n = SW[9];
		reg [7:0] ALUout;
		wire[7:0] ALUout1;
		
		always @(posedge KEY[0] or negedge reset_n)
		
		begin 
			if(reset_n == 0)
				ALUout <= 8'b0; 
			else
				begin
					ALUout <= ALUout1;				
				end
			B <= ALUout[3:0];
		end
		
		ALU A0(A, B, ALUfunction, ALUout1);
		
		assign LEDR[7:0] = ALUout[7:0];
		assign LEDR[9:8] = 2'b0;
	
		// set Hex with ALUout
		
		bcd7seg hex0(A, HEX0);		
		bcd7seg hex4(ALUout[3:0], HEX4);
		bcd7seg hex5(ALUout[7:4], HEX5);
		darkHEX dH1(HEX1);
		darkHEX dH2(HEX2);
		darkHEX dH3(HEX3);	
			
			

endmodule


module ALU(A, B, operand, ALUout1);
	input [3:0] A,B;
	input [2:0] operand;
	output [7:0] ALUout1;
	wire [3:0] w_out0, w_out1;
	wire co1, co0;
	reg [7:0] ALUout;
	
	always @(*)
	begin
		case (operand)
		
			0: begin
				ALUout = {3'b000, {co0, w_out0}};
				end
				
			1:	begin
				ALUout = {3'b000, {co1, w_out1}};
				end
				
			2: begin
				ALUout = A+B;
				end
				
			3: begin
				ALUout = {A ^ B, A | B};
				end
				
			4: begin
				ALUout = {7'b0,| {A, B}};
				end
				
			//5: begin
			//	ALUout = {7'b0, ~(^ {A, B})};
			//	end
			5: begin
				ALUout = B << A;
				end
			
			6: ALUout = B >> A;
			
			7: ALUout = A*B;
			
			default: ALUout = 0;

		endcase
	end
	
	Fourbits_fullAdder A0(A, 4'b0001, 1'b0, w_out0, co0);
	Fourbits_fullAdder A1(A, B, 1'b0, w_out1, co1);

	assign ALUout1 = ALUout;
endmodule


module Fourbits_fullAdder(a,b,cin,s,co);
	input [3:0] a, b;
	input cin;
	output [3:0] s;
	output co;
	
	wire [2:0] cm;
	
	
	Onebit_fullAdder fAdder0 (a[0],b[0],cin, s[0], cm[0]);
	Onebit_fullAdder fAdder1 (a[1],b[1],cm[0], s[1], cm[1]);
	Onebit_fullAdder fAdder2 (a[2],b[2],cm[1], s[2], cm[2]);
	Onebit_fullAdder fAdder3 (a[3],b[3],cm[2], s[3], co);
	
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

module darkHEX(H);
	output [0:6] H;
	assign H[0:6] = 7'b1;
	
endmodule