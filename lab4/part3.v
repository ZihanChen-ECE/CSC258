module part3(SW, KEY, LEDR);
	input [9:0] SW;
	input [3:0] KEY;
	output [9:0] LEDR;
	
	wire load_n;
	assign load_n = KEY[1];
	wire shiftRight;
	assign shiftRight = KEY[2];
	wire [7:0] load_value;
	assign load_value = SW[7:0];
	wire ASR;
	assign ASR = KEY[3];
	wire clock;
	assign clock = KEY[0];
	wire reset_n;
	assign reset_n = SW[9];
	
	wire Qin;
	
	wire [7:0] Qout;
	assign Qin = ASR;
	
	SingleShift SS7(Qin, load_value[7], shiftRight, load_n, clock, reset_n, Qout[7]);
	SingleShift SS6(Qout[7], load_value[6], shiftRight, load_n, clock, reset_n, Qout[6]);
	SingleShift SS5(Qout[6], load_value[5], shiftRight, load_n, clock, reset_n, Qout[5]);
	SingleShift SS4(Qout[5], load_value[4], shiftRight, load_n, clock, reset_n, Qout[4]);
	SingleShift SS3(Qout[4], load_value[3], shiftRight, load_n, clock, reset_n, Qout[3]);
	SingleShift SS2(Qout[3], load_value[2], shiftRight, load_n, clock, reset_n, Qout[2]);
	SingleShift SS1(Qout[2], load_value[1], shiftRight, load_n, clock, reset_n, Qout[1]);
	SingleShift SS0(Qout[1], load_value[0], shiftRight, load_n, clock, reset_n, Qout[0]);
	
	assign LEDR[7:0] = Qout[7:0];
	assign LEDR[8] = clock;
	assign LEDR[9] = ASR;

endmodule


module SingleShift(Qin, load_value, shift, load_n, clock, reset_n, Qout);
	input Qin, load_value, shift, load_n, clock, reset_n;
	output Qout;
	wire qin1;
	assign qin1 = Qout;
	wire m0, m1;
	
	mux_2to1 mux0(qin1, Qin, shift, m0);
	mux_2to1 mux1(load_value, m0, load_n, m1);
	
	flipflop FF(m1, Qout, clock, reset_n);
	assign D = m1;

endmodule


module flipflop (D, Q, Clock, Resetn);
	input D, Clock, Resetn;
	output reg Q;
	
	always @(posedge Clock)
		if (Resetn  == 1'b0)	// synchronous clear
			Q <= 1'b0;
		//else if (Setn  == 1'b0)	// synchronous set
		//	Q <= 1'b1;
		else
			Q <= D;
endmodule

module mux_2to1(x,y,s,M);
	
	input x,y,s;
	output M;
	
	wire m_0, m_1;
	
	assign m_0 = (x & ~s);
	assign m_1 = (y & s);
	
	assign M = (m_0 | m_1);

endmodule 
