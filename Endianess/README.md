# Readme for Endianess and String Representation in RISC-V Assembly

## Description

This RISC-V assembly program demonstrates the little-endian and big-endian representations of the string "xyz" and prints its integer value.

## Code Overview

The code uses the following registers:

- `x1`: Holds the address of the string.
- `x10`: Temporary register for loading data.

The string representations for the characters 'a' to 'Z' and '0' to '9' are provided along with their corresponding ASCII values in binary and hexadecimal.

The code then loads the address of the string "xyz" into register x1, prints the string as an integer, and includes comments explaining the little-endian and big-endian representations.

## How to Run

1. Assemble the code using a RISC-V assembler.
2. Link the assembled code to generate an executable.
3. Run the executable on a RISC-V architecture.

Example Commands:

```bash
# Replace "program.s" with the actual filename
as -o program.o program.s
ld -o endian_program program.o
./endian_program
