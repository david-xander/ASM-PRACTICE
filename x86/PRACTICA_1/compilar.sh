#!/bin/bash

rm mP1.o
rm MP1

yasm -f elf64 -g dwarf2 mP1.asm
gcc -no-pie -o MP1 -g mP1.o mP1.c

./MP1

# echo "Ejecutar juego? [s/n] "
# read -n1 word 

# case "$word" in
#     [Ss]* ) ./MP1;;
#     [Yy]* ) ./MP1;;    
#     [Nn]* ) echo;;
#     * ) echo "Responde [s/n] ";;
# esac
