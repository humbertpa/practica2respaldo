/******************************************************************
* Description
*	This is an 32-bit arithetic logic unit that can execute the next set of operations:
*		add

* This ALU is written by using behavioral description.
* Version:
*	1.0
* Author:
*	Dr. José Luis Pizano Escalante
* email:
*	luispizano@iteso.mx
* Date:
*	16/08/2021
******************************************************************/

module ALU 
(
	input [3:0] ALU_Operation_i,
	input signed [31:0] A_i,
	input signed [31:0] B_i,
	
	output reg Zero_o,
	output reg [31:0] ALU_Result_o
);


localparam ADD  = 4'b0000; //add,addi,jalr,lw
localparam SUB  = 4'b0001;
localparam OR   = 4'b0010;
localparam SLL  = 4'b0011;
localparam SRL  = 4'b0100;
localparam LUI  = 4'b0101;
localparam AND  = 4'b0110;
localparam XOR  = 4'b0111;
localparam BEQ  = 4'b1000;
localparam BNE  = 4'b1001;
localparam BLT  = 4'b1010;
localparam BGE  = 4'b1011;
localparam JAL  = 4'b1100;
localparam SW   = 4'b1101;

/*B_i es el immediate cuando ocurra la situación*/

   always @ (A_i or B_i or ALU_Operation_i)
     begin
		case (ALU_Operation_i)
		
		ADD	: ALU_Result_o = A_i + B_i;  // includes addi and jalr
		SUB	: ALU_Result_o = A_i - B_i;
		OR 	: ALU_Result_o = A_i | B_i;
		SLL	: ALU_Result_o = A_i << B_i[4:0];
		SRL	: ALU_Result_o = A_i >> B_i[4:0];
		LUI	: ALU_Result_o = {B_i,12'b0};
		AND	: ALU_Result_o = A_i & B_i;
		XOR	: ALU_Result_o = A_i ^ B_i;
		
		BEQ  	: ALU_Result_o = A_i == B_i;
		BNE  	: ALU_Result_o = A_i != B_i;
		BLT  	: ALU_Result_o = A_i < B_i;
		BGE  	: ALU_Result_o = A_i >= B_i;
		SW  	: ALU_Result_o = A_i + B_i;

		default:
			ALU_Result_o = 0;
		endcase // case(control)
		
		Zero_o = (ALU_Result_o == 0) ? 1'b1 : 1'b0;
		
     end // always @ (A or B or control)
endmodule // ALU