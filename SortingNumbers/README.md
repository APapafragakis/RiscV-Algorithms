# Readme for RISC-V Assembly Program

## Description

This RISC-V assembly program reads positive numbers from the user until a non-positive number is entered. Then, it prompts the user to input a non-negative number and prints all the numbers in the table greater than the provided number.

## Code Overview

### Registers Used

- `a7`: System call code.
- `a0`: Argument register for system calls.
- `s0`, `s1`, `s2`: General-purpose registers used as pointers and counters.
- `t0`: Temporary register for loading data from memory.

### Data Section

- `str_gn`: Prompt string for getting a positive number.
- `str_pr`: Prompt string for getting a non-negative number to print values.
- `str_nl`: Newline character for formatting.

### Program Flow

1. **Reading Numbers:**
   - Initializes a dummy struct and pointers to the list.
   - Prompts the user for a positive number until a non-positive number is entered.
   - Dynamically allocates memory for each entered number and adds it to the linked list.

2. **Printing Numbers:**
   - Prompts the user for a non-negative number.
   - Prints all numbers in the linked list that are greater than the provided number.

3. **System Calls:**
   - Uses system calls (`sbrk` for memory allocation, `print_string` for prompts, `read_int` for reading integers, `print_int` for printing integers, and `exit` to terminate the program).

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
