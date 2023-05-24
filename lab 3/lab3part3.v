module part3(a, b, Function, ALUout);
	input [3:0] a, b;
	input [2:0] Function;
	output [7:0] ALUout; 
	wire [3:0] w1, w2;

part2 u0(a, b, 0, w1, w2);
always @(*)
begin
	case(Function)
		‘d0: ALUout = {3’b0, c[3], w1};
		‘d1: ALUout = {4’b0, a} + {4’b0, b};
		‘d2: ALUout = {4{b[3], b}};
		‘d3: ALUout = {7’b0, | {a,b}};
		‘d4: ALUout = {7’b0, & {a, b}};
		‘d5: ALUout = {a, b}
		default: ALUout = 8’b0;
	endcase
end
endmodule
