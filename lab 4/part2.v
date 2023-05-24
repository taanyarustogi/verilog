`timescale 1ns / 1ns // `timescale time_unit/time_precision

module lab4Part3 (SW, KEY, LEDR, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5);
	input [9:0] SW;
	input [3:0] KEY;
	output [9:0] LEDR;
	output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	wire[7:0] ALUout;
	assign LEDR=ALUout;
	
	part2 u0(.Clock(KEY[0]), .Reset_b(SW[9]), .Data(SW[3:0]), .Function(~KEY[3:1]), .ALUout(ALUout));
	hex_decoder h0 (.c(SW[3:0]), .display(HEX0));
	hex_decoder h1 (.c(4'b0000), .display(HEX2));
	hex_decoder h2 (.c(4'b0000), .display(HEX1));
	hex_decoder h3 (.c(4'b0000), .display(HEX3));
	hex_decoder h4 (.c(ALUout[3:0]), .display(HEX4));
	hex_decoder h5 (.c(ALUout[7:4]), .display(HEX5));

endmodule 



module part2(Clock, Reset_b, Data, Function, ALUout);
	
	input [3:0] Data;
	input [2:0] Function;
	input Clock, Reset_b;
	output reg [7:0] ALUout;
	reg [7:0] out;
	//wire [3:0] A,B;
	wire [3:1] Fcn;
	wire [4:0] addOut;
	//assign A = Data;
	//assign B = out [3:0];
	assign Fcn = Function;

	fulladder_4bit a1({Data, ALUout[3:0]}, addOut[4:0]);

	always @(posedge Clock)
	begin
		if (Reset_b == 1'b0)
			ALUout <= 8'b0;
		else
			ALUout <= out;
	end
	
	always @(*)
	begin
		case (Fcn)
			3'b000: out = {3'b000,addOut[4:0]};
			3'b001: out = Data + ALUout[3:0];
			3'b010: out = {{4{out[3]}},ALUout};
			3'b011: out = {{7{1'b0}}, |{Data,ALUout[3:0]}};
			3'b100: out = {{7{1'b0}}, &{Data,ALUout[3:0]}};
			3'b101: out = ALUout[3:0]<<Data;
			3'b110: out = Data * ALUout[3:0];
			3'b111: out = ALUout;
			default: ALUout = 8'b0;
		endcase
	end
	
endmodule

module fulladder_4bit(input [7:0]in, output [4:0]out);
wire w0, w1, w2;
fullAdder u0 (in[0], in[4], 1'b0, w0, out[0]);
fullAdder u1 (in[1], in[5], w0, w1, out[1]);
fullAdder u2 (in[2], in[6], w1, w2, out[2]);
fullAdder u3 (in[3], in[7], w2, out[4], out[3]);
endmodule


module fullAdder(b,a,c_in,c_out,s);

input b,a,c_in;
output s, c_out;

assign s = (a ^ b ^ c_in);
assign c_out = ((a & b) | (a & c_in) | (b & c_in));

endmodule


module hex_decoder (c, display);
input [3:0] c;
output [6:0] display;

assign display[0] = !((c[3]|c[2]|c[1]|!c[0]) & (c[3]|!c[2]|c[1]|c[0]) &
(!c[3]|c[2]|!c[1]|!c[0]) & (!c[3]|!c[2]|c[1]|!c[0]));

assign display[1] = !((c[3]|!c[2]|c[1]|!c[0]) & (c[3]|!c[2]|!c[1]|c[0]) &
(!c[3]|c[2]|!c[1]|!c[0]) & (!c[3]|!c[2]|c[1]|c[0]) &
(!c[3]|!c[2]|!c[1]|c[0]) & (!c[3]|!c[2]|!c[1]|!c[0]));

assign display[2] = !((c[3]|c[2]|!c[1]|c[0]) & (!c[3]|!c[2]|c[1]|c[0]) &
(!c[3]|!c[2]|!c[1]|c[0]) & (!c[3]|!c[2]|!c[1]|!c[0]));

assign display[3] = !((c[3]|c[2]|c[1]|!c[0]) & (c[3]|!c[2]|c[1]|c[0]) &
(c[3]|!c[2]|!c[1]|!c[0]) & (!c[3]|c[2]|c[1]|!c[0]) &
(!c[3]|c[2]|!c[1]|c[0]) & (!c[3]|!c[2]|!c[1]|!c[0]));

assign display[4] = !((c[3]|c[2]|c[1]|!c[0]) & (c[3]|c[2]|!c[1]|!c[0]) &
(c[3]|!c[2]|c[1]|c[0]) & (c[3]|!c[2]|c[1]|c[0]) &
(c[3]|!c[2]|c[1]|!c[0]) & (c[3]|!c[2]|!c[1]|!c[0]) &
(!c[3]|c[2]|c[1]|!c[0]));

assign display[5] = !((c[3]|c[2]|c[1]|!c[0]) & (c[3]|c[2]|!c[1]|c[0]) &
(c[3]|c[2]|!c[1]|!c[0]) & (c[3]|!c[2]|!c[1]|!c[0]) &
(!c[3]|!c[2]|c[1]|!c[0]));

assign display[6] = !((c[3]|c[2]|c[1]|c[0]) & (c[3]|c[2]|c[1]|!c[0]) &
(c[3]|!c[2]|!c[1]|!c[0]) & (!c[3]|!c[2]|c[1]|c[0]));


endmodule