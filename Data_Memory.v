/******************************************************************
* Description
*	This is the data memory for the RISC-V processor
*	1.0
* Author:
*	Dr. José Luis Pizano Escalante
* email:
*	luispizano@iteso.mx
* Date:
*	16/08/2021
******************************************************************/

module Data_Memory 
#(	parameter DATA_WIDTH = 32,
	parameter MEMORY_DEPTH = 8192
)
(
	input clk,
	input Mem_Write_i,	//selector escribir en memoria
	input Mem_Read_i,		//selector leer de la memoria
	input [DATA_WIDTH-1:0] Write_Data_i,	//Datos a escribir
	input [DATA_WIDTH-1:0]  Address_i,		//direccion

	output  [DATA_WIDTH-1:0]  Read_Data_o	//valor leido
);
	
wire [DATA_WIDTH-1 : 0] real_address;

//assign real_address = {2'b0, Address_i[15:2]};
assign real_address = {Address_i-32'h10010000};
	
	// Declare the RAM variable
reg [DATA_WIDTH-1:0] ram[MEMORY_DEPTH-1:0];
wire [DATA_WIDTH-1:0] read_data_aux;

	always @ (posedge clk)
	begin
		// Write
		if (Mem_Write_i)
			ram[real_address] <= Write_Data_i; // si guardo un elemento en un circuito combinacional se genera un latch
	end
	
	assign read_data_aux = ram[real_address];
	
  	assign Read_Data_o = { DATA_WIDTH { Mem_Read_i } } & read_data_aux;

endmodule
