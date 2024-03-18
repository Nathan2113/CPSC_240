echo "Compile the source file main.c"
gcc  -m64 -Wall -no-pie -o main.o -std=c2x -c main.c -g

echo "Assemble the source file manager.asm"
nasm -f elf64 -l manager.lis -o manager.o manager.asm -gdwarf

echo "Link the object modules to create an executable file"
gcc -m64 -no-pie -o learn.out manager.o main.o -std=c2x -Wall -z noexecstack -g

echo "Execute the program"
chmod +x learn.out
gdb ./learn.out