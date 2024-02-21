//****************************************************************************************************************************
//Program name: "Assignment 2".  This program will compute the side of a triangle given 2 sides and an angle, will also test *
//for invalid inputs. Copyright (C) 2024  Garrett Kostyk.                                                                    *
//                                                                                                                           *
//This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License  *
//version 3 as published by the Free Software Foundation.  This program is distributed in the hope that it will be useful,   *
//but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See   *
//the GNU General Public License for more details A copy of the GNU General Public License v3 is available here:             *
//<https://www.gnu.org/licenses/>.                                                                                           *
//****************************************************************************************************************************

//Author: Garrett Kostyk
//Author email: gk42gk42@gmail.com
//Program name: Assignment 2
//Programming languages: One module in C, one in X86, and one in bash.
//Date program began: 2024-Feb-12
//Date of last update: 
//Files in this program: driver2.c, average.asm, r.sh
//Testing: Alpha testing completed.  All functions are correct.
//Status: Ready for release to the customers

//Purpose of this program:
//This program is a simple program that will compute the side of a triangle given 2 sides and an angle,
//will also test for invalid inputs.


//This file
//  File name: driver2.c
//  Language: C language, 202x standardization where x will be a decimal digit.
//  Max page width: 124 columns
//  Compile:
//  Link:

#include <stdio.h>
#include <string.h>
#include <stdlib.h>

extern double triangle(); 

int main(int argc, const char * argv[])
{
    printf("Welcome to Amazing Triangles programmed by Garrett Kostyk on February 24, 2024\n");
    double count = 0;
    count = triangle();
    printf("The driver has recived this number %1.8lf and will simply keep it.\n",count);
    printf("An integer zero will now be sent to the operating system.   Bye.\n");
}