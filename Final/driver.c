// Nathan Warner
// nwarner4@csu.fullerton.edu
// CPSC 240-3
// May 13, 2024


#include <stdio.h>
#include <math.h>
//#include <string.h>
//#include <stdlib.h>

extern double dot();

int main(int argc, const char * argv[])
{printf("\nWelcome to the CS 240-3 final exam\n");
printf("This program is maintained by Nathan Warner");
 double product = 0;
 product = dot();
 printf("\nThe driver has received %1.1f and will keep it.\n",product);
 printf("A 0 will be sent to the OS. Bye.\n");
}

//End of the function driver.c ====================================================================