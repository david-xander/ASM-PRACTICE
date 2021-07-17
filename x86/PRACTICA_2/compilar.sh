#!/bin/bash

rm mP2.o
rm MP2

yasm -f elf64 -g dwarf2 mP2.asm
gcc -no-pie -o MP2 -g mP2.o mP2.c

./MP2

# echo "Ejecutar juego? [s/n] "
# read -n1 word 

# case "$word" in
#     [Ss]* ) ./MP1;;
#     [Yy]* ) ./MP1;;    
#     [Nn]* ) echo;;
#     * ) echo "Responde [s/n] ";;
# esac
