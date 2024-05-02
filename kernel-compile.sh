nasm -f elf32 ./src/bootloader-with-kernel/bootloader.asm -o boot.o
i686-elf-gcc ./src/bootloader-with-kernel/kmain.c boot.o -o kernel.bin -nostdlib -ffreestanding -mno-red-zone -Wall -Werror -Wextra -T ./src/bootloader-with-kernel/linker.ld
