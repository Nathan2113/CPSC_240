#/****************************************************************************************************************************
#Program name: "Areas of Triangles" - This program will prompt the user for the lengths of 2 sides of a triangle and the 
#size of the angle between them. All I/O in this program will be handled in pure assembly using syscalls. The conversions
#atof (string to float) and ftoa (float to string) both use built-in library functions. When computing the area of the 
#triangle, sin(x), where x is the angle, is used in the formula, and sin(x) is computed using a Taylor series, programmed in 
#x86_64. When the user has input 2 sides and the angle between, the program will convert the strings input by the user into
#floats, calculate the area, then convert the area into a string and output the area to the screen. Once the area has been  
#output to the screen, the program will then return the area to the driver function, written in C, and will confirm its 
#retrieval and convey a goobye message to the user.

#WARNING: THIS PROGRAM DOES NOT VALIDATE USER INPUT
#****************************************************************************************************************************/



#/**********************************************************************************************************************************
#Author information
#  Author name: Nathan Warner
#  Author email: nwarner4@csu.fullerton.edu

#Program information
#  Program name: Areas of Triangles
#  Programming languages: One module in C, four modules in x86_64, and one module in bash
#  Date program began: 2024-May-4
#  Date of last update: 2024-Mar-8
#  Files in this program: main.c, producer.asm multiplier.asm sin.asm strlen.asm r.sh
#  Testing: Alpha testing completed.  All functions are correct.
#  Status: Ready for release to customers

#Purpose
#  The program will take in 2 sides of a triangle, as well as the angle between them in degrees from the user.
#    Using the above information, the program will then compute the area of the triangle and output it to the screen.
#    All I/O in this program will be done in pure x86_64 assembly using syscalls

#This file:
#  File name: r.sh
#  Language: bash
#  Max page width: 124 columns
#  Optimal print specification: Landscape, 7 points, monospace, 8½x11 paper
#  Prototype of this function: int main(int argc, const char * argv[]);
#***********************************************************************************************************************************/


#/bin/bash

#Program name "Areas of Triangles"
#Author: Nathan Warner
#This file is the script file that accompanies the "Areas of Triangles" program.

#Delete some un-needed files
rm *.o
rm *.out

echo "Assemble the source file main.c"
gcc -m64 -Wall -no-pie -o main.o -std=c2x -c main.c

echo "Assemble the source file producer.asm"
nasm -f elf64 -l producer.lis -o producer.o producer.asm

echo "Assemble the source file sin.asm"
nasm -f elf64 -l sin.lis -o sin.o sin.asm

echo "Assemble the source file strlen.asm"
nasm -f elf64 -l strlen.lis -o strlen.o strlen.asm

echo "Assemble the source file multiplier.asm"
nasm -f elf64 -l multiplier.lis -o multiplier.o multiplier.asm

echo "Link the object modules to create an executable file"
gcc -m64 -Wall -no-pie -o main.out  main.o producer.o sin.o strlen.o multiplier.o -std=c2x -z noexecstack -lm

echo "Execute the program"
chmod +x main.out
./main.out