#!/usr/bin/bash

nasm -f bin -o boot1.bin ./src/boot1.asm
nasm -f bin -o boot2.bin ./src/boot2.asm