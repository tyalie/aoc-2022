#####################################
# BUILD OPTIONS
#####################################

# build folder
BUILD = build

CC = riscv64-unknown-elf-gcc

# includes
INCLUDES = -Iinclude

# compile parameters
CFLAGS_RISCV = -march=rv64g -mabi=lp64 -static -mcmodel=medany
CFLAGS_ASM = -nostdlib -nostartfiles
CFLAGS := $(CFLAGS_RISCV) $(CFLAGS_ASM) -fvisibility=hidden $(INCLUDES)


#####################################
# EMULATOR OPTIONS
#####################################


GDBPORT = 45678

QEMU = qemu-system-riscv64
GDB = gdb-multiarch

QEMUOPTS := -nographic -machine sifive_u -bios none


#####################################
# MAIN TARGETS
#####################################

# generate targets from days present in src folder
days := $(patsubst src/%,%,$(wildcard src/day*))
BUILD_TARGETS = $(foreach e,$(days),build-$e)
RUN_TARGETS = $(foreach e,$(days),run-$e)
DEBUG_TARGETS = $(foreach e,$(days),debug-$e)


.PHONY: clean $(BUILD_TARGETS) $(RUN_TARGETS) $(DEBUG_TARGETS)

$(BUILD_TARGETS): build-day%: ${BUILD}/day%.elf

$(RUN_TARGETS): run-day%: build-day%
	$(QEMU) $(QEMUOPTS) -kernel "${BUILD}/day$*.elf"

$(DEBUG_TARGETS): debug-day%: build-day% gdbinit
	@echo "> Start gdb in another shell.\n> Stop execution with ctrl-a + x"
	$(QEMU) $(QEMUOPTS) -kernel "$(BUILD)/day$*.elf" -S -gdb tcp::$(GDBPORT)

gdb:
	$(GDB) -ex "source gdbinit"

clean:
	rm -rf ${BUILD}


#####################################
# BUILD RECIPIES
#####################################

gdbinit: tools/dot-gdbinit
	sed "s/localhost:1234/localhost:$(GDBPORT)/" < $^ > $@

${BUILD}/day%.elf: src/day%/main.S
	mkdir -p "$(BUILD)"
	@echo "Compiling $@"
	$(CC) -c $(CPPFLAGS) $(CFLAGS) $^ -o "$@"


