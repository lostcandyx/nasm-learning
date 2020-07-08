nasm -f elf main.asm
ld -m elf_i386 main.o -o main
echo 'type [sudo ./main] to run the game \n'