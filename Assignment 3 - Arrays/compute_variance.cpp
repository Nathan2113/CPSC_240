/****************************************************************************************************************************
Program name: "Arrays" - This program will first welcome the user to the program, as well as outputting its developer.     *
After this initial message, the program will let the user know the directions of the program, which is as follows:         *
                                                                                                                           *
"This program will manage your arrays of 64-bit floats                                                                     *
For the array enter a sequence of 64-bit floats separated by white space.                                                  *
After the last input press enter followed by Control+D:"                                                                   *
                                                                                                                           *
The program will then take in user input, validating each input to make sure they are entering valid float numbers, and    *
this process is done through the input_array.asm file, using isfloat.asm to validate their inputs. If the user inputs an   *
invalid input, the program will let them know with the following message:                                                  *
                                                                                                                           *
"The last input was invalid and not entered into the array.""                                                              *
                                                                                                                           *
Once the array has been fully entered, the program will output the entire array to the screen, which is done in the        *
output_array.c file using the C language. Once the array has been output, the program will then compute the mean of the    *
array using compute_mean.asm, and will then use the mean it found to compute the variance using compute_variance.cpp,      *
which uses C++. Once the variance has been found, the program will output the variance to the screen for the user, and     *
will then send the variance to main.c, where the program will let the user know that the variance will be kept for         *
future use, and that a 0 will be sent to the operating system.                                                             *
                                                                                                                           *
This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License  *
version 3 as published by the Free Software Foundation.  This program is distributed in the hope that it will be useful,   *
but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See   *
the GNU General Public License for more details A copy of the GNU General Public License v3 is available here:             *
<https://www.gnu.org/licenses/>.                                                                                           *
****************************************************************************************************************************/



/**********************************************************************************************************************************
Author information
  Author name: Nathan Warner
  Author email: nwarner4@csu.fullerton.edu

Program information
  Program name: Arrays
  Programming languages: Two modules in C, four modules in x86_64, one module in C++, and one module in bash
  Date program began: 2024-Mar-3
  Date of last update: 2024-Mar-7
  Files in this program: main.c, manager.asm, r.sh, output_array.c, compute_mean.asm, compute_variance.cpp, input_array.asm, isfloat.asm
  Testing: Alpha testing completed.  All functions are correct.
  Status: Ready for release to customers

Purpose
  The program will take in an array of valid floating point numbers from the user, find the mean of the array, 
       and find the variance, which it will output to the screen and send to main.c

This file:
  File name: compute_variance.cpp
  Language: C++
  Max page width: 124 columns
  Assemble (standard): g++  -c -m64 -Wall -fno-pie -no-pie -o compute_variance.o compute_variance.cpp
  Optimal print specification: Landscape, 7 points, monospace, 8½x11 paper
  Prototype of this function: extern "C" double compute_variance(double *arr, int size, double mean);
***********************************************************************************************************************************/


#include <stdio.h>
#include <cmath>
//#include <string.h>
//#include <stdlib.h>

extern "C" double compute_variance(double *arr, int size, double mean);
// Put in mean after testing
double compute_variance(double *arr, int size, double mean) {
    double variance = 0;
    double numerator = 0;


    for(int i = 0; i < size; i++) {
        numerator += pow((arr[i] - mean), 2);
    }

    variance = numerator/(size - 1);

    return variance;
}
//End of the function compute_variance.cpp ====================================================================