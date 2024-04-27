# `x86`-bootloader

A hobby project to learn how to make an `x86` bootloader in `16`-bit real and `32`-bit protected mode

## Requirements

Make sure the following are installed:

- `qemu` -- emulates x86 system virtually
- `nasm` -- compile x86 assembly into machine code

## Usage

- You can compile all the files with this:

```sh
./compile.sh
```

- In order to use them as boot devices from a `floppy` disk, you can run them like so:

```sh
qemu-system-x86_64 -fda boot1.bin # for boot1 which is in 16-bit real mode
qemu-system-x86_64 -fda boot2.bin # for boot2 which is in 32-bit protected mode
```

## References

- [os dev wiki](https://wiki.osdev.org/GDT)
- [a GDT tutorial](https://wiki.osdev.org/GDT_Tutorial)
- [working with protected mode](http://www.osdever.net/tutorials/view/the-world-of-protected-mode)
- [craft an `x86` bootloader](http://3zanders.co.uk/2017/10/16/writing-a-bootloader1/)
- [working with A20 gate](https://wiki.osdev.org/A20_Line)
