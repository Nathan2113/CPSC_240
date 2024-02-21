#/bin/bash

#Program name "Assingment 2"
#Author: Garrett Kostyk
#This file is the script file that accompanies the "Assignment 2" program.
#Prepare for execution in normal mode (not gdb mode).

#Delete some un-needed files
rm *.o
rm *.out

echo "Assemble the source file triangle.asm"
nasm -f elf64 -l tri.lis -o tri.o triangle.asm

echo "Assemble the source file isfloat.asm"
nasm -f elf64 -l isfloat.lis -o isfloat.o isfloat.asm

echo "Compile the source file driver.c"
gcc  -m64 -Wall -no-pie -o drive2.o -std=c2x -c driver2.c

echo "Link the object modules to create an executable file"
gcc -m64 -no-pie -o final.out drive2.o tri.o isfloat.o -std=c2x -Wall -z noexecstack -lm

echo "Execute the program that new students use to understand assembly programming"
chmod +x final.out
./final.out

echo "This bash script will now terminate."