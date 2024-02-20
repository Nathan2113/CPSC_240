#Change comments (put all dev info)

#/bin/bash

#Program name "Amazing Triangles"
#Author: Nathan Warner
#This file is the script file that accompanies the "Amazing Triangles" program.

#Delete some un-needed files
rm *.o
rm *.out

nasm -f elf64 -l triangle.lis -o triangle.o triangle.asm

gcc  -m64 -Wall -no-pie -o triangle_solver.o -std=c2x -c triangle_solver.c

#may need to add -lm
gcc -m64 -no-pie -o triangle_solver.out triangle.o triangle_solver.o -std=c2x -Wall -z noexecstack -lm

chmod +x triangle_solver.out
./triangle_solver.out

#Change comments (put all dev info)