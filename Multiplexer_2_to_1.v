/******************************************************************
* Description
*	This is a 2 to 1 multiplexer that can be parameterized in its bit-width.
*	1.0
* Author:
*	Dr. José Luis Pizano Escalante
* email:
*	luispizano@iteso.mx
* Date:
*	16/08/2021
******************************************************************/

module Multiplexer_2_to_1
#(
	parameter NBits = 32 // el tamño en bits de los datos
)
(
	input Selector_i,
	input [NBits-1:0] Mux_Data_0_i,
	input [NBits-1:0] Mux_Data_1_i,
	
	output reg [NBits-1:0] Mux_Output_o

);
// cualquier comparacion que requiera de varias lineas va dentro de un always
// si no se espesifica un flanco se activa la condicion a partir de cualquier cambio de valor
	always@(Selector_i ,Mux_Data_1_i ,Mux_Data_0_i) begin
		if(Selector_i)
			Mux_Output_o = Mux_Data_1_i;
		else
			Mux_Output_o = Mux_Data_0_i;
	end

endmodule