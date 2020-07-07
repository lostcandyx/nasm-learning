nasm -f elf main.asm
ld -m elf_i386 main.o -o main
echo 'type [./main] to run the program \n'