//****************************************************************************************************************************
//Program name: "Amazing Triangles" - This program will take first welcome the user the the program, and then output the     *
//system clock (tics) to the console. After this initial output for the user, the program will then prompt the user for their*
//full name, as well as their title (i.e. Dean, Vice-president, etc.). Once the user has entered their name and title, the   *
//program will tell them good morning, and that this program will take care of their triangles. After, the program will      *
//prompt the user for the sides of the triangle and its angle (this program solves SAS triangles). If the user inputs an     *
//invalid input (negative number, non-float number, or an input that is not a number such as 2.2.3+A), the program will      *
//let the user know that their input is invalid and will then prompt them for another input. After 3 valid inputs are        *
//entered (2 sides and 1 angle), the program will output a thank you message/confirmation of the user's inputted values.     *
//Now that the program has 3 valid inputs, it will use the formula for solving SAS triangles to find the third side, and     *
//will output said answer, as well as letting the user know that the length of the third side will be sent to the driver.    *
//Before this value is sent, the program will output the new system clock (tics). Once back in the driver, it will let the   *
//user know that it has received the value of the third side, and that a zero will be sent to the operating system.          *                                                                                                      
//                                                                                                                           *
//This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License  *
//version 3 as published by the Free Software Foundation.  This program is distributed in the hope that it will be useful,   *
//but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See   *
//the GNU General Public License for more details A copy of the GNU General Public License v3 is available here:             *
//<https://www.gnu.org/licenses/>.                                                                                           *
//****************************************************************************************************************************




//========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**
//  Author information
//  Author name: Nathan Warner
//  Author email: nwarner4@csu.fullerton.edu
//
//Program information
//  Program name: Amazing Triangles
//  Programming languages: One module in C, one in X86, and one in bash.
//  Date program began: 2024-Feb-11
//  Date of last update: 2024-Feb-19
//  Files in this program: driving_time.c, average.asm, r.sh.
//  Testing: Alpha testing completed.  All functions are correct.
//  Status: Ready for release to customers
//
//Purpose
//  This program will take in two sides and an angle of a triangle, and will output the length of the
//   thrd side to the console, as well as sending the value to the driver.
//
//This file:
//  File name: triangle_solver.c
//  Language: X86-64
//  Max page width: 124 columns
//  Compile (standard) gcc  -m64 -Wall -no-pie -o triangle_solver.o -std=c2x -c triangle_solver.c
//  Optimal print specification: Landscape, 7 points, monospace, 8½x11 paper






#include <stdio.h>
#include <math.h>
//#include <string.h>
//#include <stdlib.h>

extern double compute_variance();

int main(int argc, const char * argv[])
{printf("\nWelcome to Arrays fo floating point numbers.\nBrought to you by Nathan Warner\n");
 double variance = 0;
 variance = compute_variance();
 printf("\nThe driver has received this number %1.10f and will keep it for future use.\n",variance);
 printf("Main will return 0 to the operating system. Bye.\n");
}