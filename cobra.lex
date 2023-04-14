%{
#include <stdio.h>
int currline = 1;
int currpos = 1;
%}

/* Definitions for token patterns */
DIGIT [0-9]
ALPHA [a-z]|[A-Z]

ASSIGNMENT "="
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
WHITESPACE [\t]+
READ "read"
SHOUT "shout"
COMMENT "//"
FUNCTION "funct"

%%
{DIGIT}+       { printf("NUMBER: %s\n", yytext); }
{ALPHA}+       { printf("VARIABLE:  %s\n", yytext); currpos = currpos + yyleng;}
{ASSIGNMENT}+  { printf("ASSIGN\n"); currpos = currpos + yyleng;}
{EQ}+          { printf("EQ\n"); currpos = currpos + yyleng;}
{NEQ}+         { printf("NEQ\n"); currpos = currpos + yyleng;}
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
{READ} +     { printf("TOKEN: SHOUT\n"); }
{SHOUT}+     { printf("TOKEN: SHOUT\n"); }
{COMMENT}    { /* ignore comments */ }
{FUNCTION}   { printf("TOKEN: FUNCTION\n");  }
{IDENT}      { printf("TOKEN: IDENT(%s)\n", yytext); }
.
%%

int main(void) {
  printf("Ctrl + D to quit\n");
  printf("Hello, My Name is %s\n", "Daniel");
  printf("%d + %d = %d", 1, 1, 2);
  yylex();
}
