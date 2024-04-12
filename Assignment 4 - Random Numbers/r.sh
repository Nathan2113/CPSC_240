# /***************************************************************************************************************************
# Program name: "Non-deterministic Random Numbers" - This program will welcome the user to the program, then will ask        *
# for their name and title. After welcoming the user, the program will give a description of what it does for the user       *
#                                                                                                                            *
# This program will generate 64-bit IEEE float numbers.                                                                      *
# How many numbers do you want. Today's limit is 100 per customer:                                                           *
# Your numbers have been stored in an array. Here is that array.                                                             *
#                                                                                                                            *
# The program will then take in user input for the size of the array that they want, if the user inputs a number greater     *
# than 100, or a negative number, the program will tell them that they have entered an invalid input, and to try again       *
#                                                                                                                            *
# "Invalid array size...Try again:                                                                                           *
#                                                                                                                            *
# Once the user has input a valid array size, the program lets them know it is generating n random numbers, where n is the   *
# array size the user input above. Once the array has been filled with random numbers, the program will output the entire    *
# array, then it will normalize the array to be between the values 1.0 and 2.0, and will output the entire array again.      *
# After this second array output, the program will then sort the array (using C++ library functions) and will output the     *
# array one last time for the user, this time sorted from least to greatest                                                  *
#                                                                                                                            *
# The program will then say goodbye to the user, and terminate the program                                                   *
#                                                                                                                            *
# This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License  *
# version 3 as published by the Free Software Foundation.  This program is distributed in the hope that it will be useful,   *
# but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See   *
# the GNU General Public License for more details A copy of the GNU General Public License v3 is available here:             *
# <https://www.gnu.org/licenses/>.                                                                                           *
# ****************************************************************************************************************************/



# /**********************************************************************************************************************************
# Author information
#   Author name: Nathan Warner
#   Author email: nwarner4@csu.fullerton.edu

# Program information
#   Program name: Non-deterministic Random Numbers
#   Programming languages: One module in C, one module in C++, five modules in x86_64 assembly, and one module in bash
#   Date program began: 2024-Apr-8
#   Date of last update: 2024-Apr-11
#   Files in this program: main.c, sort.cpp, manager.asm, fill_random_array.asm, isnan.asm, show_array.asm, normalize_array.asm, r.sh
#   Testing: Alpha testing completed.  All functions are correct.
#   Status: Ready for release to customers

# Purpose
#   The program will create an array of size n, where n is input by the user, and between 1 and 100, and will create a random number
#     array, will normalize the array between 1.0 and 2.0, and then sort the array

# This file:
#   File name: r.sh
#   Language: Bash
#   Max page width: 124 columns
#   Optimal print specification: Landscape, 7 points, monospace, 8½x11 paper
#   Prototype of this function: int main(int argc, const char * argv[]);
# ***********************************************************************************************************************************/


#/bin/bash

#Program name "Non-deterministic Random Numbers"
#Author: Nathan Warner
#This file is the script file that accompanies the "Non-deterministic Random Numbers" program.

#Delete some un-needed files
rm *.o
rm *.out

echo "Assemble the source file manager.asm"
nasm -f elf64 -l manager.lis -o manager.o manager.asm

echo "Assemble the source file show_array.asm"
nasm -f elf64 -l show_array.lis -o show_array.o show_array.asm

echo "Assemble the source file normalize_array.asm"
nasm -f elf64 -l normalize_array.lis -o normalize_array.o normalize_array.asm

echo "Assemble the source file isnan.asm"
nasm -f elf64 -l isnan.lis -o isnan.o isnan.asm

echo "Assemble the source file fill_random_array.asm"
nasm -f elf64 -l fill_random_array.lis -o fill_random_array.o fill_random_array.asm

echo "Compile the source file main.c"
gcc  -m64 -Wall -no-pie -o main.o -std=c2x -c main.c

echo "Compile the source file sort.cpp"
g++  -c -m64 -Wall -fno-pie -no-pie -o sort.o sort.cpp

echo "Link the object modules to create an executable file"
g++ -m64 -no-pie -o main.out manager.o main.o show_array.o normalize_array.o isnan.o fill_random_array.o sort.o -std=c2x -Wall -z noexecstack -lm

echo "Execute the program"
chmod +x main.out
./main.out