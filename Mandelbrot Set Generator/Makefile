# RISC-V Mandelbrot Set Generator Makefile
# Supports multiple build configurations and simulators

# Toolchain configuration
RISCV_PREFIX = riscv64-unknown-elf-
AS = $(RISCV_PREFIX)as
LD = $(RISCV_PREFIX)ld
GCC = $(RISCV_PREFIX)gcc
OBJDUMP = $(RISCV_PREFIX)objdump
OBJCOPY = $(RISCV_PREFIX)objcopy

# Project configuration
PROJECT = mandelbrot
SOURCE = $(PROJECT).s
OBJECT = $(PROJECT).o
EXECUTABLE = $(PROJECT)
DUMP = $(PROJECT).dump

# Compiler flags
ASFLAGS = -march=rv64i -mabi=lp64
LDFLAGS = -m elf64lriscv
GCCFLAGS = -nostdlib -static -march=rv64i -mabi=lp64

# Simulator configuration
QEMU = qemu-riscv64
SPIKE = spike
PK = pk

# Default target
all: $(EXECUTABLE)

# Build with assembler and linker (traditional approach)
$(EXECUTABLE): $(OBJECT)
	$(LD) $(LDFLAGS) -o $@ $<

$(OBJECT): $(SOURCE)
	$(AS) $(ASFLAGS) -o $@ $<

# Alternative build with GCC (simpler)
gcc-build: $(SOURCE)
	$(GCC) $(GCCFLAGS) -o $(EXECUTABLE) $<

# Generate assembly dump for debugging
dump: $(EXECUTABLE)
	$(OBJDUMP) -d $< > $(DUMP)

# Run targets
run-qemu: $(EXECUTABLE)
	$(QEMU) ./$(EXECUTABLE)

run-spike: $(EXECUTABLE)
	$(SPIKE) $(PK) ./$(EXECUTABLE)

# Test different configurations
test-small: $(SOURCE)
	sed 's/WIDTH:.*\.word 80/WIDTH: .word 40/' $(SOURCE) | \
	sed 's/HEIGHT:.*\.word 24/HEIGHT: .word 12/' > $(PROJECT)_small.s
	$(GCC) $(GCCFLAGS) -o $(PROJECT)_small $(PROJECT)_small.s
	$(QEMU) ./$(PROJECT)_small

test-detailed: $(SOURCE)
	sed 's/MAX_ITER:.*\.word 100/MAX_ITER: .word 200/' $(SOURCE) > $(PROJECT)_detailed.s
	$(GCC) $(GCCFLAGS) -o $(PROJECT)_detailed $(PROJECT)_detailed.s
	$(QEMU) ./$(PROJECT)_detailed

# Debugging targets
debug-qemu: $(EXECUTABLE)
	$(QEMU) -g 1234 ./$(EXECUTABLE) &
	echo "GDB server running on port 1234"
	echo "Connect with: riscv64-unknown-elf-gdb $(EXECUTABLE)"
	echo "Then: target remote :1234"

# Performance timing
benchmark: $(EXECUTABLE)
	time $(QEMU) ./$(EXECUTABLE) > /dev/null

# Create distribution package
dist: clean all
	mkdir -p dist/$(PROJECT)
	cp $(SOURCE) README.md Makefile dist/$(PROJECT)/
	cp $(EXECUTABLE) dist/$(PROJECT)/
	echo "#!/bin/bash" > dist/$(PROJECT)/run.sh
	echo "qemu-riscv64 ./$(EXECUTABLE)" >> dist/$(PROJECT)/run.sh
	chmod +x dist/$(PROJECT)/run.sh
	cd dist && tar -czf $(PROJECT).tar.gz $(PROJECT)/
	echo "Distribution package created: dist/$(PROJECT).tar.gz"

# Validation targets
check-syntax: $(SOURCE)
	$(AS) $(ASFLAGS) -o /dev/null $< && echo "Syntax OK"

check-tools:
	@echo "Checking RISC-V toolchain..."
	@which $(AS) > /dev/null && echo "✓ Assembler found: $(AS)" || echo "✗ Assembler not found: $(AS)"
	@which $(LD) > /dev/null && echo "✓ Linker found: $(LD)" || echo "✗ Linker not found: $(LD)"
	@which $(GCC) > /dev/null && echo "✓ GCC found: $(GCC)" || echo "✗ GCC not found: $(GCC)"
	@which $(QEMU) > /dev/null && echo "✓ QEMU found: $(QEMU)" || echo "✗ QEMU not found: $(QEMU)"

# Documentation generation
docs:
	@echo "=== RISC-V Mandelbrot Set Generator ==="
	@echo "Build targets:"
	@echo "  all          - Build executable (default)"
	@echo "  gcc-build    - Build using GCC (simpler)"
	@echo "  dump         - Generate disassembly"
	@echo ""
	@echo "Run targets:"
	@echo "  run-qemu     - Run with QEMU"
	@echo "  run-spike    - Run with Spike simulator"
	@echo ""
	@echo "Test targets:"
	@echo "  test-small   - Run with smaller output (40x12)"
	@echo "  test-detailed- Run with higher iterations (200)"
	@echo "  benchmark    - Time execution"
	@echo ""
	@echo "Utility targets:"
	@echo "  check-tools  - Verify toolchain installation"
	@echo "  check-syntax - Validate assembly syntax"
	@echo "  debug-qemu   - Start GDB debugging session"
	@echo "  dist         - Create distribution package"
	@echo "  clean        - Remove build artifacts"

# Cleanup
clean:
	rm -f $(OBJECT) $(EXECUTABLE) $(DUMP)
	rm -f $(PROJECT)_small $(PROJECT)_small.s
	rm -f $(PROJECT)_detailed $(PROJECT)_detailed.s
	rm -rf dist/

# Phony targets
.PHONY: all gcc-build dump run-qemu run-spike test-small test-detailed debug-qemu benchmark dist check-syntax check-tools docs clean

# Help target
help: docs