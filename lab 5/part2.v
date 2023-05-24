module part2(SW, HEX0, CLOCK_50);
	input CLOCK_50;
	input [9:0] SW;
	output [6:0] HEX0;

	wire [1:0] Speed;
	wire Reset;
	wire [27:0] w1;
	wire [3:0] Q;
	
	assign Reset = SW[9];
	assign Speed = SW[1:0];

	Ratedivider r1(CLOCK_50, Reset, Speed ,w1);
	Displaycounter d1(CLOCK_50, Reset, Speed, w1, Q);
	hex_decoder h1(Q, HEX0);
endmodule

module Displaycounter(ClockIn, Reset, Speed, enable, q);
	input ClockIn, Reset;
	input [1:0] Speed;
	output reg [3:0] q;
	input [27:0] enable;

	always@(posedge ClockIn)
	begin
		if(Reset == 1'b1)
			q <= 0;
		else if (enable == 27'b0)
		begin
			if (q == 4'b1111)
				q<= 0;
			else 
				q<= q+1;
		end
		end
	endmodule

module Ratedivider(ClockIn, Reset, Speed, tick);
input ClockIn, Reset;
input [1:0] Speed;
output reg [27:0] tick;
reg [27:0] q;

always@(*)
case(Speed[1:0])
2'b00: q = 27'b0;
2'b01: q = 49999999; 
2'b10: q = 99999999; 
2'b11: q = 199999999; 
default: q = 27'b0;
endcase

always@(posedge ClockIn) 
begin
if (Reset == 1'b1)
tick <= 27'b0;
else if (tick == 27'b0)
tick <= q;
else 
tick <= tick - 1;
end
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
