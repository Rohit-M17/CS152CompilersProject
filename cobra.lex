%{
#include <stdio.h>
int currline = 1;
int currpos = 1;
%}

/* Definitions for regular expressions */
DIGIT [0-9]
ALPHA [a-z]|[A-Z]
IDENT [a-zA-Z_][a-zA-Z0-9_]*

/* Definitions for token patterns */
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
DOT "."

%%
{ASSIGNMENT}+  { printf("ASSIGN:      %s\n", yytext); currpos = currpos + yyleng;}
{EQ}+          { printf("EQ:          %s\n", yytext); currpos = currpos + yyleng;}
{NEQ}+         { printf("NEQ:         %s\n", yytext); currpos = currpos + yyleng;}
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
{READ}+        { printf("READ:        %s\n", yytext); }
{SHOUT}+       { printf("SHOUT:       %s\n", yytext); }
{COMMENT}+     { /* ignore comments */ }
{FUNCTION}+    { printf("FUNCTION:    %s\n", yytext); }
{IDENT}+       { printf("IDENT:       %s\n", yytext); }
{DOT}+         { printf("DOT:      %s\n", yytext); }

{DIGIT}+       { printf("NUMBER:      %s\n", yytext); }
.
%%

int main(void) {
  printf("Ctrl + D to quit\n");
  yylex();
}
