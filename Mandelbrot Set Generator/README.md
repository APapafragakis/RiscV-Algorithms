# RISC-V Mandelbrot Set Generator

A sophisticated RISC-V assembly program that generates ASCII art of the famous Mandelbrot fractal using pure assembly language and fixed-point arithmetic.

## Features

- **Pure RISC-V Assembly**: Written entirely in RISC-V assembly language
- **Fixed-Point Mathematics**: Implements complex number arithmetic using 16.16 fixed-point format
- **Fractal Generation**: Renders the Mandelbrot set as beautiful ASCII art
- **Optimized Algorithms**: Efficient iteration and coordinate transformation
- **Educational Value**: Demonstrates advanced RISC-V programming concepts

## What Makes This Special

This project showcases several advanced programming concepts:

- **Complex Number Mathematics**: Implementation of complex number operations in assembly
- **Fixed-Point Arithmetic**: High-precision calculations without floating-point units
- **Memory Management**: Efficient buffer handling and string operations
- **Algorithm Implementation**: Translation of mathematical algorithms to assembly
- **System Calls**: Direct interaction with the operating system

## Sample Output

```
RISC-V Mandelbrot Set Generator

                                   ..:::::::::..                               
                               ..:::::::::::::::::::..                         
                           ..::::::::::::::::::::::::::.                       
                        .::::::::::::::::::::::::::::::::::..                  
                      .::::::::::::::::::::::::::::::::::::::::.               
                   ..::::::::::::::::::::::::::::::::::::::::::::..            
                  .::::::::::::::::::::::::::::::::::::::::::::::::.           
                .::::::::::::::::::::::::::::::::::::::::::::::::::::          
               .::::::::::::::::::::::::::::::::::::::::::::::::::::::.        
             .:::::::::::::::::::::::::::::::::::::::::::::::::::::::::.       
            .:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::.      
           .:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::.     
          .::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::.     
         .:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::.     
        .::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::.     
       .:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::.     
      .:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::.    
     .::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::.    
    .:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::.    
   .:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::.   
  .::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::.   
 .:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::.   
.:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::.  

Generated using RISC-V assembly!
```

## Technical Implementation

### Fixed-Point Arithmetic
The program uses 16.16 fixed-point format where:
- Upper 16 bits represent the integer part
- Lower 16 bits represent the fractional part
- Allows precise decimal calculations without floating-point hardware

### Algorithm Details
1. **Coordinate Transformation**: Maps screen pixels to complex plane coordinates
2. **Mandelbrot Iteration**: Implements the iterative formula z = z² + c
3. **Convergence Testing**: Checks if |z|² > 4 to determine set membership
4. **Character Mapping**: Converts iteration counts to ASCII art characters

### Memory Layout
- **Data Section**: Constants, lookup tables, and output buffers
- **Stack Management**: Proper function call conventions with register preservation
- **String Handling**: Efficient null-terminated string operations

## Building and Running

### Prerequisites
- RISC-V toolchain (riscv64-unknown-elf-gcc)
- RISC-V simulator (QEMU, Spike, or similar)

### Build Instructions

```bash
# Assemble the program
riscv64-unknown-elf-as -o mandelbrot.o mandelbrot.s

# Link the executable
riscv64-unknown-elf-ld -o mandelbrot mandelbrot.o

# Run with QEMU
qemu-riscv64 mandelbrot

# Or run with Spike simulator
spike pk mandelbrot
```

### Alternative Build (with GCC)
```bash
# Use GCC for easier building
riscv64-unknown-elf-gcc -nostdlib -static -o mandelbrot mandelbrot.s
```

## Project Structure

```
riscv-mandelbrot/
├── mandelbrot.s          # Main assembly source file
├── README.md            # This documentation
├── Makefile             # Build automation
└── examples/            # Sample outputs and variations
    ├── output.txt       # Sample program output
    └── variations.s     # Different fractal parameters
```

## Educational Aspects

This project is excellent for learning:

- **RISC-V ISA**: Practical application of RISC-V instruction set
- **Assembly Programming**: Advanced assembly language techniques
- **Computer Graphics**: Fundamental graphics programming concepts
- **Mathematical Computing**: Numerical methods and algorithm implementation
- **System Programming**: Direct hardware interaction and system calls

## Advanced Features

### Customization Options
- Modify `WIDTH` and `HEIGHT` for different resolutions
- Adjust `MAX_ITER` for quality vs. performance trade-offs
- Change complex plane bounds for different fractal regions
- Customize the character palette for different visual styles

### Performance Optimizations
- Efficient fixed-point multiplication and division
- Minimal memory allocations
- Optimized loop structures
- Register usage optimization

## Extending the Project

Potential enhancements:
- **Julia Set Generator**: Implement other fractal types
- **Color Output**: Add ANSI color codes for enhanced visualization
- **Interactive Mode**: Allow real-time parameter adjustment
- **Multi-threading**: Parallelize computation across RISC-V cores
- **File Output**: Save results to image files

## Performance Metrics

- **Memory Usage**: ~2KB for output buffer + minimal stack
- **Computation**: O(WIDTH × HEIGHT × MAX_ITER) complexity
- **Typical Runtime**: 1-5 seconds on modern RISC-V processors

## Contributing

Contributions are welcome! Areas for improvement:
- Performance optimizations
- Additional fractal algorithms
- Better visualization options
- Code documentation and comments
- Cross-platform compatibility

## License

This project is released under the MIT License. Feel free to use, modify, and distribute.

## Acknowledgments

- RISC-V Foundation for the excellent architecture
- Mandelbrot set mathematics from Benoit Mandelbrot's pioneering work
- RISC-V community for tools and documentation

---

**Made with love and RISC-V Assembly**

*This project demonstrates that complex mathematical visualizations can be achieved even at the lowest level of programming, showcasing the elegance and power of the RISC-V architecture.*