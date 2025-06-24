# RISC-V Mandelbrot Set Generator
# Advanced RISC-V assembly program that generates ASCII art of the Mandelbrot fractal
# Uses fixed-point arithmetic for complex number calculations
# Demonstrates: loops, function calls, memory management, and mathematical operations

.data
    # Fixed-point scaling (16.16 format)
    SCALE:          .word 65536        # 2^16 for fixed-point arithmetic
    
    # Screen dimensions
    WIDTH:          .word 80
    HEIGHT:         .word 24
    MAX_ITER:       .word 100
    
    # Complex plane bounds (in fixed-point)
    MIN_REAL:       .word -131072      # -2.0 in 16.16 format
    MAX_REAL:       .word 65536        # 1.0 in 16.16 format  
    MIN_IMAG:       .word -78643       # -1.2 in 16.16 format
    MAX_IMAG:       .word 78643        # 1.2 in 16.16 format
    
    # Character palette for different iteration counts
    palette:        .string " .:-=+*#%@"
    palette_len:    .word 10
    
    # Output buffer
    output_buffer:  .space 2000        # 80x24 + newlines
    
    # Messages
    header_msg:     .string "RISC-V Mandelbrot Set Generator\n"
    footer_msg:     .string "\nGenerated using RISC-V assembly!\n"
    newline:        .string "\n"

.text
.globl _start

_start:
    # Print header
    la a0, header_msg
    jal print_string
    
    # Initialize variables
    li t0, 0                # y counter
    la t1, output_buffer    # output buffer pointer
    
outer_loop:
    # Check if y < HEIGHT
    lw t2, HEIGHT
    bge t0, t2, end_outer_loop
    
    li t3, 0                # x counter
    
inner_loop:
    # Check if x < WIDTH
    lw t4, WIDTH
    bge t3, t4, end_inner_loop
    
    # Convert screen coordinates to complex plane
    mv a0, t3               # x coordinate
    mv a1, t0               # y coordinate
    jal screen_to_complex
    
    # a0 = real part, a1 = imaginary part
    mv a2, a0               # real part of c
    mv a3, a1               # imaginary part of c
    
    # Calculate Mandelbrot iterations
    jal mandelbrot_iterate
    
    # Convert iteration count to character
    mv a0, a0               # iteration count
    jal iter_to_char
    
    # Store character in buffer
    sb a0, 0(t1)
    addi t1, t1, 1
    
    # Increment x counter
    addi t3, t3, 1
    j inner_loop
    
end_inner_loop:
    # Add newline to buffer
    li t5, 10               # ASCII newline
    sb t5, 0(t1)
    addi t1, t1, 1
    
    # Increment y counter
    addi t0, t0, 1
    j outer_loop
    
end_outer_loop:
    # Null terminate the buffer
    li t5, 0
    sb t5, 0(t1)
    
    # Print the generated fractal
    la a0, output_buffer
    jal print_string
    
    # Print footer
    la a0, footer_msg
    jal print_string
    
    # Exit program
    li a7, 93               # sys_exit
    li a0, 0                # exit code
    ecall

# Function: screen_to_complex
# Converts screen coordinates to complex plane coordinates
# Input: a0 = x, a1 = y
# Output: a0 = real part, a1 = imaginary part (both in fixed-point)
screen_to_complex:
    addi sp, sp, -16
    sw ra, 12(sp)
    sw s0, 8(sp)
    sw s1, 4(sp)
    sw s2, 0(sp)
    
    mv s0, a0               # save x
    mv s1, a1               # save y
    
    # Calculate real part: MIN_REAL + x * (MAX_REAL - MIN_REAL) / WIDTH
    lw t0, MAX_REAL
    lw t1, MIN_REAL
    sub t0, t0, t1          # range = MAX_REAL - MIN_REAL
    
    mul t0, s0, t0          # x * range
    lw t1, WIDTH
    div t0, t0, t1          # (x * range) / WIDTH
    lw t1, MIN_REAL
    add s2, t0, t1          # real = MIN_REAL + (x * range) / WIDTH
    
    # Calculate imaginary part: MIN_IMAG + y * (MAX_IMAG - MIN_IMAG) / HEIGHT
    lw t0, MAX_IMAG
    lw t1, MIN_IMAG
    sub t0, t0, t1          # range = MAX_IMAG - MIN_IMAG
    
    mul t0, s1, t0          # y * range
    lw t1, HEIGHT
    div t0, t0, t1          # (y * range) / HEIGHT
    lw t1, MIN_IMAG
    add s1, t0, t1          # imag = MIN_IMAG + (y * range) / HEIGHT
    
    mv a0, s2               # return real part
    mv a1, s1               # return imaginary part
    
    lw s2, 0(sp)
    lw s1, 4(sp)
    lw s0, 8(sp)
    lw ra, 12(sp)
    addi sp, sp, 16
    ret

# Function: mandelbrot_iterate
# Calculates number of iterations for Mandelbrot set
# Input: a2 = c_real, a3 = c_imag (in fixed-point)
# Output: a0 = iteration count
mandelbrot_iterate:
    addi sp, sp, -24
    sw ra, 20(sp)
    sw s0, 16(sp)
    sw s1, 12(sp)
    sw s2, 8(sp)
    sw s3, 4(sp)
    sw s4, 0(sp)
    
    mv s2, a2               # c_real
    mv s3, a3               # c_imag
    
    li s0, 0                # z_real = 0
    li s1, 0                # z_imag = 0
    li s4, 0                # iteration counter
    
mandelbrot_loop:
    # Check if iteration count >= MAX_ITER
    lw t0, MAX_ITER
    bge s4, t0, mandelbrot_done
    
    # Calculate z_real^2 and z_imag^2 (fixed-point multiplication)
    # z_real^2 = (z_real * z_real) >> 16
    mul t0, s0, s0
    lw t1, SCALE
    div t0, t0, t1          # z_real^2
    
    # z_imag^2 = (z_imag * z_imag) >> 16  
    mul t1, s1, s1
    lw t2, SCALE
    div t1, t1, t2          # z_imag^2
    
    # Check if |z|^2 > 4 (in fixed-point: > 4 * 65536 = 262144)
    add t2, t0, t1          # |z|^2 = z_real^2 + z_imag^2
    li t3, 262144           # 4.0 in fixed-point
    bgt t2, t3, mandelbrot_done
    
    # Calculate new z_imag = 2 * z_real * z_imag + c_imag
    mul t2, s0, s1          # z_real * z_imag
    slli t2, t2, 1          # 2 * z_real * z_imag
    lw t3, SCALE
    div t2, t2, t3          # normalize fixed-point
    add s1, t2, s3          # new z_imag
    
    # Calculate new z_real = z_real^2 - z_imag^2 + c_real
    sub t2, t0, t1          # z_real^2 - z_imag^2
    add s0, t2, s2          # new z_real
    
    # Increment iteration counter
    addi s4, s4, 1
    j mandelbrot_loop
    
mandelbrot_done:
    mv a0, s4               # return iteration count
    
    lw s4, 0(sp)
    lw s3, 4(sp)
    lw s2, 8(sp)
    lw s1, 12(sp)
    lw s0, 16(sp)
    lw ra, 20(sp)
    addi sp, sp, 24
    ret

# Function: iter_to_char
# Converts iteration count to ASCII character
# Input: a0 = iteration count
# Output: a0 = ASCII character
iter_to_char:
    lw t0, MAX_ITER
    beq a0, t0, iter_to_char_space
    
    # Scale iteration count to palette index
    lw t1, palette_len
    mul a0, a0, t1
    div a0, a0, t0          # index = (iter * palette_len) / MAX_ITER
    
    la t0, palette
    add t0, t0, a0
    lb a0, 0(t0)
    ret
    
iter_to_char_space:
    li a0, 32               # space character for points in the set
    ret

# Function: print_string
# Prints null-terminated string
# Input: a0 = string address
print_string:
    mv t0, a0
print_string_loop:
    lb t1, 0(t0)
    beqz t1, print_string_done
    
    # System call to write character
    li a7, 64               # sys_write
    li a0, 1                # stdout
    mv a1, t0               # character address
    li a2, 1                # length
    ecall
    
    addi t0, t0, 1
    j print_string_loop
    
print_string_done:
    ret