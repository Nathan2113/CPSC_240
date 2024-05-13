# Nathan Warner
# nwarner4@csu.fullerton.edu
# CPSC 240-3
# May 13, 2024


#/bin/bash


#Delete some un-needed files
rm *.o
rm *.out

echo "Assemble the source file dot.asm"
nasm -f elf64 -l dot.lis -o dot.o dot.asm

echo "Compile the source file driver.c"
gcc  -m64 -Wall -no-pie -o driver.o -std=c2x -c driver.c

echo "Assemble the source file isfloat.asm"
nasm -f elf64 -l isfloat.lis -o isfloat.o isfloat.asm

echo "Link the object modules to create an executable file"
gcc -m64 -no-pie -o main.out dot.o driver.o  isfloat.o -std=c2x -Wall -z noexecstack

echo "Execute the program"
chmod +x main.out
./main.out