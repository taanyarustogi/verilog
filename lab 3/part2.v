

module v7404 (pin1, pin3, pin5, pin9, pin11, pin13, 
		pin2, pin4, pin6, pin8, pin10, pin12);

	input pin1, pin3, pin5, pin9, pin11, pin13;
	output pin2, pin4, pin6, pin8, pin10, pin12; 

	assign pin2 = ! (pin1);
	assign pin4 = ! (pin3); 
	assign pin6 = ! (pin5);
	assign pin8 = ! (pin9);
	assign pin10 = ! (pin11);
	assign pin12 = ! (pin13);

endmodule // v7404

module v7408 (pin1, pin3, pin5, pin9, pin11, pin13, 
		pin2, pin4, pin6, pin8, pin10, pin12);

	input pin1, pin2, pin4, pin5, pin9, pin10, pin12, pin13;
	output pin3, pin6, pin8, pin11;

	assign pin3 = (pin1 & pin2);
	assign pin6 = (pin4 & pin5); 
	assign pin8 = (pin9 & pin10);
	assign pin11 = (pin12 & pin13);

endmodule // v7408

module v7432 (pin1, pin3, pin5, pin9, pin11, pin13, 
		pin2, pin4, pin6, pin8, pin10, pin12);

	input pin1, pin2, pin4, pin5, pin9, pin10, pin12, pin13;
	output pin3, pin6, pin8, pin11;

	assign pin3 = (pin1 | pin2);
	assign pin6 = (pin4 | pin5); 
	assign pin8 = (pin9 | pin10);
	assign pin11 = (pin12 | pin13);

endmodule // v7432

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

	v7432 U3 (
		.pin1(w4),
		.pin2(w3),
		.pin3(m)
	);

endmodule 


