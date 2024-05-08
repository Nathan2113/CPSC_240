/****************************************************************************************************************************
Program name: "Areas of Triangles" - This program will prompt the user for the lengths of 2 sides of a triangle and the 
size of the angle between them. All I/O in this program will be handled in pure assembly using syscalls. The conversions
atof (string to float) and ftoa (float to string) both use built-in library functions. When computing the area of the 
triangle, sin(x), where x is the angle, is used in the formula, and sin(x) is computed using a Taylor series, programmed in 
x86_64. When the user has input 2 sides and the angle between, the program will convert the strings input by the user into
floats, calculate the area, then convert the area into a string and output the area to the screen. Once the area has been  
output to the screen, the program will then return the area to the driver function, written in C, and will confirm its 
retrieval and convey a goobye message to the user.

WARNING: THIS PROGRAM DOES NOT VALIDATE USER INPUT
****************************************************************************************************************************/



/**********************************************************************************************************************************
Author information
  Author name: Nathan Warner
  Author email: nwarner4@csu.fullerton.edu

Program information
  Program name: Areas of Triangles
  Programming languages: One module in C, four modules in x86_64, and one module in bash
  Date program began: 2024-May-4
  Date of last update: 2024-Mar-8
  Files in this program: main.c, producer.asm multiplier.asm sin.asm strlen.asm r.sh
  Testing: Alpha testing completed.  All functions are correct.
  Status: Ready for release to customers

Purpose
  The program will take in 2 sides of a triangle, as well as the angle between them in degrees from the user.
    Using the above information, the program will then compute the area of the triangle and output it to the screen.
    All I/O in this program will be done in pure x86_64 assembly using syscalls

This file:
  File name: main.c
  Language: C
  Max page width: 124 columns
  Assemble (standard): gcc -m64 -Wall -no-pie -o main.o -std=c2x -c main.c
  Optimal print specification: Landscape, 7 points, monospace, 8½x11 paper
  Prototype of this function: int main(int argc, const char * argv[]);
***********************************************************************************************************************************/


#include <stdio.h>
#include <math.h>
//#include <string.h>
//#include <stdlib.h>

extern double producer();

int main(int argc, const char * argv[])
{printf("\nWelcome to Nathan Warner's Area Machine\n");
printf("We compute all your areas.\n");
 double area = 0;
 area = producer();
 printf("\nThe driver has received this number %1.5f and will keep it for future use.\n",area);
 printf("A zero will be sent to the OS as a sign of successful conclusion.\nBye");
}

//End of the function main.c ====================================================================