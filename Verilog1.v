

module mux_bool
#(
	parameter Nbits = 32
)

(
	// a la izquierda de la señal va el ancho del bus
	input [Nbits - 1 : 0]data0,
	input [Nbits - 1 : 0]data1,
	input selec,
	output [Nbits - 1 : 0]datao

);
// el selector de un bit no pude realizar la operacion por si solo
// se utilizara el operador de repeticion
// {la cantidad de repeticciones{el valor a repetir de n bits }}
// ecuacciones boolenas
// comportamenteal 
// instanciacion

assign datao = {Nbits{~selec}}&data0 | {Nbits{selec}}&data1;

endmodule