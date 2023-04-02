/******************************************************************
* Description
*	This is the top-level of a RISC-V Microprocessor that can execute the next set of instructions:
*		add
*		addi
* This processor is written Verilog-HDL. It is synthesizabled into hardware.
* Parameter MEMORY_DEPTH configures the program memory to allocate the program to
* be executed. If the size of the program changes, thus, MEMORY_DEPTH must change.
* This processor was made for computer organization class at ITESO.
* Version:
*	1.0
* Author:
*	Dr. José Luis Pizano Escalante
* email:
*	luispizano@iteso.mx
* Date:
*	16/08/2021
******************************************************************/
// todos los archivos empiezan con module
module RISC_V_Single_Cycle // Los modulos son los componentes básicos de verilo parecido a las funciones
#( // el simbilo # dindica que son parametros
	// cuando hay uno lista de parametros todos llevan , excepto el último
	parameter PROGRAM_MEMORY_DEPTH = 64, // parametros este en particular nos permitiría cambiar la cantidad de palabras en la memoria
	parameter DATA_MEMORY_DEPTH = 128 //
)

(
	// Inputs
	// definicion de puertos
	// entrada input
	// salida output
	// entrada-salida bidireccional inout
	input clk,
	input reset

);
//******************************************************************/
//******************************************************************/

//******************************************************************/
//******************************************************************/
/* Signals to connect modules*/

/**Control**/

// señales de control de un bit que puden ser modificadas 
// puden tener cuatro valore 0 , 1 ,x y z x= no importa z = alta impedancia
wire alu_src_w;
wire reg_write_w;
wire mem_to_reg_w;
wire mem_write_w;
wire mem_read_w;
wire branch_w;
wire [2:0] alu_op_w;

/** Program Counter**/
wire [31:0] pc_plus_4_w;
wire [31:0] pc_next_w;
wire [31:0] pc_inc_w;
wire [31:0] pc_w;
wire [31:0] pc_addr_w;


/**Register File**/
wire [31:0] read_data_1_w;
wire [31:0] read_data_2_w;

/**Inmmediate Unit**/
wire [31:0] inmmediate_data_w;

/**ALU**/
wire [31:0] alu_result_w;
wire alu_zero;

/**Multiplexer MUX_DATA_OR_IMM_FOR_ALU**/
wire [31:0] read_data_2_or_imm_w;

/**Multiplexer MUX_ALU_OR_LOAD**/
wire [31:0] alu_load_result_w;

/**Multiplexer MUX_BRANCH**/
wire [31:0] inc_w;

/**Multiplexer MUX_PC_IMM**/
wire [31:0] rd_data_w;

/**ALU Control**/
wire [3:0] alu_operation_w;

/**Instruction Bus**/	
wire [31:0] instruction_bus_w;

/**DATA_MEMORY**/
wire [31:0] load_value_w;


//******************************************************************/
//******************************************************************/
//******************************************************************/
//******************************************************************/
//******************************************************************/

// instancias de los submodulos del proyecto donde se ejcutan y se les pasan valore
// reales,


// nombre del modulo al que estoy haciendo referencia
// debajo tiene los parametros que pueden o no ser modificadados si no se modifican quedan con el valor default de modulo original

Control
CONTROL_UNIT // debajo del nombre del modulo esta el nombre de la instancia debe ser unico
(
	/****/
	.OP_i(instruction_bus_w[6:0]),
	/** outputus**/
	.ALU_Op_o(alu_op_w),
	.ALU_Src_o(alu_src_w),
	.Reg_Write_o(reg_write_w),
	.Mem_to_Reg_o(mem_to_reg_w),
	.Mem_Read_o(mem_read_w),
	.Mem_Write_o(mem_write_w),
	.Branch_o(branch_w)
);


Program_Memory
#(
	.MEMORY_DEPTH(PROGRAM_MEMORY_DEPTH)
)
PROGRAM_MEMORY
(
	.Address_i(pc_addr_w),
	.Instruction_o(instruction_bus_w)
);




PC_Register
PC_0
(
	.clk(clk),
	.reset(reset),
	.Next_PC(pc_next_w),
	
	.PC_Value(pc_w)
);

Adder_32_Bits
PC_PLUS_4
(
// dentro de una instancia hay puertos a los que se hace referncia usando . y el nombe del puerto
// para conectarlo se conecta con paretensis (y el destino)
	.Data0(pc_w),
	.Data1(inc_w),
	
	.Result(pc_inc_w)
);

Adder_32_Bits
PC_PLUS_INIT
(

	.Data0(32'h400000),
	.Data1(pc_w),
	
	.Result(pc_addr_w)


);

//******************************************************************/
//******************************************************************/
//******************************************************************/
//******************************************************************/
//******************************************************************/



Register_File
REGISTER_FILE_UNIT
(
	.clk(clk),
	.reset(reset),
	.Reg_Write_i(reg_write_w),
	.Write_Register_i(instruction_bus_w[11:7]),
	.Read_Register_1_i(instruction_bus_w[19:15]), // destino en sw
	.Read_Register_2_i(instruction_bus_w[24:20]), // origen en sw
	.Write_Data_i(rd_data_w),
	.Read_Data_1_o(read_data_1_w),
	.Read_Data_2_o(read_data_2_w)

);



Immediate_Unit
IMM_UNIT
(  .op_i(instruction_bus_w[6:0]),
   .Instruction_bus_i(instruction_bus_w),
   .Immediate_o(inmmediate_data_w)
);



Multiplexer_2_to_1
#(
	.NBits(32)
)
MUX_DATA_OR_IMM_FOR_ALU
(
	.Selector_i(alu_src_w),
	.Mux_Data_0_i(read_data_2_w),
	.Mux_Data_1_i(inmmediate_data_w),
	
	.Mux_Output_o(read_data_2_or_imm_w)

);





ALU_Control
ALU_CONTROL_UNIT
(
	.funct7_i(instruction_bus_w[30]),
	.ALU_Op_i(alu_op_w),
	.funct3_i(instruction_bus_w[14:12]),
	.ALU_Operation_o(alu_operation_w)
);

ALU
ALU_UNIT
(
	.ALU_Operation_i(alu_operation_w),
	.A_i(read_data_1_w),
	.B_i(read_data_2_or_imm_w),
	.ALU_Result_o(alu_result_w),
	.Zero_o(alu_zero)
);


Data_Memory
DATA_MEMORY
(
	.clk(clk),
	.Mem_Write_i(mem_write_w),
	.Mem_Read_i(mem_read_w),
	.Write_Data_i(read_data_2_w),	
	.Address_i(alu_result_w),
	.Read_Data_o(load_value_w)
);

Multiplexer_2_to_1
#(
	.NBits(32)
)

MUX_ALU_OR_LOAD
(
	.Selector_i(mem_to_reg_w),
	.Mux_Data_0_i(alu_result_w),
	.Mux_Data_1_i(load_value_w),
	.Mux_Output_o(alu_load_result_w)

);

Multiplexer_2_to_1
#(
	.NBits(32)
)

MUX_ALU_LOAD_OR_BRANCH
(
	.Selector_i(!mem_to_reg_w && branch_w),
	.Mux_Data_0_i(alu_load_result_w),
	.Mux_Data_1_i(pc_inc_w),
	.Mux_Output_o(rd_data_w)
	
);


Multiplexer_2_to_1
#(
	.NBits(32)
)

MUX_BRANCH
(
	.Selector_i(branch_w && !reg_write_w && !alu_zero || branch_w && reg_write_w && !alu_src_w), // (branch && !jal &&  bool resultado de comparacion ) ? imm
	.Mux_Data_0_i(4),
	.Mux_Data_1_i(inmmediate_data_w),
	.Mux_Output_o(inc_w)
);

Multiplexer_2_to_1
#(
	.NBits(32)
)

MUX_JALR
(
	.Selector_i(reg_write_w && branch_w && alu_src_w),   // 
	.Mux_Data_0_i(pc_inc_w),
	.Mux_Data_1_i(alu_result_w),
	.Mux_Output_o(pc_next_w)
);










endmodule

