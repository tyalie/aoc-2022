# AoC '22 in RISCV assembly

This work has been based on previous work by the [riscv-hello-asm][riscv-hello-asm]
project.

Requires the following commands to exist:

- `qemu-system-riscv64`
- `gdb-multiarch`
- `riscv64-unknown-elf-gcc`

Build the project with
```bash
make build-day??
# where ?? is the day i.e.
make build-day1
```

Run it with QEMU using
```bash
make run-day??
make debug-day??  # run an debug instance
```

> Note: When using debug, you'll need to execute the gdb in a seperate window.
> The debug target creates a gdbinit file, that contains the relevant commands for
> initializing the gdb and connecting it to the qemu session.
> It also includes tools from `tools/gdbutil`
>
> ```bash
> make gdb
> ```


## Useful documents

The following documents are quite useful to write RISCV assembly:

- [RISC-V assembly programmers manual][riscv-asm-man]
- [The RISC-V Instruction Set Manual Volume I: User-Level ISA by Andrew Waterman,
  Krste Asanović and SiFive
  Inc.][riscv-instruction-set-man]
- [SiFive U (SiFive Freedom U540-C000 SoC) Hardware Manual][sifiveu-hardware-man]


[riscv-hello-asm]: https://github.com/noteed/riscv-hello-asm

[riscv-asm-man]: https://github.com/riscv-non-isa/riscv-asm-manual/blob/master/riscv-asm.md
[riscv-instruction-set-man]: https://riscv.org/wp-content/uploads/2017/05/riscv-spec-v2.2.pdf
[sifiveu-hardware-man]: https://static.dev.sifive.com/FU540-C000-v1.0.pdf
