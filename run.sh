set -e
lex $1
gcc lex.yy.c -ll
./a.out