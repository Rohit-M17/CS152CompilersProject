all:
    flex lexer.lex
    gcc lex.yy.c -lfl
    ./a.out array.min
