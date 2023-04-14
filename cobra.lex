%{
#include <stdio.h>

%}

DIGIT [0-9]
ALPHA [a-z]|[A-Z]
BACKSLASH "/"

%%
{DIGIT}+   { printf("NUMBER: %s\n", yytext); }
{ALPHA}+   { printf("TOKEN:  %s\n", yytext); }
.
%%

int main(void) {
  printf("Ctrl + D to quit\n");
  printf("Hello, My Name is %s\n", "Daniel");
  printf("%d + %d = %d", 1, 1, 2);
  yylex();
}
