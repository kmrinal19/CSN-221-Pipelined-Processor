# CSN 221 Project - Multistaged Pipelined Processor

### Prerequisites
- C++ compiler (g++11 +)
- Verilog Compiler (Icarus)

### Steps to compile and run the project
- Clone the repository
```
git clone https://github.com/kmrinal19/CSN-221-Pipelined-Processor.git
cd CSN-221-Project
```
- Build the parser
```
make
```
- Write the assesmbly code in a file (say output.asm)
- Assemble the source code using our C++ parser
```
./bin/parser output.asm
```
- Compile the Verilog source code
```
iverilog -o pipeline pipeline.v
```
Run the project
```
vvp pipeline
```