module part3(clock, reset, ParallelLoadn, RotateRight, ASRight, Data_IN, Q);
	input clock, reset, ParallelLoadn, RotateRight, ASRight; 
	input [7:0] Data_IN;
	output [7:0] Q;
	wire w;
	mux_ff mf0 (.clock(clock), .reset(reset), .loadn(ParallelLoadn), .rotateright(RotateRight), .left(w[1]), .right(w[7]), .D(Data_IN[0]), .Q(Q[0]));
	mux_ff mf1 (.clock(clock), .reset(reset), .loadn(ParallelLoadn), .rotateright(RotateRight), .left(w[2]), .right(w[0]), .D(Data_IN[1]), .Q(Q[1]));
	mux_ff mf2 (.clock(clock), .reset(reset), .loadn(ParallelLoadn), .rotateright(RotateRight), .left(w[3]), .right(w[1]), .D(Data_IN[2]), .Q(Q[2]));
	mux_ff mf3 (.clock(clock), .reset(reset), .loadn(ParallelLoadn), .rotateright(RotateRight), .left(w[4]), .right(w[2]), .D(Data_IN[3]), .Q(Q[3]));
	mux_ff mf4 (.clock(clock), .reset(reset), .loadn(ParallelLoadn), .rotateright(RotateRight), .left(w[5]), .right(w[3]), .D(Data_IN[4]), .Q(Q[4]));
	mux_ff mf5 (.clock(clock), .reset(reset), .loadn(ParallelLoadn), .rotateright(RotateRight), .left(w[6]), .right(w[4]), .D(Data_IN[5]), .Q(Q[5]));
	mux_ff mf6 (.clock(clock), .reset(reset), .loadn(ParallelLoadn), .rotateright(RotateRight), .left(w[7]), .right(w[5]), .D(Data_IN[6]), .Q(Q[6]));
	mux_leftmost m0 (.clock(clock), .reset(reset), .loadn(ParallelLoadn), .rotateright(RotateRight), .left(w[8]), .right(w[6]), .D(Data_IN[7]), .Q(Q[7]), .ASRight(ASRight));
endmodule

module mux_leftmost(clk, reset, left, right, D, loadn, rotateright, Q, ASRight);
	input clk, reset, loadn, rotateright, ASRight;
	input left, right, D;
	output reg Q; 
	always @ (posedge clk) begin
		if (reset == 1'b1)
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

module mux_ff(rotateright, D, loadn, right, left, clock, reset, Q);
input right, left, rotateright, D, loadn, clock, reset;
output Q; 
wire rotatedata, datatodff;

mux2to1 M0(
.y(left)
.x(right)
.s(rotateright)
.m(rotatedata)
);
mux2to1 M1(
.y(rotatedata)
.x(D)
.s(loadn)
.m(datatodff)
);
flipflop  F0(
.D(datatodff)
.Q(Q)
.clock(clock)
.reset(reset)
);
endmodule

module flipflop(D, Q, clock, reset);
input D, clock, reset; 
output reg Q; 
always @ (posedge clock)
begin
if (reset == 1’b1)
Q <= 0;
else
Q <= D;
endmodule

module mux2to1(x, y, s, m);
input x, y, s;
output m; 
assign m = s ? y : x;
endmodule