# Readme for Summation Program

## Description

This assembly program calculates the sum of integers from 1 to n-1, where n is an integer greater than or equal to 2. It utilizes the RISC-V assembly language and requires the use of registers x26 (for n), x27 (for the sum), and x28 (for the loop index).

## Instructions

1. **Build and Run:**
   - Assemble the program using a RISC-V assembler.
   - Link the assembled code to generate an executable.
   - Run the executable on a RISC-V architecture.

2. **Input:**
   - The program prompts the user to enter the value of n (must be greater than or equal to 2).

3. **Output:**
   - The program calculates and prints the sum of integers from 1 to n-1.

## Registers Used

- `x26`: Holds the value of n.
- `x27`: Accumulates the sum.
- `x28`: Used as a loop index.

## Program Flow

1. Display a prompt asking the user to enter the value of n.
2. Read the user input and store it in register `x26`.
3. Initialize the sum (`x27`) and loop index (`x28`).
4. Enter a loop that adds the loop index to the sum until the loop index equals n.
5. Print the calculated sum.
6. Repeat the process in an infinite loop.

## Files

- `main.s`: The main assembly code.
- `README.md`: This readme file.

## Usage

Make sure to have a RISC-V assembler and emulator installed. Assemble and run the program according to the instructions provided.

```bash
# Example commands (replace with actual commands for your setup)
as -o main.o main.s
ld -o summation_program main.o
./summation_program
