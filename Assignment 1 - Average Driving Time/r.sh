#/bin/bash
#Program name "Driving Time"
#Author: Nathan Warner
#CWID: 884688250
#This file is the script file that accompanies the "Driving Time" program.
#Delete some un-needed files
rm *.o
rm *.out
nasm -f elf64 -l average.lis -o average.o average.asm
gcc  -m64 -Wall -no-pie -o driving_time.o -std=c2x -c driving_time.c
gcc -m64 -no-pie -o driving_time.out average.o driving_time.o -std=c2x -Wall -z noexecstack
chmod +x driving_time.out
./driving_time.out