#include <bitset>
#include <string>
#include <vector>

#include "utils.h"
#include "instruction.h"

#include <iostream>

Instruction::Instruction(unsigned short instruction_opcode) : instruction_opcode(instruction_opcode) {}

unsigned short Instruction::get_instruction_opcode()
{
	return this->instruction_opcode;
}

Instruction *Instruction::find_class_and_parse(std::string raw_instruction)
{
	trim(raw_instruction);
	std::string opcode = "";
	for (auto c = raw_instruction.begin(); c != raw_instruction.end(); ++c)
	{
		if (*c == ' ')
		{
			int pos = c - raw_instruction.begin();
			int len = raw_instruction.length() - pos;
			raw_instruction = raw_instruction.substr(pos, len);
			break;
		}
		opcode += *c;
	}
	std::vector<std::string> split_instruction = split(raw_instruction, ',');
	// TODO: Handle error if opcode is invalid
	unsigned short opcode_type = OPCODE_MAP.at(opcode);
	if (opcode_type == R_TYPE)
	{
		Instruction *r_instruction = new RInstruction(opcode_type, split_instruction, FUNCTION_MAP.at(opcode));
		return r_instruction;
	}
	else if (opcode_type == J)
	{
		Instruction *j_instruction = new UJInstruction(opcode_type, split_instruction);
		return j_instruction;
	}
	else
	{
		Instruction *i_instruction = new IInstruction(opcode_type, split_instruction);
		return i_instruction;
	}
}
RInstruction::RInstruction(short opcode_type, std::vector<std::string> operands, unsigned short fn) : Instruction(opcode_type)
{
	// TODO: Handle errors for operands
	if (operands.size() == 3)
	{
		rs = parse_register_string(operands[1]);
		rt = parse_register_string(operands[2]);
		rd = parse_register_string(operands[0]);
		function = fn;
	}
}

unsigned int RInstruction::parse()
{
	unsigned int instruction(0);
	unsigned int opcode(get_instruction_opcode());
	instruction = (((opcode << 5 | this->rs) << 5 | this->rt) << 5 | this->rd) << 11 | this->function;
	return instruction;
}

IInstruction::IInstruction(short opcode_type, std::vector<std::string> operands) : Instruction(opcode_type)
{
	// TODO: Handle errors for operands
	if (operands.size() == 3)
	{
		rs = parse_register_string(operands[1]);
		rt = parse_register_string(operands[0]);
		address = operands[2];
	}
}

unsigned int IInstruction::parse()
{
	// TODO: Handle errors for instruction params
	unsigned short address_int;
	if(get_instruction_opcode()==BEQ){
			address_int = (unsigned short)LABEL_MAP[address];
		}
		else{
			address_int = (unsigned short)stoi(address);
	}
	unsigned int instruction(0);
	unsigned int opcode(get_instruction_opcode());
	instruction = ((opcode << 5 | this->rs) << 5 | this->rt) << 16 | address_int;
	return instruction;
}

UJInstruction::UJInstruction(short opcode_type, std::vector<std::string> operands) : Instruction(opcode_type)
{
	// TODO: Handle errors for operands
	if (operands.size() == 1)
	{
		address = LABEL_MAP[operands[0]];
	}
}

unsigned int UJInstruction::parse()
{
	unsigned int instruction(0);
	unsigned int opcode(get_instruction_opcode());
	instruction = opcode << 26 | this->address;

	return instruction;
}