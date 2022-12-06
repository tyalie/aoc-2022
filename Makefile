#####################################
# BUILD OPTIONS
#####################################

# build folder
BUILD = build

CC = riscv64-unknown-elf-gcc
OBJDUMP = riscv64-unknown-elf-objdump

# includes
INCLUDES = -Iinclude

# compile parameters
CFLAGS_RISCV = -march=rv64g -mabi=lp64 -mcmodel=medany
CFLAGS_ASM = -nostdlib -nostartfiles -static -Tinclude/baremetal.ld
CFLAGS := -fvisibility=hidden -g $(CFLAGS_RISCV) $(CFLAGS_ASM)  $(INCLUDES)

GDEPS := $(wildcard src/helper/*.S)
LDEPS := $(wildcard src/**/*.S)


#####################################
# EMULATOR OPTIONS
#####################################

GDBPORT = 45678

QEMU = qemu-system-riscv64
GDB = gdb-multiarch

QEMUOPTS := -nographic -machine sifive_u -bios none


#####################################
# RUN CONFIG
#####################################

INPUT = none

#####################################
# MAIN TARGETS
#####################################

# generate targets from days present in src folder
days := $(patsubst src/%,%,$(wildcard src/day*))
BUILD_TARGETS = $(foreach e,$(days),build-$e)
RUN_TARGETS = $(foreach e,$(days),run-$e)
DEBUG_TARGETS = $(foreach e,$(days),debug-$e)
OBJDUMP_TARGETS = $(foreach e,$(days),obj-$e)


.PHONY: clean $(BUILD_TARGETS) $(RUN_TARGETS) $(DEBUG_TARGETS)

$(BUILD_TARGETS): build-day%: ${BUILD}/day%.elf


$(RUN_TARGETS): run-day%: build-day% build-input-day%
	$(INCMD) $(QEMU) $(QEMUOPTS) -kernel "${BUILD}/day$*.elf"

$(DEBUG_TARGETS): debug-day%: build-day% gdbinit build-input-day%
	@echo "> Start gdb in another shell.\n> Stop execution with ctrl-a + x"
	echo "$(BUILD)/day$*.elf" > .gdbsession
	$(INCMD) $(QEMU) $(QEMUOPTS) -kernel "$(BUILD)/day$*.elf" -S -gdb tcp::$(GDBPORT)
	rm .gdbsession

$(OBJDUMP_TARGETS): obj-day%: build-day%
	$(OBJDUMP) -D "$(BUILD)/day$*.elf"

gdb: .gdbsession
	$(GDB) -q $(shell cat .gdbsession) -ex "source gdbinit"

clean:
	rm -rf ${BUILD}


#####################################
# BUILD RECIPIES
#####################################

ifneq ($(INPUT), none)
build-input-%:
	$(eval INPUT_FILE_NAME = input$(shell [ -n "$(INPUT)" ] && echo "_$(INPUT)"))
	$(eval INCMD = echo "$$$$(cat src/$*/$(INPUT_FILE_NAME))\0004$$$$(cat src/$*/$(INPUT_FILE_NAME))\04\c" |)
else
build-input-%: ;
endif

gdbinit: tools/dot-gdbinit
	sed "s/localhost:1234/localhost:$(GDBPORT)/" < $^ > $@

${BUILD}/day%.elf: src/day%/main.S $(LDEPS)
	mkdir -p "$(BUILD)"
	@echo "Compiling $@"
	$(CC) $(CFLAGS) $< -o "$@"


