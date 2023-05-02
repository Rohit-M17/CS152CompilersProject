/* Scanner Generation - Lexical Analysis */
/* cobra.lex */

%option noyywrap
%option yylineno

%{
#include <stdio.h>
#define YY_DECL int yylex(void)
#include "cobra.tab.h"

/*int currline = 1;*/
int currpos = 1;
%}

/* Definitions for regular expressions */
NUMBER [0-9]
ALPHA [a-z]|[A-Z]
IDENT [a-zA-Z_][a-zA-Z0-9_]*
COMMENT \/\/.*\n
WHITESPACE [[:blank:]]+
NEWLINE \n
INVALIDIDENT [0-9]+[A-Za-z_]+

/* Definitions for token patterns */
/* Arithmetic Operators */
ASSIGN "="
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
DOT "."
COLON ":"
LEFT_PARAN "("
RIGHT_PARAN ")"
LEFT_BRACE "{"
RIGHT_BRACE "}"
LEFT_BRACKET "["
RIGHT_BRACKET "]"
COMMA ","
UNDERSCORE "_"

/* Reserved Words */
FUNCTION "funct"
BEGIN_PARAMS "params {"
END_PARAMS "} params"
BEGIN_LOCALS "locals {"
END_LOCALS "} locals"
BEGIN_BODY "body {"
END_BODY "} body"
DIGIT "digit"
WHILE "during"
ARRAY "arr"
IF "such"
ELSE "next"
STOP "stop."
CONTINUE "continue"
NOT "not"
RETURN "return"
READ "read"
WRITE "shout"
SIZE "size"

%%

{ASSIGN}         { currpos = currpos + yyleng; return ASSIGN; }
{ADD}            { currpos = currpos + yyleng; return ADD; }
{SUB}            { currpos = currpos + yyleng; return SUB; }
{MULT}           { currpos = currpos + yyleng; return MULT; }
{DIV}            { currpos = currpos + yyleng; return DIV; }
{MOD}            { currpos = currpos + yyleng; return MOD; }

{EQ}             { currpos = currpos + yyleng; return EQ; }
{NEQ}            { currpos = currpos + yyleng; return NEQ; }
{LT}             { currpos = currpos + yyleng; return LT; }
{GT}             { currpos = currpos + yyleng; return GT; }
{LTE}            { currpos = currpos + yyleng; return LTE; }
{GTE}            { currpos = currpos + yyleng; return GTE; }

{LEFT_BRACE}     { currpos = currpos + yyleng; return LEFT_BRACE; }
{RIGHT_BRACE}    { currpos = currpos + yyleng; return RIGHT_BRACE; }
{COLON}          { currpos = currpos + yyleng; return COLON; }
{LEFT_PARAN}     { currpos = currpos + yyleng; return LEFT_PARAN; }
{RIGHT_PARAN}    { currpos = currpos + yyleng; return RIGHT_PARAN; }
{LEFT_BRACKET}   { currpos = currpos + yyleng; return LEFT_BRACKET; }
{RIGHT_BRACKET}  { currpos = currpos + yyleng; return RIGHT_BRACKET; }
{COMMA}          { currpos = currpos + yyleng; return COMMA; }
{UNDERSCORE}     { currpos = currpos + yyleng; return UNDERSCORE; }

{WHILE}          { currpos = currpos + yyleng; return WHILE; }
{STOP}           { currpos = currpos + yyleng; return STOP; }
{CONTINUE}       { currpos = currpos + yyleng; return CONTINUE; }
{NOT}            { currpos = currpos + yyleng; return NOT; }
{IF}             { currpos = currpos + yyleng; return IF; }
{ELSE}           { currpos = currpos + yyleng; return ELSE; }
{READ}           { currpos = currpos + yyleng; return READ; }
{WRITE}          { currpos = currpos + yyleng; return WRITE; }
{COMMENT}+       { /* ignore comments */   currpos = currpos + yyleng; }
{WHITESPACE}+    { /* ignore whitespace */ currpos = currpos + yyleng; }
{NEWLINE}+       { /* ignore newline */    currpos = 0; }
{FUNCTION}       { currpos = currpos + yyleng; return FUNCTION; }
{DOT}            { currpos = currpos + yyleng; return DOT; }
{BEGIN_PARAMS}   { currpos = currpos + yyleng; return BEGIN_PARAMS; }
{END_PARAMS}     { currpos = currpos + yyleng; return END_PARAMS; }
{BEGIN_LOCALS}   { currpos = currpos + yyleng; return BEGIN_LOCALS; }
{END_LOCALS}     { currpos = currpos + yyleng; return END_LOCALS; }
{BEGIN_BODY}     { currpos = currpos + yyleng; return BEGIN_BODY; }
{END_BODY}       { currpos = currpos + yyleng; return END_BODY; }
{DIGIT}          { currpos = currpos + yyleng; return DIGIT; }
{ARRAY}          { currpos = currpos + yyleng; return ARRAY; }
{RETURN}         { currpos = currpos + yyleng; return RETURN; }
{SIZE}           { currpos = currpos + yyleng; return SIZE; }

{INVALIDIDENT}   { printf("ERROR: Invalid identifier %s on line number %d and column number %d\n", yytext, yylineno, currpos + 1); currpos + currpos + yyleng; }
{IDENT}          { yylval.ident_val = strdup(yytext); currpos = currpos + yyleng; return IDENT; }
{NUMBER}+        { yylval.number_val = atoi(yytext);  currpos = currpos + yyleng; return NUMBER; }
.                { printf("ERROR: Unrecognized symbol %s on line number %d and column number %d\n", yytext, yylineno, currpos + 1); currpos + currpos + yyleng; }
%%

/* 
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
*/
