# Nathan Warner
# nwarner4@csu.fullerton.edu
# CPSC 240-3
# Mar 20, 2024


#/bin/bash


#Delete some un-needed files
rm *.o
rm *.out

echo "Assemble the source file electricity.asm"
nasm -f elf64 -l electricity.lis -o electricity.o electricity.asm


echo "Assemble the source file current.asm"
nasm -f elf64 -l current.lis -o current.o current.asm


echo "Assemble the source file isfloat.asm"
nasm -f elf64 -l isfloat.lis -o isfloat.o isfloat.asm


echo "Compile the source file main.c"
gcc  -m64 -Wall -no-pie -o main.o -std=c2x -c main.c


echo "Link the object modules to create an executable file"
gcc -m64 -no-pie -o main.out electricity.o main.o isfloat.o current.o -std=c2x -Wall -z noexecstack

echo "Execute the program"
chmod +x main.out
./main.out