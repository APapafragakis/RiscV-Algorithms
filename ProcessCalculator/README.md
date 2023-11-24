# Readme for RISC-V Assembly Program

## Description

This RISC-V assembly program demonstrates a simple process of reading eight integers from the user, storing them in an array, and then printing each integer multiplied by three.

## Code Overview

### Registers Used

- `x26`: Loop index (`i`).
- `x27`: Points to the array `a[]` to store and later print numbers.
- `x28`: Temporary register to store the current number from the array.

### Data Section

- `.space 32`: Allocates 32 bytes for the array `a[]`.
- `str_gn`: Contains the prompt string asking the user for a number.
- `str_nl`: Contains the newline character for formatting.

### Program Flow

1. **Getting Numbers:**
   - Initializes the loop index (`i`) to 8.
   - Prompts the user for a number, reads it, and stores it in the array `a[]`.
   - Continues until 8 numbers are obtained.

2. **Printing Numbers:**
   - Prints a newline character for formatting.
   - Multiplies each number in the array by three and prints the result.
   - Continues until all numbers in the array are processed.

3. **Infinite Loop:**
   - Jumps back to the beginning to repeat the process.

## How to Run

1. Assemble the code using a RISC-V assembler.
2. Link the assembled code to generate an executable.
3. Run the executable on a RISC-V architecture.

Example Commands:

```bash
# Replace "program.s" with the actual filename
as -o program.o program.s
ld -o my_program program.o
./my_program
