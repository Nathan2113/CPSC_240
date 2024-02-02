#/bin/bash

#Program name "Driving Time"
#Author: Nathan Warner
#This file is the script file that accompanies the "Driving Time" program.

#Delete some un-needed files
rm *.o
rm *.out

# echo "Assemble the source file average.asm"
nasm -f elf64 -l average.lis -o average.o average.asm

# echo "Compile the source file driver.c"
gcc  -m64 -Wall -no-pie -o driving_time.o -std=c2x -c driving_time.c

# echo "Link the object modules to create an executable file"
gcc -m64 -no-pie -o driving_time.out average.o driving_time.o -std=c2x -Wall -z noexecstack

# echo "Execute the program that new students use to understand assembly programming"
chmod +x driving_time.out
./driving_time.out

# echo "Successfully linked driver.c with average.asm"

# echo "This bash script will now terminate."
