%{
#include <stdio.h>

%}
/* Definitions for regular expressions */
DIGIT [0-9]
ALPHA [a-z]|[A-Z]
BACKSLASH "/"

/* Definitions for token patterns */
EQ "equals"
NEQ "notequals"
LT "lessthan"
GT "greaterthan"
LTE "lessorequal"
GTE "greaterorequal"
LEFT_BRACE "{"
RIGHT_BRACE "}"
WHILE "during"
STOP "stop"
CONTINUE "continue"
SUCH such
NEXT next

%%
{DIGIT}+   { printf("NUMBER: %s\n", yytext); }
{ALPHA}+       { printf("TOKEN:       %s\n", yytext); }
{EQ}+          { printf("EQ:          %s\n", yytext); }
{NEQ}+         { printf("NEQ:         %s\n", yytext); }
{LT}+          { printf("LT:          %s\n", yytext); }
{GT}+          { printf("GT:          %s\n", yytext); }
{LTE}+         { printf("LTE:         %s\n", yytext); }
{GTE}+         { printf("GTE:         %s\n", yytext); }
{LEFT_BRACE}+  { printf("LEFT_BRACE:  %s\n", yytext); }
{RIGHT_BRACE}+ { printf("RIGHT_BRACE: %s\n", yytext); }
{WHILE}+       { printf("WHILE:       %s\n", yytext); }
{STOP}+        { printf("STOP:        %s\n", yytext); }
{CONTINUE}+    { printf("CONTINUE:    %s\n", yytext); }
{SUCH}+        { printf("SUCH:        %s\n", yytext); }
{NEXT}+        { printf("NEXT:        %s\n", yytext); }
.
%%

int main(void) {
  printf("Ctrl + D to quit\n");
  printf("Hello, My Name is %s\n", "Daniel");
  printf("%d + %d = %d", 1, 1, 2);
  yylex();
}
