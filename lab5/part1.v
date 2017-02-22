module part1(SW, KEY, LEDR, HEX0, HEX1);
	input [9:0] SW;
	input [0:0] KEY;
	output [9:0] LEDR;
	output [0:6] HEX0, HEX1;
	wire [7:0] Q;
	fullbitCounter fC0(SW[0], KEY[0], SW[1], Q[7:0]);
	bcd7seg hex0( Q[3:0], HEX0);
	bcd7seg hex1( Q[7:4], HEX1);
	assign LEDR[7:0] = Q[7:0];
	assign LEDR[9:8] = 2'b0;

endmodule


module fullbitCounter(Enable, Clock, Clear_b, Q);
	input Enable, Clock, Clear_b;
	output [7:0] Q;
	wire Qtemp;
	wire [6:0] Q_;
	bitCounter bA0(Enable, Clock, Clear_b, Q[0]);
	assign Q_[0]=Q[0]&Enable;
	
	bitCounter bA1(Q_[0] , Clock, Clear_b, Q[1]);
	assign Q_[1]=Q_[0]&Q[1];
	
	bitCounter bA2(Q_[1], Clock, Clear_b, Q[2]);
	assign Q_[2]=Q_[1]&Q[2];
	
	bitCounter bA3(Q_[2], Clock, Clear_b, Q[3]);
	assign Q_[3]=Q_[2]&Q[3];
	
	bitCounter bA4(Q_[3], Clock, Clear_b, Q[4]);	
	assign Q_[4]=Q_[3]&Q[4];
	
	bitCounter bA5(Q_[4], Clock, Clear_b, Q[5]);
	assign Q_[5]=Q_[4]&Q[5];
	
	bitCounter bA6(Q_[5], Clock, Clear_b, Q[6]);
	assign Q_[6]=Q_[5]&Q[6];
	
	ToggleFF FF0(Q_[6], Clock, Clear_b, Q[7]);
	
endmodule


module bitCounter(Enable, Clock, Clear_b, Q);
	input Enable, Clock, Clear_b;
	output Q;
	//wire Qtemp;
	ToggleFF TFF(Enable, Clock, Clear_b, Q);
	

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