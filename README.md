# AoC '22 in RISCV assembly

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
