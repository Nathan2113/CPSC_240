// Nathan Warner
// nwarner4@csu.fullerton.edu
// CPSC 240-3
// May 13, 2024


#include <stdio.h>
#include <math.h>
//#include <string.h>
//#include <stdlib.h>

extern double driver();

int main(int argc, const char * argv[])
{printf("\nWelcome to the West Beach Electric Company\nThis software is maintained by Nathan Warner\n\n");
 double current = 0;
 current = driver();
 printf("\nThe driver has received this number %1.5f and will keep it for later.\n",current);
 printf("A zero will be returned to the oprtating system. Bye.\n");
}

//End of the function main.c ====================================================================