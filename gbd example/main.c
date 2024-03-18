// #include <iostream>
#include <stdio.h>

extern double manager();

int main(int argc, const char * argv[]) {
    double arr[5] = {2.5, 3.0, 4.5, 5.0, 6.6};
    double variance = 0.0;

    printf("This is testing gbd debugging...\n\n");

    variance = manager();

    return 0;
}