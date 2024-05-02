#!/usr/bin/bash

nasm -f bin -o real-mode-bootloader ./src/bootloader-bare/01-real-mode-bootloader.asm
nasm -f bin -o protected-mode-bootloader ./src/bootloader-bare/02-protected-mode-bootloader.asm
