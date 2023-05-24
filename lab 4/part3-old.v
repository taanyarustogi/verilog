module mux_ff(clk, reset, left, right, D, loadn, rotateright, Q);
	input clk, reset, loadn, rotateright;
	input left, right, D;
	output reg Q; 
	reg m; 
	always @ (posedge clk) begin
		if (reset == 1'b0)
			Q <= 1'b0;
		else if (loadn == 1'b0)
			Q <= D;
		else if (rotateright == 1'b0)
			m <= right;
		else
			m <= left;
	end
endmodule

module mux_leftmost(clk, reset, left, right, D, loadn, rotateright, Q, ASRight);
	input clk, reset, loadn, rotateright, ASRight;
	input left, right, D;
	output reg Q; 
	always @ (posedge clk) begin
		if (reset == 1'b0)
			Q <= 1'b0;
		else if (loadn == 1'b0)
			Q <= D;
		else if (rotateright == 1'b1)
			Q <= left;
		else if (ASRight == 1'b1)
			Q <= Q;
		else
			Q <= right;
	end
endmodule


module part3(clock, reset, ParallelLoadn, RotateRight, ASRight, Data_IN, Q);
	input clock, reset, ParallelLoadn, RotateRight, ASRight; 
	input [7:0] Data_IN;
	output [7:0] Q;
	mux_ff mf0 (.clk(clock), .reset(reset), .loadn(ParallelLoadn), .rotateright(RotateRight), .left(Q[7]), .right(Q[1]), .D(Data_IN[0]), .Q(Q[0]));
	mux_ff mf1 (.clk(clock), .reset(reset), .loadn(ParallelLoadn), .rotateright(RotateRight), .left(Q[0]), .right(Q[2]), .D(Data_IN[1]), .Q(Q[1]));
	mux_ff mf2 (.clk(clock), .reset(reset), .loadn(ParallelLoadn), .rotateright(RotateRight), .left(Q[1]), .right(Q[3]), .D(Data_IN[2]), .Q(Q[2]));
	mux_ff mf3 (.clk(clock), .reset(reset), .loadn(ParallelLoadn), .rotateright(RotateRight), .left(Q[2]), .right(Q[4]), .D(Data_IN[3]), .Q(Q[3]));
	mux_ff mf4 (.clk(clock), .reset(reset), .loadn(ParallelLoadn), .rotateright(RotateRight), .left(Q[3]), .right(Q[5]), .D(Data_IN[4]), .Q(Q[4]));
	mux_ff mf5 (.clk(clock), .reset(reset), .loadn(ParallelLoadn), .rotateright(RotateRight), .left(Q[4]), .right(Q[6]), .D(Data_IN[5]), .Q(Q[5]));
	mux_ff mf6 (.clk(clock), .reset(reset), .loadn(ParallelLoadn), .rotateright(RotateRight), .left(Q[5]), .right(Q[7]), .D(Data_IN[6]), .Q(Q[6]));
	mux_leftmost m0 (.clk(clock), .reset(reset), .loadn(ParallelLoadn), .rotateright(RotateRight), .left(Q[6]), .right(Q[0]), .D(Data_IN[7]), .Q(Q[7]), .ASRight(ASRight));
endmodule
