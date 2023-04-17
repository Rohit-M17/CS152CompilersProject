%{
#include <stdio.h>
int currline = 1;
int currpos = 1;
%}

/* Definitions for regular expressions */
DIGIT [0-9]
ALPHA [a-z]|[A-Z]
IDENT [a-zA-Z_][a-zA-Z0-9_]*
INVALIDIDENT [^A-Za-z_]|[0-9][A-Za-z_]*
COMMENT \/\/.*\n
WHITESPACE [\t]+

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
SUCH "such"
NEXT "next"
READ "read"
SHOUT "shout"
FUNCTION "funct"
DOT "."

%%
{ASSIGNMENT}+     { printf("ASSIGN:      %s\n", yytext); currpos = currpos + yyleng; }
{EQ}+             { printf("EQ:          %s\n", yytext); currpos = currpos + yyleng; }
{NEQ}+            { printf("NEQ:         %s\n", yytext); currpos = currpos + yyleng; }
{LT}+             { printf("LT:          %s\n", yytext); currpos = currpos + yyleng; }
{GT}+             { printf("GT:          %s\n", yytext); currpos = currpos + yyleng; }
{LTE}+            { printf("LTE:         %s\n", yytext); currpos = currpos + yyleng; }
{GTE}+            { printf("GTE:         %s\n", yytext); currpos = currpos + yyleng; }
{LEFT_BRACE}+     { printf("LEFT_BRACE:  %s\n", yytext); currpos = currpos + yyleng; }
{RIGHT_BRACE}+    { printf("RIGHT_BRACE: %s\n", yytext); currpos = currpos + yyleng; }
{WHILE}+          { printf("WHILE:       %s\n", yytext); currpos = currpos + yyleng; }
{STOP}+           { printf("STOP:        %s\n", yytext); currpos = currpos + yyleng; }
{CONTINUE}+       { printf("CONTINUE:    %s\n", yytext); currpos = currpos + yyleng; }
{SUCH}+           { printf("SUCH:        %s\n", yytext); currpos = currpos + yyleng; }
{NEXT}+           { printf("NEXT:        %s\n", yytext); currpos = currpos + yyleng; }
{READ}+           { printf("READ:        %s\n", yytext); currpos = currpos + yyleng; }
{SHOUT}+          { printf("SHOUT:       %s\n", yytext); currpos = currpos + yyleng; }
{COMMENT}+        { /* ignore comments */ }
{FUNCTION}+       { printf("FUNCTION:    %s\n", yytext); currpos = currpos + yyleng; }
{IDENT}+          { printf("IDENT:       %s\n", yytext); currpos = currpos + yyleng; }
{DOT}+            { printf("DOT:         %s\n", yytext); currpos = currpos + yyleng; }
{INVALIDIDENT}+   { printf("ERROR: Invalid identifier %s on line number %d and column number %d\n", yytext, currline + 1, currpos + 1); currpos + currpos + yyleng; }
{DIGIT}+          { printf("NUMBER:      %s\n", yytext); }

.
%%

int main(void) {
  printf("Ctrl + D to quit\n");
  yylex();
}
