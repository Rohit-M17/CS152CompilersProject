%{
#include <stdio.h>
int currline = 1;
int currpos = 1;
%}

extern FILE* yyin;

/* Definitions for regular expressions */
DIGIT [0-9]
ALPHA [a-z]|[A-Z]
IDENT [a-zA-Z_][a-zA-Z0-9_]*
COMMENT \/\/.*\n
WHITESPACE [[:blank:]]+
NEWLINE \n
INVALIDIDENT [0-9]+[A-Za-z_]+

/* Definitions for token patterns */
/* Arithmetic Operators */
ASSIGNMENT "="
ADD "sum"
SUB "sub"
MULT "mult"
DIV "div"
MOD "mod"

/* Comparison Operators */
EQ "equals"
NEQ "notequals"
LT "lessthan"
GT "greaterthan"
LTE "lessorequal"
GTE "greaterorequal"

/* Other Symbols */
LEFT_BRACE "{"
RIGHT_BRACE "}"
COLON ":"
LEFT_PARAN "("
RIGHT_PARAN ")"
LEFT_BRACKET "["
RIGHT_BRACKET "]"
COMMA ","
UNDERSCORE "_"

/* Reserved Words */
WHILE "during"
STOP "stop"
CONTINUE "continue"
SUCH "such"
NEXT "next"
READ "read"
SHOUT "shout"
FUNCTION "funct"
DOT "."
BEGIN_PARAMS "params {"
END_PARAMS "} params"
BEGIN_LOCALS "locals {"
END_LOCALS "} locals"
BEGIN_BODY "body {"
END_BODY "} body"
ARRAY "arr"
RETURN "return"

%%

{ASSIGNMENT}     { printf("ASSIGNMENT\n", yytext); currpos = currpos + yyleng; }
{ADD}            { printf("ADD\n", yytext); currpos = currpos + yyleng; }
{SUB}            { printf("SUB\n", yytext); currpos = currpos + yyleng; }
{MULT}           { printf("MULT\n", yytext); currpos = currpos + yyleng; }
{DIV}            { printf("DIV\n", yytext); currpos = currpos + yyleng; }
{MOD}            { printf("MOD\n", yytext); currpos = currpos + yyleng; }

{EQ}             { printf("EQ\n", yytext); currpos = currpos + yyleng; }
{NEQ}            { printf("NEQ\n", yytext); currpos = currpos + yyleng; }
{LT}             { printf("LT\n", yytext); currpos = currpos + yyleng; }
{GT}             { printf("GT\n", yytext); currpos = currpos + yyleng; }
{LTE}            { printf("LTE\n", yytext); currpos = currpos + yyleng; }
{GTE}            { printf("GTE\n", yytext); currpos = currpos + yyleng; }

{LEFT_BRACE}     { printf("LEFT_BRACE\n", yytext); currpos = currpos + yyleng; }
{RIGHT_BRACE}    { printf("RIGHT_BRACE\n", yytext); currpos = currpos + yyleng; }
{COLON}          { printf("COLON\n", yytext); currpos = currpos + yyleng; }
{LEFT_PARAN}     { printf("LEFT_PARAN\n", yytext); currpos = currpos + yyleng; }
{RIGHT_PARAN}    { printf("RIGHT_PARAN\n", yytext); currpos = currpos + yyleng; }
{LEFT_BRACKET}   { printf("LEFT_BRACKET\n", yytext); currpos = currpos + yyleng; }
{RIGHT_BRACKET}  { printf("RIGHT_BRACKET\n", yytext); currpos = currpos + yyleng; }
{COMMA}          { printf("COMMA\n", yytext); currpos = currpos + yyleng; }        
{UNDERSCORE}     { printf("UNDERSCORE\n", yytext); currpos = currpos + yyleng; }

{WHILE}          { printf("WHILE\n", yytext); currpos = currpos + yyleng; }
{STOP}           { printf("STOP\n", yytext); currpos = currpos + yyleng; }
{CONTINUE}       { printf("CONTINUE\n", yytext); currpos = currpos + yyleng; }
{SUCH}           { printf("SUCH\n", yytext); currpos = currpos + yyleng; }
{NEXT}           { printf("NEXT\n", yytext); currpos = currpos + yyleng; }
{READ}           { printf("READ\n", yytext); currpos = currpos + yyleng; }
{SHOUT}          { printf("SHOUT\n", yytext); currpos = currpos + yyleng; }
{COMMENT}+        { /* ignore comments */                  currpos = currpos + yyleng; }
{WHITESPACE}+     { /* ignore whitespace */                currpos = currpos + yyleng; }
{NEWLINE}+        { /* ignore newline */   currpos = 0;    currline = currline + 1;    }
{FUNCTION}       { printf("FUNCTION\n", yytext); currpos = currpos + yyleng; }
{DOT}            { printf("DOT\n", yytext); currpos = currpos + yyleng; }
{BEGIN_PARAMS}   { printf("BEGIN_PARAMS\n", yytext); currpos = currpos + yyleng; }
{END_PARAMS}     { printf("END_PARAMS\n", yytext); currpos = currpos + yyleng; }
{BEGIN_LOCALS}   { printf("BEGIN_LOCALS\n", yytext); currpos = currpos + yyleng; }
{END_LOCALS}     { printf("END_LOCALS\n", yytext); currpos = currpos + yyleng; }
{BEGIN_BODY}     { printf("BEGIN_BODY\n", yytext); currpos = currpos + yyleng; }
{END_BODY}       { printf("END_BODY\n", yytext); currpos = currpos + yyleng; }
{ARRAY}          { printf("ARRAY\n", yytext); currpos = currpos + yyleng; }
{RETURN}         { printf("RETURN\n", yytext); currpos = currpos + yyleng; }

{INVALIDIDENT}   { printf("*********ERROR: Invalid identifier %s on line number %d and column number %d\n", yytext, currline + 2, currpos + 1); currpos + currpos + yyleng; }
{IDENT}          { printf("IDENT:         %s\n", yytext); currpos = currpos + yyleng; }
{DIGIT}+          { printf("NUMBER:        %s\n", yytext); currpos = currpos + yyleng; }
.                 { printf("*********ERROR: Unrecognized symbol %s on line number %d and column number %d\n", yytext, currline + 2, currpos + 1); currpos + currpos + yyleng; }
%%

int main(int argc, char *argv[]) {
  if (argc != 2) {
    printf("Not correct usage of the command.", argv[0]);
    return 1;
  }
  
  FILE *inputFile = fopen(argv[1], "r");
  if (inputFile == NULL) {
    printf("Unable to open input file: %s\n", argv[1]);
    return 1;
  }

  yyin = inputFile;

  printf("Ctrl + D to quit\n");
  yylex();

  fclose(inputFile);

  return 0;
}

