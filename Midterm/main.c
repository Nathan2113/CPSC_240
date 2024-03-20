// Nathan Warner
// nwarner4@csu.fullerton.edu
// CPSC 240-3
// Mar 20, 2024


#include <stdio.h>
#include <math.h>
//#include <string.h>
//#include <stdlib.h>

extern double electricity();

int main(int argc, const char * argv[])
{printf("\nWelcome to Arrays of floating point numbers.\nBrought to you by Nathan Warner\n");
 double variance = 0;
 variance = electricity();
 printf("\nThe driver has received this number %1.10f and will keep it for future use.\n",variance);
 printf("Main will return 0 to the operating system. Bye.\n");
}

//End of the function main.c ====================================================================