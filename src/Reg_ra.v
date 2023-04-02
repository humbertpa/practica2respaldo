/******************************************************************
* Descripcion: 
*  Registro especial para ra
* Author:
*	Humberto Peñuelas
* email:
*	is723382@iteso.mx
* Date:
*	02/04/2023
******************************************************************/
module Reg_ra
#(
    parameter N = 32
)
(
    input clk,
    input reset,
    input enable,
    input [N-1:0] DataInput,
    output reg [N-1:0] DataOutput
);

reg [N-1:0] stored_val;

always @(posedge clk, negedge reset) begin
    if (!reset) begin
        stored_val <= 0;
    end
    else if (enable && DataInput != 32'bz) begin
        stored_val <= DataInput;
		  DataOutput <= stored_val;
    end
	 else begin
		DataOutput <= stored_val;
	 end
	 	
end



endmodule