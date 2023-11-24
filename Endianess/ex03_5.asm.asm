#3.5 Askisi 
        # register x1: x (the address of the string)
       
    .data
	.align 2	# ASCII character	|    binary	|	hex	|
str_a:	.ascii "a"	#	a		|   01100001	|	61	|
	.align 2	#			|		|		|
str_b:	.ascii "b"	#	b		|   01100010	|	62	|
	.align 2	#	...		|      ...	|	...	|
str_z:	.ascii "z"	#	z		|   01111010	|	7a	|
	.align 2	#			|		|		|
str_A:	.ascii "A"	#	A		|   01000001   	|	41	|
	.align 2	#			|		|		|
str_B:	.ascii "B"	#	B		|   01000010	|	42	|
	.align 2	#	...		|      ...      |	...	|	
str_Z:	.ascii "Z"	#	Z		|   01011010	|	5A	|
	.align 2	#			|		|		|
str_0:	.ascii "0"      #	0		|   00110000	|	30	|         
	.align 2	#			|   		|		|
str_1:	.ascii "1"	#	1		|   00110001	|	31	|
	.align 2	#	...		|      ...	|	...	|
str_xyz:.asciz "xyz"	#	9		|     1001 	| 	39      |
			
			# H omoiomorfia einai pws oloi oi arithmoi aujanontai kata mia monada 
			
			
			#	Little Endian
			#	/0  z  y  x
			#	00  7a 79 78 (hex)
			#	7*16^5 + 10*16^4 + 7*16^3 + 9*16^2 + 7*16^1 + 8*16^0
			#	8026488 (dec)
			
			#	Big Endian
			#	x  y  z  /0
			#	78 79 7a 00 (hex)
			#	7*16^7 + 8*16^6 + 7*16^5 + 9*16^4 + 7*16^3 + 10*16^2 + 0*16^1 + 0*16^0
			#	2021227008 (dec)
    
    .text

main:
	la	x1, str_xyz	# loads the string
	addi	x17, x0, 1	# prints the string as an integer
	lw	x10, 0(x1)	
	ecall
