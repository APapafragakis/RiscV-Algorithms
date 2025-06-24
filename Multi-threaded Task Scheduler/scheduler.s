# RISC-V Multi-threaded Task Scheduler Implementation
# Advanced RISC-V Assembly Programming Project
# Implements cooperative multitasking, system calls, and memory management

.section .data
    # Task Control Block (TCB) structure
    # Offset 0: Stack Pointer
    # Offset 4: Task State (0=READY, 1=RUNNING, 2=BLOCKED, 3=TERMINATED)
    # Offset 8: Task ID
    # Offset 12: Priority (0=highest, 255=lowest)
    # Offset 16: Time Quantum
    # Offset 20: Next TCB pointer
    
    .align 4
scheduler_data:
    current_task:       .word 0          # Pointer to current TCB
    task_queue_head:    .word 0          # Head of ready queue
    task_queue_tail:    .word 0          # Tail of ready queue
    next_task_id:       .word 1          # Next available task ID
    system_ticks:       .word 0          # System timer ticks
    
    # Memory management
    heap_start:         .word 0x10010000 # Start of heap
    heap_current:       .word 0x10010000 # Current heap pointer
    heap_end:           .word 0x10020000 # End of heap (64KB)
    
    # Task stacks (4KB each)
    .align 12
task_stacks:
    .space 0x4000                        # Stack for task 1
    .space 0x4000                        # Stack for task 2
    .space 0x4000                        # Stack for task 3
    .space 0x4000                        # Stack for task 4
    
    # System call jump table
    .align 4
syscall_table:
    .word sys_exit          # 0: Exit task
    .word sys_yield         # 1: Yield CPU
    .word sys_sleep         # 2: Sleep for N ticks
    .word sys_malloc        # 3: Allocate memory
    .word sys_free          # 4: Free memory
    .word sys_print         # 5: Print string
    .word sys_create_task   # 6: Create new task
    .word sys_get_task_id   # 7: Get current task ID
    
    # Test strings and data
    hello_msg:      .string "Task %d: Hello from RISC-V!\n"
    tick_msg:       .string "System tick: %d\n"
    switch_msg:     .string "Context switch to task %d\n"
    exit_msg:       .string "Task %d terminated\n"
    
.section .text
.global _start

_start:
    # Initialize the scheduler
    jal ra, scheduler_init
    
    # Create initial tasks
    la a0, demo_task_1
    li a1, 10               # Priority 10
    jal ra, create_task
    
    la a0, demo_task_2
    li a1, 20               # Priority 20
    jal ra, create_task
    
    la a0, fibonacci_task
    li a1, 15               # Priority 15
    jal ra, create_task
    
    la a0, prime_task
    li a1, 25               # Priority 25
    jal ra, create_task
    
    # Start the scheduler
    jal ra, scheduler_start
    
    # Should never reach here
    li a7, 93               # Exit system call
    li a0, 0
    ecall

# Initialize the scheduler system
scheduler_init:
    addi sp, sp, -16
    sw ra, 12(sp)
    
    # Initialize heap pointer
    la t0, heap_start
    lw t1, 0(t0)
    la t0, heap_current
    sw t1, 0(t0)
    
    # Clear task queues
    la t0, current_task
    sw zero, 0(t0)
    la t0, task_queue_head
    sw zero, 0(t0)
    la t0, task_queue_tail
    sw zero, 0(t0)
    
    lw ra, 12(sp)
    addi sp, sp, 16
    ret

# Create a new task
# a0 = task function address
# a1 = priority
# Returns: task ID in a0
create_task:
    addi sp, sp, -32
    sw ra, 28(sp)
    sw s0, 24(sp)
    sw s1, 20(sp)
    sw s2, 16(sp)
    
    mv s0, a0               # Save function address
    mv s1, a1               # Save priority
    
    # Allocate TCB (24 bytes)
    li a0, 24
    jal ra, allocate_memory
    mv s2, a0               # Save TCB pointer
    
    # Allocate and initialize stack
    la t0, next_task_id
    lw t1, 0(t0)
    addi t2, t1, 1
    sw t2, 0(t0)            # Increment next task ID
    
    # Calculate stack address (task_stacks + (task_id - 1) * 0x4000)
    addi t1, t1, -1
    slli t1, t1, 14         # Multiply by 0x4000
    la t0, task_stacks
    add t0, t0, t1
    addi t0, t0, 0x4000     # Point to top of stack
    
    # Initialize TCB
    sw t0, 0(s2)            # Stack pointer
    li t0, 0
    sw t0, 4(s2)            # State = READY
    lw t0, next_task_id
    addi t0, t0, -1
    sw t0, 8(s2)            # Task ID
    sw s1, 12(s2)           # Priority
    li t0, 100
    sw t0, 16(s2)           # Time quantum
    sw zero, 20(s2)         # Next pointer
    
    # Setup initial stack frame
    lw t0, 0(s2)            # Get stack pointer
    addi t0, t0, -128       # Reserve space for context
    sw s0, 124(t0)          # Save function address as return address
    sw t0, 0(s2)            # Update stack pointer in TCB
    
    # Add to ready queue
    mv a0, s2
    jal ra, enqueue_task
    
    lw t0, 8(s2)            # Return task ID
    mv a0, t0
    
    lw s2, 16(sp)
    lw s1, 20(sp)
    lw s0, 24(sp)
    lw ra, 28(sp)
    addi sp, sp, 32
    ret

# Add task to ready queue
enqueue_task:
    addi sp, sp, -16
    sw ra, 12(sp)
    
    la t0, task_queue_head
    lw t1, 0(t0)
    beqz t1, first_task
    
    # Add to tail
    la t0, task_queue_tail
    lw t1, 0(t0)
    sw a0, 20(t1)           # Set next pointer of current tail
    sw a0, 0(t0)            # Update tail pointer
    j enqueue_done
    
first_task:
    # First task in queue
    la t0, task_queue_head
    sw a0, 0(t0)
    la t0, task_queue_tail
    sw a0, 0(t0)
    
enqueue_done:
    lw ra, 12(sp)
    addi sp, sp, 16
    ret

# Remove and return next task from ready queue
dequeue_task:
    la t0, task_queue_head
    lw a0, 0(t0)
    beqz a0, dequeue_done
    
    # Update head pointer
    lw t1, 20(a0)           # Get next pointer
    sw t1, 0(t0)            # Update head
    
    # If queue becomes empty, clear tail
    bnez t1, dequeue_done
    la t0, task_queue_tail
    sw zero, 0(t0)
    
dequeue_done:
    ret

# Start the scheduler (main scheduling loop)
scheduler_start:
    addi sp, sp, -16
    sw ra, 12(sp)
    
scheduler_loop:
    # Get next task
    jal ra, dequeue_task
    beqz a0, scheduler_idle
    
    # Set as current task
    la t0, current_task
    sw a0, 0(t0)
    
    # Set task state to RUNNING
    li t0, 1
    sw t0, 4(a0)
    
    # Context switch to task
    jal ra, context_switch
    
    # Task returned, check if it should continue
    la t0, current_task
    lw a0, 0(t0)
    lw t1, 4(a0)            # Get task state
    li t2, 3                # TERMINATED
    beq t1, t2, task_terminated
    
    # Add back to ready queue if not terminated
    li t1, 0                # Set state to READY
    sw t1, 4(a0)
    jal ra, enqueue_task
    
task_terminated:
    j scheduler_loop
    
scheduler_idle:
    # No tasks to run, halt
    li a7, 93               # Exit system call
    li a0, 0
    ecall

# Context switch to task
context_switch:
    la t0, current_task
    lw t0, 0(t0)
    lw sp, 0(t0)            # Load task's stack pointer
    
    # Restore context (simplified - in real implementation would restore all registers)
    lw ra, 124(sp)
    addi sp, sp, 128
    
    # Jump to task
    jalr zero, ra, 0

# System call handler
syscall_handler:
    # Save caller's context
    addi sp, sp, -128
    sw ra, 124(sp)
    sw t0, 120(sp)
    sw t1, 116(sp)
    sw t2, 112(sp)
    sw a0, 108(sp)
    sw a1, 104(sp)
    sw a2, 100(sp)
    sw a3, 96(sp)
    
    # Update current task's stack pointer
    la t0, current_task
    lw t0, 0(t0)
    addi t1, sp, -128
    sw t1, 0(t0)
    
    # Dispatch system call
    slli t0, a7, 2          # Multiply by 4 for word offset
    la t1, syscall_table
    add t0, t1, t0
    lw t0, 0(t0)
    jalr ra, t0, 0
    
    # Restore context
    lw a3, 96(sp)
    lw a2, 100(sp)
    lw a1, 104(sp)
    lw a0, 108(sp)
    lw t2, 112(sp)
    lw t1, 116(sp)
    lw t0, 120(sp)
    lw ra, 124(sp)
    addi sp, sp, 128
    ret

# System call implementations
sys_exit:
    # Mark current task as terminated
    la t0, current_task
    lw t0, 0(t0)
    li t1, 3                # TERMINATED
    sw t1, 4(t0)
    
    # Return to scheduler
    j scheduler_loop

sys_yield:
    # Simply return to scheduler
    j scheduler_loop

sys_sleep:
    # TODO: Implement sleep functionality
    ret

sys_print:
    # Simple print implementation (using system call)
    li a7, 64               # Write system call
    li a0, 1                # STDOUT
    # a1 already contains string address
    # a2 already contains length
    ecall
    ret

sys_get_task_id:
    la t0, current_task
    lw t0, 0(t0)
    lw a0, 8(t0)            # Return task ID
    ret

# Memory allocation (simple bump allocator)
allocate_memory:
    # a0 = size to allocate
    # Returns: pointer in a0
    la t0, heap_current
    lw t1, 0(t0)            # Current heap pointer
    add t2, t1, a0          # New heap pointer
    
    la t3, heap_end
    lw t3, 0(t3)
    bgt t2, t3, alloc_fail  # Check if out of memory
    
    sw t2, 0(t0)            # Update heap pointer
    mv a0, t1               # Return old heap pointer
    ret
    
alloc_fail:
    li a0, 0                # Return null on failure
    ret

# Demo Tasks
demo_task_1:
    li a7, 7                # Get task ID system call
    ecall
    mv s0, a0               # Save task ID
    
    li s1, 0                # Counter
task1_loop:
    # Print message
    li a7, 5                # Print system call
    la a0, hello_msg
    mv a1, s0
    ecall
    
    # Increment counter
    addi s1, s1, 1
    li t0, 5
    blt s1, t0, task1_continue
    
    # Exit after 5 iterations
    li a7, 0                # Exit system call
    ecall

task1_continue:
    # Yield CPU
    li a7, 1                # Yield system call
    ecall
    j task1_loop

demo_task_2:
    li a7, 7                # Get task ID system call
    ecall
    mv s0, a0               # Save task ID
    
    li s1, 10               # Counter (start from 10)
task2_loop:
    # Print message
    li a7, 5                # Print system call
    la a0, hello_msg
    mv a1, s0
    ecall
    
    # Decrement counter
    addi s1, s1, -1
    bgtz s1, task2_continue
    
    # Exit when counter reaches 0
    li a7, 0                # Exit system call
    ecall

task2_continue:
    # Yield CPU
    li a7, 1                # Yield system call
    ecall
    j task2_loop

# Fibonacci calculation task
fibonacci_task:
    li a7, 7                # Get task ID
    ecall
    mv s0, a0
    
    li s1, 1                # fib(n-2)
    li s2, 1                # fib(n-1)
    li s3, 2                # n
    
fib_loop:
    add s4, s1, s2          # fib(n) = fib(n-1) + fib(n-2)
    mv s1, s2               # Update fib(n-2)
    mv s2, s4               # Update fib(n-1)
    
    addi s3, s3, 1
    li t0, 15
    blt s3, t0, fib_continue
    
    li a7, 0                # Exit
    ecall
    
fib_continue:
    li a7, 1                # Yield
    ecall
    j fib_loop

# Prime number generation task
prime_task:
    li a7, 7                # Get task ID
    ecall
    mv s0, a0
    
    li s1, 2                # Current number to test
    
prime_loop:
    mv a0, s1
    jal ra, is_prime
    beqz a0, prime_next
    
    # Found a prime, could print it here
    
prime_next:
    addi s1, s1, 1
    li t0, 100
    blt s1, t0, prime_continue
    
    li a7, 0                # Exit
    ecall
    
prime_continue:
    li a7, 1                # Yield
    ecall
    j prime_loop

# Simple primality test
is_prime:
    # a0 = number to test
    # Returns: 1 if prime, 0 if not prime
    li t0, 2
    blt a0, t0, not_prime
    beq a0, t0, is_prime_yes
    
    # Check if even
    andi t1, a0, 1
    beqz t1, not_prime
    
    # Check odd divisors up to sqrt(n)
    li t0, 3
    mul t1, t0, t0
    
prime_test_loop:
    bgt t1, a0, is_prime_yes
    
    rem t2, a0, t0
    beqz t2, not_prime
    
    addi t0, t0, 2
    mul t1, t0, t0
    j prime_test_loop
    
is_prime_yes:
    li a0, 1
    ret
    
not_prime:
    li a0, 0
    ret

# System call wrapper macro would go here in a real implementation
# For now, tasks use ecall directly with appropriate a7 values