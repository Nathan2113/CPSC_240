//****************************************************************************************************************************
//Program name: "Begin Assembly".  This program serves as a model for new programmers of X86 programming language.  This     *
//shows the standard layout of a function written in X86 assembly.  The program is a live example of how to complie,         *
//assembly, link, and execute a program containing source code written in X86.  Copyright (C) 2024  Floyd Holliday.          *
//                                                                                                                           *
//This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License  *
//version 3 as published by the Free Software Foundation.  This program is distributed in the hope that it will be useful,   *
//but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See   *
//the GNU General Public License for more details A copy of the GNU General Public License v3 is available here:             *
//<https://www.gnu.org/licenses/>.                                                                                           *
//****************************************************************************************************************************

//Author: Floyd Holliday
//Author email: holliday@fullerton.edu
//Program name: Begin Assembly
//Programming languages: One module in C, one in X86, and one in bash.
//Date program began: 2024-Jan-5
//Date of last update: 2024-Apr-22
//Files in this program: beginhere.c, helloworld.asm, r.sh.  At a future date rg.sh may be added
//Testing: Alpha testing completed.  All functions are correct.
//Status: Ready for release to the customers

//Purpose of this program:
//  This program is a starting point for those learning to program in x86 assembly

//This file
//  File name: beginhere.c
//  Language: C language, 202x standardization where x will be a decimal digit.
//  Max page width: 124 columns
//  Compile: gcc -m64 -no-pie -o begin.o -std=c20 -Wall beginhere.c -c
//  Link: gcc -m64 -no-pie -o learn.out hello.o begin.o -std=c20 -Wall -z noexecstack





#include <stdio.h>
//#include <string.h>
//#include <stdlib.h>

extern unsigned long average();

int main(int argc, const char * argv[])
{printf("Welcome to Driving Time maintained by Nathan Warner\n");
 unsigned long averageSpeed = 0;
 averageSpeed = average();
 printf("\nThe driver has received this number %lu and will keep it for future use.\n",averageSpeed);
 printf("Have a great day\n\n");
 printf("A zero will be sent to the operating system as a signal of a successful execution\n");
}

