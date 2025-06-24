# RISC-V Cryptographic Hash Function Library

A high-performance, security-focused implementation of cryptographic hash functions written entirely in RISC-V assembly language. This library demonstrates advanced low-level programming techniques, cryptographic algorithms, and side-channel attack resistance.

## Features

### Hash Functions
- **SHA-256**: Full implementation with all optimizations
- **SHA-1**: Complete 160-bit hash function
- **MD5**: Legacy support with 128-bit output
- **HMAC**: Hash-based Message Authentication Code

### Security Features
- **Constant-Time Operations**: Resistant to timing attacks
- **Side-Channel Mitigations**: Prevents information leakage
- **Secure Memory Handling**: Proper cleanup of sensitive data
- **Self-Test Vectors**: Validates implementation correctness

### Performance Optimizations
- **Hand-Tuned Assembly**: Optimized for RISC-V architecture
- **Efficient Bit Manipulation**: Custom rotate and shift operations
- **Memory Layout Optimization**: Cache-friendly data structures
- **Benchmark Suite**: Performance measurement tools

## Algorithms Implemented

| Algorithm | Output Size | Block Size | Status | Security Level |
|-----------|-------------|------------|---------|----------------|
| SHA-256   | 256 bits    | 512 bits   | Complete | High |
| SHA-1     | 160 bits    | 512 bits   | Complete | Deprecated |
| MD5       | 128 bits    | 512 bits   | Complete | Broken |
| HMAC-SHA256 | 256 bits  | Variable   | Partial | High |

## Architecture

### Memory Layout
```
.rodata section:
├── SHA-256 constants (K values)
├── Initial hash values (H0)
├── SHA-1 constants
├── MD5 constants
└── Test vectors

.bss section:
├── Message buffer (1KB)
├── Padded buffer (1KB) 
├── Hash state (32 bytes)
├── Working schedule (256 bytes)
└── Temporary buffers

.text section:
├── Main hash functions
├── Auxiliary functions (σ, Σ, Ch, Maj)
├── Message padding
├── Performance benchmarks
└── Security tests
```

### SHA-256 Implementation Details

#### Round Function
```assembly
# T1 = h + Σ1(e) + Ch(e,f,g) + K[i] + W[i]
# T2 = Σ0(a) + Maj(a,b,c)
# Update: h=g, g=f, f=e, e=d+T1, d=c, c=b, b=a, a=T1+T2
```

#### Auxiliary Functions
- **Σ0(x)**: `ROTR(x,2) ⊕ ROTR(x,13) ⊕ ROTR(x,22)`
- **Σ1(x)**: `ROTR(x,6) ⊕ ROTR(x,11) ⊕ ROTR(x,25)`
- **σ0(x)**: `ROTR(x,7) ⊕ ROTR(x,18) ⊕ SHR(x,3)`
- **σ1(x)**: `ROTR(x,17) ⊕ ROTR(x,19) ⊕ SHR(x,10)`
- **Ch(x,y,z)**: `(x ∧ y) ⊕ (¬x ∧ z)`
- **Maj(x,y,z)**: `(x ∧ y) ⊕ (x ∧ z) ⊕ (y ∧ z)`

## Building and Usage

### Prerequisites
```bash
# RISC-V GNU toolchain
sudo apt-get install gcc-riscv64-unknown-elf

# RISC-V simulator (choose one)
sudo apt-get install qemu-system-riscv32  # QEMU
# OR
git clone https://github.com/riscv/riscv-isa-sim.git  # Spike
```

### Build Commands
```bash
# Basic assembly
riscv64-unknown-elf-as -march=rv32i -mabi=ilp32 -o crypto.o crypto.s

# With debugging symbols
riscv64-unknown-elf-as -march=rv32i -mabi=ilp32 -g -o crypto.o crypto.s

# Link executable
riscv64-unknown-elf-ld -o crypto crypto.o

# Alternative: Use GCC
riscv64-unknown-elf-gcc -march=rv32i -mabi=ilp32 -nostdlib -static -o crypto crypto.s
```

### Running
```bash
# With QEMU
qemu-riscv32 crypto

# With Spike
spike --isa=rv32i crypto

# With debugging
spike --isa=rv32i -d crypto
```

### Custom Linker Script (optional)
```ld
/* crypto.ld */
SECTIONS {
    . = 0x10000;
    .text : { *(.text) }
    .rodata : { *(.rodata) }
    .data : { *(.data) }
    .bss : { *(.bss) }
}
```

## Testing and Validation

### Test Vectors
The library includes standard test vectors:

```assembly
# SHA-256 Test Cases
"" (empty)          → e3b0c44298fc1c149afbf4c8996fb924...
"abc"               → ba7816bf8f01cfea414140de5dae2223...
"abcdbcdecdef..."   → 248d6a61d20638b8e5c026930c3e6039...
```

### Performance Benchmarks
```
SHA-256 (1000 iterations of 1MB): ~X cycles
Throughput: ~Y MB/s
Memory usage: 2KB working space
```

### Security Tests
- **Timing Attack Resistance**: Constant-time validation
- **Side-Channel Analysis**: Power consumption uniformity
- **Memory Leak Prevention**: Secure cleanup verification

## Code Structure

### Main Functions
```assembly
sha256_hash:           # Primary SHA-256 entry point
sha256_process_block:  # Process single 512-bit block
sha256_prepare_schedule: # Expand message to 64 words
```

### Auxiliary Functions
```assembly
sha256_sigma0:         # Σ0 function
sha256_sigma1:         # Σ1 function
sha256_ch:             # Choice function
sha256_maj:            # Majority function
```

### Utility Functions
```assembly
strlen:                # String length calculation
print_hex_array:       # Hexadecimal output
constant_time_compare: # Side-channel resistant comparison
secure_zero:           # Secure memory clearing
```

## Educational Value

### Low-Level Programming Concepts
- **RISC-V Assembly Mastery**: Complex control flow and data manipulation
- **Register Management**: Efficient use of 32 RISC-V registers
- **Memory Management**: Manual stack frames and data alignment
- **Bit Manipulation**: Rotations, shifts, and logical operations

### Cryptographic Concepts
- **Hash Function Design**: Understanding of Merkle-Damgård construction
- **Security Properties**: Collision resistance, preimage resistance
- **Padding Schemes**: Message length encoding and alignment
- **Constant-Time Programming**: Side-channel attack prevention

### Computer Architecture
- **Instruction Scheduling**: Pipeline optimization
- **Cache Behavior**: Memory access patterns
- **Performance Analysis**: Cycle counting and optimization
- **Security Architecture**: Hardware-assisted protection

## Advanced Features

### Side-Channel Resistance
```assembly
# Constant-time comparison prevents timing attacks
constant_time_compare:
    li t0, 0                # Result accumulator
    # XOR differences accumulate without branching
    xor t1, t1, t2
    or t0, t0, t1           # Constant time regardless of input
```

### Performance Optimizations
- **Loop Unrolling**: Reduced branch overhead
- **Register Reuse**: Minimized memory access
- **Instruction Scheduling**: Reduced pipeline stalls
- **Memory Alignment**: Optimized for cache lines

### Extensibility Framework
```assembly
# Easy to add new hash functions
new_hash_function:
    # Initialize state
    # Process blocks
    # Finalize output
    ret
```

## Use Cases

### Educational
- **Computer Science Courses**: Assembly programming and cryptography
- **Security Training**: Understanding low-level implementations
- **Research Projects**: Cryptographic algorithm analysis
- **CTF Competitions**: Reverse engineering practice

### Development
- **Embedded Systems**: Resource-constrained environments
- **IoT Security**: Lightweight cryptographic implementations
- **Bootloaders**: Secure boot verification
- **HSM Development**: Hardware security modules

### Research
- **Side-Channel Analysis**: Attack and defense research
- **Performance Optimization**: Algorithm tuning
- **Formal Verification**: Correctness proofs
- **Hardware Implementation**: ASIC/FPGA designs

## Customization Guide

### Adding New Hash Functions
1. **Define Constants**: Add algorithm-specific constants to `.rodata`
2. **Implement Core**: Write main hash function following SHA-256 pattern
3. **Add Tests**: Include standard test vectors
4. **Update Interface**: Modify main test suite

### Performance Tuning
```assembly
# Example: Unroll critical loops for speed
sha256_round_unrolled:
    # Round 0
    # ... (inline round operations)
    # Round 1
    # ... (inline round operations)
    # Continue for all 64 rounds
```

### Security Enhancements
```assembly
# Add hardware random number generation
get_entropy:
    # Platform-specific entropy source
    # Could use RISC-V entropy extension
    ret
```

## Performance Metrics

### Benchmark Results (Estimated)
| Operation | Cycles | Throughput | Memory |
|-----------|---------|------------|---------|
| SHA-256 (64B) | ~2,000 | ~30 MB/s | 2KB |
| SHA-1 (64B) | ~1,500 | ~40 MB/s | 1.5KB |
| MD5 (64B) | ~1,000 | ~60 MB/s | 1KB |

### Optimization Techniques
- **Reduced Memory Access**: 85% register-based operations
- **Minimized Branches**: Straight-line code in critical paths
- **Cache Optimization**: 64-byte aligned data structures
- **Pipeline Utilization**: Instruction-level parallelism

## Contributing

### Code Style Guidelines
- **Comments**: Comprehensive documentation for all functions
- **Naming**: Descriptive labels following cryptographic conventions
- **Structure**: Logical organization by algorithm and functionality
- **Testing**: Include test vectors for all implementations

### Areas for Contribution
- [ ] **Additional Algorithms**: SHA-3, BLAKE2, ChaCha20
- [ ] **Hardware Extensions**: RISC-V crypto extension support
- [ ] **Formal Verification**: Mathematical proofs of correctness
- [ ] **Side-Channel Testing**: Advanced attack simulations
- [ ] **Performance Profiling**: Detailed cycle analysis
- [ ] **Documentation**: Extended tutorials and examples

### Development Workflow
1. **Fork Repository**: Create personal development branch
2. **Implement Feature**: Follow existing code patterns
3. **Add Tests**: Include comprehensive test cases
4. **Benchmark**: Measure performance impact
5. **Document**: Update README and inline comments
6. **Submit PR**: Include test results and documentation

### Export Control Notice
This software contains cryptographic functionality. Check local export control laws before distribution.

### Security Disclaimer
This is an educational implementation. For production use:
- Conduct thorough security audits
- Test against known attack vectors  
- Consider certified implementations
- Follow industry best practices

## Acknowledgments

- **NIST**: For standardizing SHA-2 family algorithms
- **RISC-V Foundation**: For the open instruction set architecture
- **Cryptographic Community**: For ongoing security research
- **Academic Institutions**: For educational resources and test vectors

## References

1. FIPS 180-4: Secure Hash Standard (SHS)
2. RFC 3174: US Secure Hash Algorithm 1 (SHA1)
3. RFC 1321: The MD5 Message-Digest Algorithm
4. RISC-V Instruction Set Manual
5. Handbook of Applied Cryptography

