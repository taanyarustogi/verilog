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




