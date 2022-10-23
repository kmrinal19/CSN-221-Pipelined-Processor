#include <string>
#include <unordered_map>

#ifndef INSTRUCTION_H
#define INSTRUCTION_H

#define R_TYPE 0
#define LW 1
#define SW 2
#define BEQ 3
#define ADDI 4
#define J 5

#define ADD 0
#define MUL 2

const std::unordered_map<std::string, unsigned short> OPCODE_MAP = {
    {"ADD", R_TYPE},
    {"MUL", R_TYPE},
    {"BEQ", BEQ},
    {"ADDI", ADDI},
    {"J", J},
    {"LW", LW},
    {"SW", SW},
};

const std::unordered_map<std::string, unsigned short> FUNCTION_MAP = {
    {"ADD", ADD},
    {"MUL", MUL},
};

extern std::unordered_map<std::string, unsigned int> LABEL_MAP;

class Instruction {
    public:
        Instruction(unsigned short instruction_opcode);
        static Instruction* find_class_and_parse(std::string raw_instruction);
        virtual unsigned int parse() = 0;
        unsigned short get_instruction_opcode();
    private:
        unsigned short instruction_opcode;
};

class RInstruction: public Instruction {
    public:
        RInstruction(short opcode_type, std::vector<std::string> instruction_params, unsigned short functionj);
        unsigned int parse();
    private:
        unsigned short rs;
        unsigned short rt;
        unsigned short rd;
        unsigned short function;
};

class IInstruction: public Instruction {
    public:
        IInstruction(short opcode_type, std::vector<std::string> operands);
        unsigned int parse();
    private:
        unsigned short rs;
        unsigned short rt;
        std::string address;
};

class UJInstruction: public Instruction {
    public:
        UJInstruction(short opcode_type, std::vector<std::string> operands);
        unsigned int parse();
    private:
    //changed short to int
        unsigned int address;
};

#endif
