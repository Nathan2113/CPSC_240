#Change comments (put all dev info)

#/bin/bash

#Program name "Amazing Triangles"
#Author: Nathan Warner
#This file is the script file that accompanies the "Amazing Triangles" program.

#Delete some un-needed files
rm *.o
rm *.out

echo "Assemble the source file triangle.asm"
nasm -f elf64 -l triangle.lis -o triangle.o triangle.asm

echo "Assemble the source file isfloat.asm"
nasm -f elf64 -l isfloat.lis -o isfloat.o isfloat.asm

echo "Compile the source file traingle_solver.c"
gcc  -m64 -Wall -no-pie -o triangle_solver.o -std=c2x -c triangle_solver.c

echo "Link the object modules to create an executable file"
gcc -m64 -no-pie -o triangle_solver.out isfloat.o triangle.o triangle_solver.o -std=c2x -Wall -z noexecstack -lm

echo "Execute the program"
chmod +x triangle_solver.out
./triangle_solver.out

#Change comments (put all dev info)