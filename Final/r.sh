# Nathan Warner
# nwarner4@csu.fullerton.edu
# CPSC 240-3
# May 13, 2024


#/bin/bash


#Delete some un-needed files
rm *.o
rm *.out

echo "Assemble the source file driver.asm"
nasm -f elf64 -l driver.lis -o driver.o driver.asm

echo "Compile the source file main.c"
gcc  -m64 -Wall -no-pie -o main.o -std=c2x -c main.c

echo "Link the object modules to create an executable file"
gcc -m64 -no-pie -o main.out driver.o main.o  -std=c2x -Wall -z noexecstack

echo "Execute the program"
chmod +x main.out
./main.out