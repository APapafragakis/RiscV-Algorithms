# RISC-V Multi-threaded Task Scheduler

A sophisticated cooperative multitasking scheduler implementation written entirely in RISC-V assembly language. This project demonstrates advanced systems programming concepts including task scheduling, context switching, system calls, and memory management.

## Features

- **Cooperative Multitasking**: Priority-based task scheduling with voluntary yielding
- **System Call Interface**: Complete system call framework with 8 different syscalls
- **Memory Management**: Simple bump allocator for dynamic memory allocation
- **Context Switching**: Full register context preservation and restoration
- **Task Control Blocks**: Sophisticated task state management
- **Priority Scheduling**: Tasks are scheduled based on configurable priorities
- **Demo Applications**: Includes Fibonacci calculator, prime number generator, and demo tasks

## Architecture

### Task Control Block (TCB) Structure
```
Offset 0:  Stack Pointer
Offset 4:  Task State (0=READY, 1=RUNNING, 2=BLOCKED, 3=TERMINATED)
Offset 8:  Task ID
Offset 12: Priority (0=highest, 255=lowest)
Offset 16: Time Quantum
Offset 20: Next TCB pointer
```

### System Calls
| ID | Name | Purpose |
|----|------|---------|
| 0 | sys_exit | Terminate current task |
| 1 | sys_yield | Voluntarily yield CPU |
| 2 | sys_sleep | Sleep for N ticks (TODO) |
| 3 | sys_malloc | Allocate memory |
| 4 | sys_free | Free memory (TODO) |
| 5 | sys_print | Print string |
| 6 | sys_create_task | Create new task |
| 7 | sys_get_task_id | Get current task ID |

## Building and Running

### Prerequisites
- RISC-V toolchain (riscv64-unknown-elf-gcc)
- RISC-V simulator (QEMU, Spike, or similar)
- Make

### Build Commands
```bash
# Assemble the scheduler
riscv64-unknown-elf-as -march=rv32i -mabi=ilp32 -o scheduler.o scheduler.s

# Link (if using with C runtime)
riscv64-unknown-elf-ld -o scheduler scheduler.o

# Run with QEMU
qemu-riscv32 scheduler

# Or with Spike
spike --isa=rv32i scheduler
```

### Alternative Build with GCC
```bash
# Using GCC for assembly
riscv64-unknown-elf-gcc -march=rv32i -mabi=ilp32 -nostdlib -T custom.ld -o scheduler scheduler.s
```

## Testing

The scheduler creates four demo tasks:
1. **Demo Task 1**: Prints messages 5 times then exits
2. **Demo Task 2**: Counts down from 10 then exits  
3. **Fibonacci Task**: Calculates Fibonacci numbers up to F(15)
4. **Prime Task**: Generates prime numbers up to 100

## Educational Value

This project demonstrates:

### Low-Level Concepts
- **Assembly Programming**: Complex RISC-V assembly with multiple functions
- **Stack Management**: Manual stack frame setup and cleanup
- **Register Usage**: Proper calling convention adherence
- **Memory Layout**: Data section organization and heap management

### Operating System Concepts
- **Process Scheduling**: Priority-based cooperative scheduling
- **Context Switching**: Register state preservation
- **System Calls**: User-kernel interface implementation
- **Memory Management**: Dynamic allocation strategies
- **Inter-Process Communication**: Task queuing mechanisms

### Computer Architecture
- **Pipeline Considerations**: Instruction ordering and hazards
- **Memory Hierarchy**: Stack vs heap vs data segments
- **Instruction Set Architecture**: RISC-V ISA utilization
- **Control Flow**: Conditional branches and function calls

## Customization

### Adding New Tasks
```assembly
my_custom_task:
    li a7, 7                # Get task ID
    ecall
    mv s0, a0
    
    # Your task logic here
    
    li a7, 0                # Exit when done
    ecall
```

### Creating Tasks in Main
```assembly
la a0, my_custom_task
li a1, 30               # Priority 30
jal ra, create_task
```

### Adding New System Calls
1. Add function pointer to `syscall_table`
2. Implement the system call function
3. Update documentation

## Future Enhancements

- [ ] Preemptive scheduling with timer interrupts
- [ ] Advanced memory management (free, garbage collection)
- [ ] Inter-task communication (semaphores, message passing)
- [ ] File system interface
- [ ] Network stack integration
- [ ] Debugging and profiling tools
- [ ] Multi-core support

## Learning Objectives

After studying this code, you should understand:
- How operating systems manage multiple tasks
- The mechanics of context switching
- System call implementation details
- Memory management strategies
- Assembly language programming techniques
- RISC-V architecture specifics

## Code Structure

- **Initialization**: `scheduler_init`, `_start`
- **Task Management**: `create_task`, `enqueue_task`, `dequeue_task`
- **Scheduling**: `scheduler_start`, `context_switch`
- **System Calls**: `syscall_handler`, `sys_*` functions
- **Memory Management**: `allocate_memory`
- **Demo Tasks**: `demo_task_1`, `demo_task_2`, `fibonacci_task`, `prime_task`

---

**Note**: This is a educational implementation. Production operating systems require additional complexity including interrupt handling, virtual memory, and hardware abstraction layers.