.data
str_gn:    .asciz "Give me a positive number. If the number is negative or zero then we stop inserting numbers to the table. "
str_pr:    .asciz "Give me a non negative number and I will print every number inside the table that is greater than the given number. "
str_nl:    .asciz "\n"

    .text
main:
        # Initializes dummy struct and pointers to the list
    addi     a7, zero, 9           # Set the code for sbrk
    addi     a0, zero, 8           # Set the bytes that I want to get from sbrk
    ecall                          # Saves 8 Bytes and returns a pointer to them in a0
    sw    zero, 0(a0)              # data=0
    sw    zero, 4(a0)              # nxt_Ptr=0
    add    s0, a0, zero            # Sets s0 to the start of the list
    add    s1, a0, zero            # Sets s1 to the end of the list

read:
        # Prints a prompt to get a number
    addi    a7, zero, 4            # Set the code for print strirng
    la      a0, str_gn             # Loads the address of the string
    ecall

        # Reads an int
    addi    a7, zero, 5            # Set the code for read int
    ecall                          # Reads int and saves it to a0

    bge    zero, a0, stop_read
    add    s2, a0, zero

    addi     a7, zero, 9           # Set the code for sbrk
    addi     a0, zero, 8           # Set the bytes that I want to get from sbrk
    ecall                          # Saves 8 Bytes and returns a pointer to them in a0
    sw    zero, 0(a0)              # data=0
    sw    zero, 4(a0)              # nxt_Ptr=0

    sw    s2, 0(s1)                # Stores the int to the last node of our table
    sw    a0, 4(s1)                # Connects the last node of our table to a new dummy node
    add    s1, zero, a0            # Sets the new last node of the table

    j    read
stop_read:
           # Prints a prompt to get a number
    addi    a7, zero, 4              # Set the code for print stirng
    la      a0, str_pr               # Loads the address of the string
    ecall

           # Reads an int
    addi    a7, zero, 5              # Set the code for read int
    ecall                            # Reads int and saves it to a0
    add    s1, zero, a0              # s1 = a0

    blt    s1, zero, stop_execution  # If int is lower than zero stop the execution

    add    s2, zero, s0              # Sets traverse pointer to the start of our list

print_loop:
    lw    t0, 0(s2)                  # t0 = s2->data

    bge    s1, t0,  skip             # if s1<t0 skip
            # Prints an int
    addi    a7, zero, 1              # Sets the code to print an int
    add    a0, zero, t0              # Stores the data of the current node of the list to a0 in order to be printed
    ecall                            # Prints the specified int
            # Sets the prompt to print a new line
    addi    a7, zero, 4              # Sets the code for print strirng
    la      a0, str_nl               # Loads the address of the string
    ecall                            # Prints a new line

skip:
    lw    t0, 4(s2)                  # Gets the pointer to the next node
    beq    t0, zero, finish_print    # If the pointer is null then finish printing
    add    s2, zero, t0              # s2 = s2 -> nxtPtr
    j    print_loop

finish_print:
    j    stop_read

stop_execution:
    addi    a7, zero, 10    	 # Sets the code for Exit
    ecall           		 # Exits the execution
