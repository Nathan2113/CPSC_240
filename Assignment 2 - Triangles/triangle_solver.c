// Change Comments

// ****************************************************************************************************************************
// Program name: "Amazing Triangles"                                                                                                         *
//                                                                                                                            *
// This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License  *
// version 3 as published by the Free Software Foundation.  This program is distributed in the hope that it will be useful,   *
// but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See   *
// the GNU General Public License for more details A copy of the GNU General Public License v3 is available here:             *
// <https://www.gnu.org/licenses/>.                                                                                           *
// ****************************************************************************************************************************




// ========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**
// Author information
//   Author name: Nathan Warner
//   Author email: nwarner4@csu.fullerton.edu

// Program information
//   Program name: Driving Time
//   Programming languages: One module in C, one in X86, and one in bash.
//   Date program began: 2024-Jan-30
//   Date of last update: 2024-Feb-2
//   Files in this program: driving_time.c, average.asm, r.sh.
//   Testing: Alpha testing completed.  All functions are correct.
//   Status: Ready for release to customers

// Purpose
//   This program will take in total distance traveled and average speed and find the total time of the trip,
//   as well as sending the average speed of the entirety of the trip back to the driver

// This file:
//   File name: driving_time.c
//   Language: X86-64
//   Max page width: 124 columns
//   Assemble (standard): nasm -l hello.lis -o hello.o helloworld.asm
//   Assemble (debug): nasm -g dwarf -l hello.lis -o hello.o helloworld.asm
//   Optimal print specification: Landscape, 7 points, monospace, 8½x11 paper
//   Prototype of this function: double average();






#include <stdio.h>
#include <math.h>
//#include <string.h>
//#include <stdlib.h>

extern double triangle_SAS();

int main(int argc, const char * argv[])
{printf("Welcome to Amazing Triangles programmed by Nathan Warner on February 11, 2024.\n");
 double thirdLength = 0;
 thirdLength = triangle_SAS();
 printf("The driver has received this number %1.8lf and will simply keep it.\n\n",thirdLength);
 printf("An integer zero will now be sent to the operating system. Bye\n");
}

// Change Comments