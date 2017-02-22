module part3(SW, LEDR, KEY, HEX0,HEX1, HEX2,HEX3,HEX4,HEX5);
	input [7:0] SW;
	input [3:0] KEY;
	output [9:0] LEDR;
	output [0:6] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	

	//wire[7:0] ALUout;
	reg [7:0] ALUout;
	wire[2:0] operand;
	wire KEY2, KEY1, KEY0;
	assign KEY2 = KEY[2];
	assign KEY1 = KEY[1];
	assign KEY0 = KEY[0];
	assign operand = {KEY2, KEY1, KEY0};
	
	wire [3:0] A, B;
	assign A = SW[3:0];
	assign B = SW[7:4];
	wire [3:0] w_out0, w_out1;
	wire co1, co0;
	
	reg [6:0] signal;
	
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
				
			5: begin
				ALUout = {7'b0, ~(^ {A, B})};
				end
				
			default: ALUout = 0;

		endcase
	end
	
	Fourbits_fullAdder A0(A, 4'b0001, 1'b0, w_out0, co0);
	Fourbits_fullAdder A1(A, B, 1'b0, w_out1, co1);

	
	assign LEDR[7:0] = ALUout[7:0];
	assign LEDR[9:8] = 2'b0;
	
	// set Hex with ALUout
	
	bcd7seg hex0(A, HEX0);
	bcd7seg hex2(B, HEX2);
	bcd7seg hex1(4'b0, HEX1);
	bcd7seg hex3(4'b0, HEX3);
	bcd7seg hex4(ALUout[3:0], HEX4);
	bcd7seg hex5(ALUout[7:4], HEX5);
	
	
endmodule 

//module ShowInput(A,B, sig, ALUout);
//	input [3:0] A, B;
//	input sig;
//	output [7:0] ALUout;
//	reg[7:0] ALUout1;
//	
//	always @(*)
//	begin
//		if(sig)
//			ALUout1 = {B,A};
//	end
//	assign ALUout = ALUout1;
//	
//endmodule
//
//module allZero(A, B, sig, ALUout);
//	input [3:0] A, B;
//	input sig;
//	output [7:0] ALUout;
//	wire [7:0] comAB;
//	reg res;
//	assign comAB = {B,A};
//	
//	always @(*)
//	begin
//		if (sig)
//		begin
//			if (comAB == 8'b00000000)
//				res = 1'b0;
//			else
//				res = 1'b1;
//		end
//		
//	end
//
//	assign ALUout[0] = res;
//	assign ALUout[7:1] = 7'b0;
//		
//	
//endmodule
//
//module XOR_OR(A, B, sig, ALUout);
//	input [3:0] A, B;
//	input sig;
//	output [7:0] ALUout;
//	reg [3:0] ALUlow, ALUhigh;
//	
//	always @(*)
//	begin
//		if (sig)
//		begin
//			ALUlow = ( A & ~B ) | ( ~A & B );
//			ALUhigh = A | B;
//		
//		end
//		
//	end
//	
//	assign ALUout[3:0] = ALUlow[3:0];
//	assign ALUout[7:4] = ALUhigh[3:0];
//
//endmodule
//
//
//module Always_fullAdder(A,B,sig,ALUout);
//	input [3:0] A, B;
//	input sig;
//	output [7:0] ALUout;
//	
//	reg [7:0] res;
//	
//	always @(*)
//	begin
//		if (sig)
//		begin
//			res = A+B;
//			res[7:5] = 3'b0;
//			
//		end
//	end
//	
//	assign ALUout = res;
//	
//endmodule
//
//
//module setZero(sig,Aout);
//	input sig;
//	output[3:0] Aout;
//	assign Aout = ~sig & Aout;
//endmodule
//
///*
//module A_add_by_one(A, Aout);
//	input [3:0] A;
//	output [7:0] Aout;
//	wire [3:0] AoutLow, B;
//	wire co;
//	wire cin;
//	assign cin = 1'b0;
//	assign B = 4'b0;
//	
//	Fourbits_fullAdder(A, B, cin, AoutLow, co)
//	
//	assign Aout[3:0] = AoutLow[3:0];
//	assign Aout[4] = co;
//	assign Aout[7:5] = 3'b0;
//	
//endmodule
//*/
//
//module CASE01(A, B, sig, Aout);
//	input [3:0] A, B;
//	input [1:0] sig;
//	output [7:0] Aout;
//	wire [3:0] AoutLow, newB;
//	wire co;
//	wire cin;
//	assign cin = 1'b0 & sig[0];
//	assign newB = B & sig[1];
//	
//	Fourbits_fullAdder(A, B, cin, AoutLow, co);
//	
//	assign Aout[3:0] = AoutLow[3:0];
//	assign Aout[4] = co;
//	assign Aout[7:5] = 3'b0;
//
//endmodule

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