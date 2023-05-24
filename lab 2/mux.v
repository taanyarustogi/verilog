`timescale 1ns / 1ns // `timescale time_unit/time_precision

//SW[2:0] data inputs
//SW[9] select signals

//LEDR[0] output display

module mux(LEDR, SW);
    input [9:0] SW;
    output [9:0] LEDR;

    mux2to1 u0(
        .x(SW[0]),
        .y(SW[1]),
        .s(SW[9]),
        .m(LEDR[0])
        );
endmodule

module mux2to1(x, y, s, m);

	input x, y, s;
	output m;

	wire w2, w3, w4;

	v7404 U1 (
		.pin1(s),
		.pin2(w2)
	);

	v7408 U2 (
		.pin1(w2),
		.pin2(x),
		.pin3(w3),
		.pin11(w4),
		.pin12(s),
		.pin13(y)
	);

	V7432 U3 (
		.pin1(w4),
		.pin2(w3),
		.pin3(m)
	);

endmodule 

