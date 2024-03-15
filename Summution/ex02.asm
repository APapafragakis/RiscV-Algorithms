# Compute s = 1 + 2 + 3 + ... + (n - 1), for n >= 2
# Registers:
# x26: n
# x27: s
# x28: i

.data
# Initialize data memory with the strings needed:
str_n: .asciz "n = "
str_s: .asciz " s = "
str_nl: .asciz "\n"

.text
# Program memory:
main:
    # (1) PRINT A PROMPT:
    addi x17, x0, 4   # Environment call code for print_string
    la x10, str_n     # Load address of string
    ecall             # Print the string from str_n

    # (2) READ n (MUST be n >= 2 -- not checked!):
    addi x17, x0, 5   # Environment call code for read_int
    ecall             # Read a line containing an integer
    add x26, x10, x0  # Copy returned int from x10 to n

    # (3) INITIALIZE s and i:
    add x27, x0, x0   # s = 0
    addi x28, x0, 1   # i = 1

loop: # (4) LOOP starts here
    add x27, x27, x28 # s = s + i
    addi x28, x28, 1  # i = i + 1
    bne x28, x26, loop # Repeat while (i != n)
# LOOP ENDS HERE

    # (5) PRINT THE RESULT:
    addi x17, x0, 4   # Environment call code for print_string
    la x10, str_s     # Load address of string
    ecall             # Print the string from str_s

    addi x17, x0, 1   # Environment call code for print_int
    add x10, x27, x0  # Copy argument s to x10
    ecall             # Print the integer in x10 (s)

    addi x17, x0, 4   # Environment call code for print_string
    la x10, str_nl    # Load address of string
    ecall             # Print a new-line

    # (6) START ALL OVER AGAIN (infinite loop)
    j main            # Unconditionally jump back to main
