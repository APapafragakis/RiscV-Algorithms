#,asdkpoqwejoqhwe
		# register x26: i
		# register x27: a
		# register x28: n (a number from the table)

	.data
	.align 2
a:	.space 32
str_gn:	.asciz "Give me a number: "
str_nl:	.asciz "\n"

	.text

main:
	addi	x26, x0, 8	# i=8
	la	x27, a		# x27=a[]
	
get_numbers:
				# Print a prompt to get a number
	addi 	x17, x0, 4	# Code for print string
	la	x10, str_gn	# Gets the string we want to print
	ecall
				# Get a number with ecall
	addi	x17, x0, 5	# Code for read int
	ecall
	sw	x10, 0(x27)	# Stores the int to the table

	addi	x27, x27, 4	# Goes to the next available space in our table a[]
	addi	x26, x26, -1	# i--
	
	bne	x26, x0, get_numbers	# Go back if you haven't finished reading eight integers
	
	addi	x26, x0, 8	# i=8

print_numbers:
	addi	x27, x27, -4	# Goes to the previous space of the table
	
	lw	x28, 0(x27)	# n = a[i-1]
	
	addi 	x17, x0, 4	# Code for print string
	la	x10, str_nl	# Gets the string we want to print
	ecall
	
	add	x28, x28, x28
	add	x29, x28, x28
	add	x10, x28, x29
	
	addi	x17, x0, 1	# prints integer
	ecall
	
	addi	x26, x26, -1	# i--
	
	bne	x26, x0, print_numbers

j main
