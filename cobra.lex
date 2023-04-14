%{
#include <stdio.h>
int currline = 1;
int currpos = 1;
%}

DIGIT [0-9]
ALPHA [a-z]|[A-Z]
BACKSLASH "/"

%%
{DIGIT}+   { printf("NUMBER: %s\n", yytext); }
{ALPHA}+   { printf("VARIABLE:  %s\n", yytext); currpos = currpos + yyleng;}
"="           {printf("ASSIGN\n"); currpos = currpos + yyleng;}
"equals"    {printf("EQ\n"); currpos = currpos + yyleng;}
"notequals"    {printf("NEQ\n"); currpos = currpos + yyleng;}
.
%%

int main(void) {
  printf("Ctrl + D to quit\n");
  printf("Hello, My Name is %s\n", "Daniel");
  printf("%d + %d = %d", 1, 1, 2);
  yylex();
}
