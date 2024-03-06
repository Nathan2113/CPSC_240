#****************************************************************************************************************************
#Program name: "Amazing Triangles" - This program will take first welcome the user the the program, and then output the     *
#system clock (tics) to the console. After this initial output for the user, the program will then prompt the user for their*
#full name, as well as their title (i.e. Dean, Vice-president, etc.). Once the user has entered their name and title, the   *
#program will tell them good morning, and that this program will take care of their triangles. After, the program will      *
#prompt the user for the sides of the triangle and its angle (this program solves SAS triangles). If the user inputs an     *
#invalid input (negative number, non-float number, or an input that is not a number such as 2.2.3+A), the program will      *
#let the user know that their input is invalid and will then prompt them for another input. After 3 valid inputs are        *
#entered (2 sides and 1 angle), the program will output a thank you message/confirmation of the user's inputted values.     *
#Now that the program has 3 valid inputs, it will use the formula for solving SAS triangles to find the third side, and     *
#will output said answer, as well as letting the user know that the length of the third side will be sent to the driver.    *
#Before this value is sent, the program will output the new system clock (tics). Once back in the driver, it will let the   *
#user know that it has received the value of the third side, and that a zero will be sent to the operating system.          *                                                                                                      
#                                                                                                                           *
#This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License  *
#version 3 as published by the Free Software Foundation.  This program is distributed in the hope that it will be useful,   *
#but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See   *
#the GNU General Public License for more details A copy of the GNU General Public License v3 is available here:             *
#<https://www.gnu.org/licenses/>.                                                                                           *
#****************************************************************************************************************************




#========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**
#  Author information
#  Author name: Nathan Warner
#  Author email: nwarner4@csu.fullerton.edu
#
#Program information
#  Program name: Amazing Triangles
#  Programming languages: One module in C, one in X86, and one in bash.
#  Date program began: 2024-Feb-11
#  Date of last update: 2024-Feb-19
#  Files in this program: driving_time.c, average.asm, r.sh.
#  Testing: Alpha testing completed.  All functions are correct.
#  Status: Ready for release to customers
#
#Purpose
#  This program will take in two sides and an angle of a triangle, and will output the length of the
#   thrd side to the console, as well as sending the value to the driver.
#
#This file:
#  File name: r.sh
#  Language: bash
#  Max page width: 124 columns
#  Optimal print specification: Landscape, 7 points, monospace, 8½x11 paper

#/bin/bash

#Program name "Amazing Triangles"
#Author: Nathan Warner
#This file is the script file that accompanies the "Amazing Triangles" program.

#Delete some un-needed files
rm *.o
rm *.out

echo "Assemble the source file manager.asm"
nasm -f elf64 -l manager.lis -o manager.o manager.asm

echo "Assemble the source file isfloat.asm"
nasm -f elf64 -l isfloat.lis -o isfloat.o isfloat.asm

echo "Assemble the source file input_array.asm"
nasm -f elf64 -l input_array.lis -o input_array.o input_array.asm

echo "Compile the source file main.c"
gcc  -m64 -Wall -no-pie -o main.o -std=c2x -c main.c

echo "Link the object modules to create an executable file"
gcc -m64 -no-pie -o main.out isfloat.o manager.o input_array.o main.o -std=c2x -Wall -z noexecstack -lm

echo "Execute the program"
chmod +x main.out
./main.out