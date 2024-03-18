# Program name: "Arrays" - This program will first welcome the user to the program, as well as outputting its developer.     *
# After this initial message, the program will let the user know the directions of the program, which is as follows:         *
#                                                                                                                            *
# "This program will manage your arrays of 64-bit floats                                                                     *
# For the array enter a sequence of 64-bit floats separated by white space.                                                  *
# After the last input press enter followed by Control+D:"                                                                   *
#                                                                                                                            *
# The program will then take in user input, validating each input to make sure they are entering valid float numbers, and    *
# this process is done through the input_array.asm file, using isfloat.asm to validate their inputs. If the user inputs an   *
# invalid input, the program will let them know with the following message:                                                  *
#                                                                                                                            *
# "The last input was invalid and not entered into the array.""                                                              *
#                                                                                                                            *
# Once the array has been fully entered, the program will output the entire array to the screen, which is done in the        *
# output_array.c file using the C language. Once the array has been output, the program will then compute the mean of the    *
# array using compute_mean.asm, and will then use the mean it found to compute the variance using compute_variance.cpp,      *
# which uses C++. Once the variance has been found, the program will output the variance to the screen for the user, and     *
# will then send the variance to main.c, where the program will let the user know that the variance will be kept for         *
# future use, and that a 0 will be sent to the operating system.                                                             *
#                                                                                                                            *
# This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License  *
# version 3 as published by the Free Software Foundation.  This program is distributed in the hope that it will be useful,   *
# but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See   *
# the GNU General Public License for more details A copy of the GNU General Public License v3 is available here:             *
# <https://www.gnu.org/licenses/>.                                                                                           *



#========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**
# Author information
#   Author name: Nathan Warner
#   Author email: nwarner4@csu.fullerton.edu

# Program information
#   Program name: Arrays
#   Programming languages: Two modules in C, four modules in x86_64, one module in C++, and one module in bash
#   Date program began: 2024-Mar-3
#   Date of last update: 2024-Mar-7
#   Files in this program: main.c, manager.asm, r.sh, output_array.c, compute_mean.asm, compute_variance.cpp, input_array.asm, isfloat.asm
#   Testing: Alpha testing completed.  All functions are correct.
#   Status: Ready for release to customers

# Purpose
#   The program will take in an array of valid floating point numbers from the user, find the mean of the array, 
#        and find the variance, which it will output to the screen and send to main.c

# This file:
#   File name: r.sh
#   Language: Bash
#   Max page width: 124 columns
#   Optimal print specification: Landscape, 7 points, monospace, 8½x11 paper
#   How to call r.sh: ./r.sh
#========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**


#/bin/bash

#Program name "Arrays"
#Author: Nathan Warner
#This file is the script file that accompanies the "Arrays" program.

#Delete some un-needed files
rm *.o
rm *.out

echo "Assemble the source file manager.asm"
nasm -f elf64 -l manager.lis -o manager.o manager.asm -gdwarf

echo "Assemble the source file isfloat.asm"
nasm -f elf64 -l isfloat.lis -o isfloat.o isfloat.asm -gdwarf

echo "Assemble the source file input_array.asm"
nasm -f elf64 -l input_array.lis -o input_array.o input_array.asm -gdwarf

echo "Assemble the source file compute_mean.asm"
nasm -f elf64 -l compute_mean.lis -o compute_mean.o compute_mean.asm -gdwarf

echo "Compile the source file main.c"
gcc  -m64 -Wall -no-pie -o main.o -std=c2x -c main.c -g

echo "Compile the source file output_array.c"
gcc  -m64 -Wall -no-pie -o output_array.o -std=c2x -c output_array.c -g

echo "Compile the source file compute_variance.c++"
g++  -c -m64 -Wall -fno-pie -no-pie -o compute_variance.o compute_variance.cpp -g

echo "Link the object modules to create an executable file"
g++ -m64 -no-pie -o main.out isfloat.o manager.o input_array.o compute_mean.o output_array.o compute_variance.o main.o -std=c2x -Wall -z noexecstack -lm -g

echo "Execute the program"
chmod +x main.out
gdb ./main.out