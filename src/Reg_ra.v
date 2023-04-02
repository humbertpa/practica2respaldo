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
    output wire [N-1:0] DataOutput
);

reg [N-1:0] stored_val;

always @(posedge clk, negedge reset) begin
    if (!reset) begin
        stored_val <= 0;
    end
    else if (enable && DataInput != 0) begin
        stored_val <= DataInput;
    end
end

assign DataOutput = (DataInput != 0) ? DataInput : stored_val;


endmodule