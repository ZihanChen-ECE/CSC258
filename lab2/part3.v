module part3(SW,LEDR,HEX0);

	input [3:0] SW;
	output [9:0] LEDR;
	output [0:6] HEX0;
	
	assign LEDR[3:0] = SW;
	
	bcd7seg digit (SW[3:0], HEX0);
	
	
	assign LEDR[9:4] = 6'b0;


endmodule



module bcd7seg (B, H);
	input [3:0] B;
	output [0:6] H;

	wire [0:6] H;

	/*
	 *       0  
	 *      ---  
	 *     |   |
	 *    5|   |1
	 *     | 6 |
	 *      ---  
	 *     |   |
	 *    4|   |2
	 *     |   |
	 *      ---  
	 *       3  
	 */
	// B  H
	// ----------
	// 0  0000001;
	// 1  1001111;
	// 2  0010010;
	// 3  0000110;
	// 4  1001100;
	// 5  0100100;
	// 6  0100000;
	// 7  0001111;
	// 8  0000000;
	// 9  0000100;
	assign H[0] = (~B[3] & B[2] & ~B[1] & ~B[0]) | (~B[3] & ~B[2] & ~B[1] & B[0]);
	assign H[1] = (B[2] & ~B[1] & B[0]) | (B[2] & B[1] & ~B[0]);
	assign H[2] = (~B[2] & B[1] & ~B[0]);
	assign H[3] = (~B[3] & ~B[2] & ~B[1] & B[0]) | (~B[3] & B[2] & ~B[1] & ~B[0]) | 
		(~B[3] & B[2] & B[1] & B[0]);
	assign H[4] = (~B[1] & B[0]) | (~B[3] & B[0]) | (~B[3] & B[2] & ~B[1]);
	assign H[5] = (B[1] & B[0]) | (~B[2] & B[1]) | (~B[3] & ~B[2] & B[0]);
	assign H[6] = (B[2] & B[1] & B[0]) | (~B[3] & ~B[2] & ~B[1]);
endmodule