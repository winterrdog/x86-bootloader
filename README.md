# `x86`-bootloader

A hobby project to learn how to make an `x86` bootloader in `16`-bit real and `32`-bit protected mode

## Requirements

Make sure the following are installed:

- `qemu` -- emulates x86 system virtually
- `nasm` -- compile x86 assembly into machine code( since the assembly was written with the `Intel` syntax )

## Usage

- You can compile all the _bootloaders without a kernel_ with this:

  ```sh
  ./compile.sh
  ```

- In order to use them as boot devices from a `floppy` disk, you can run them like so:

  ```sh
  qemu-system-x86_64 -fda real-mode-bootloader # it is in 16-bit real mode
  qemu-system-x86_64 -fda protected-mode-bootloader # it is in 32-bit protected mode
  ```

- In order to compile the _bootloader with a kernel_, you need to have a gcc cross-compiler of target `i686-elf` installed. You can compile the bootloader with the kernel like so:

  ```sh
  ./kernel-compile.sh
  ```

  In case you don't have that cross-compiler installed, you can use check [this](https://wiki.osdev.org/GCC_Cross-Compiler) to install it or use my bash script [here](https://github.com/winterrdog/build-gcc-cross-compiler) to do all the heavy lifting for you.

- In order to run the bootloader with the kernel, you can run it like so:

  ```sh
    qemu-system-x86_64 -fda kernel.bin
  ```

# Notes

This project is a work in progress. I am still learning about the `x86` architecture and how to write bootloaders. I will be updating this project as I learn more about the `x86` architecture and how to write bootloaders. But it **ain't easy**, so I will be updating this project slowly.

## References

- [os dev wiki](https://wiki.osdev.org/GDT)
- [a GDT tutorial](https://wiki.osdev.org/GDT_Tutorial)
- [working with protected mode](http://www.osdever.net/tutorials/view/the-world-of-protected-mode)
- [craft an `x86` bootloader](http://3zanders.co.uk/2017/10/16/writing-a-bootloader1/)
- [working with A20 gate](https://wiki.osdev.org/A20_Line)
