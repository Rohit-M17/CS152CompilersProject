/* Parser Generation - Syntax Analysis */
/* cobra.y */

%{
#include <stdio.h>
#include <stdlib.h>
#include <string>

extern int yylex();
extern int yyparse();
extern FILE* yyin;

void yyerror(const char* s);
%}

%union {
  int       number_val;
  char*     ident_val;
}

%start prog_start

%token	<number_val>    NUMBER
%token	<ident_val>     IDENT

%token	FUNCTION DOT COLON COMMA DIGIT ARRAY SIZE UNDERSCORE COMMENT SUCH NEXT STOP CONTINUE RETURN READ SHOUT NOT ASSIGN ELSE EQ NEQ GT GTE IF LT LTE WHILE WRITE

%left   BEGIN_PARAMS END_PARAMS
%left   BEGIN_LOCALS END_LOCALS
%left   BEGIN_BODY END_BODY
%left   LEFT_BRACKET RIGHT_BRACKET
%left   LEFT_PARAN RIGHT_PARAN
%left   LEFT_BRACE RIGHT_BRACE
%left   ADD SUB
%left   MULT DIV MOD


%%
prog_start:     functions {  }

functions:      %empty {  }
                | function functions {  }
                ;

function:       FUNCTION identifier DOT BEGIN_PARAMS declarations END_PARAMS BEGIN_LOCALS declarations END_LOCALS BEGIN_BODY statements END_BODY {  }
                ;

declarations:   %empty {  }
                | declaration DOT declarations {  }
                ;

declaration:    identifier COLON DIGIT {  }
                | identifier COLON DIGIT ARRAY LEFT_BRACKET RIGHT_BRACKET SIZE number {  }
                | error { yyerror("Incorrect declaration structure"); }
                ;

identifier:     IDENT { //printf("identifier -> IDENT %s \n", $1); }
                ;

number:         NUMBER { //printf("number -> NUMBER %d \n", $1); }
                ;

statements:     %empty {  }
                | statement statements {  }
                ;



statement:      var ASSIGN expression DOT                           {  }
                | IF boolexp LEFT_BRACE statement RIGHT_BRACE else  {  }
                | IF IDENT LEFT_BRACE statement RIGHT_BRACE else    {  }
                | WHILE boolexp LEFT_BRACE statement RIGHT_BRACE    {  }
                | IF boolexp LEFT_BRACE statements RIGHT_BRACE else {  }
                | IF IDENT LEFT_BRACE statements RIGHT_BRACE else   {  }
                | WHILE boolexp LEFT_BRACE statements RIGHT_BRACE   {  }
                | READ LEFT_PARAN expression RIGHT_PARAN DOT        {  }
                | WRITE LEFT_PARAN expression RIGHT_PARAN DOT       {  }
                | RETURN expression DOT                             {  }
                | CONTINUE DOT                                      {  }
                | STOP DOT                                          {  }
                ;

else:           %empty {  }
                | ELSE LEFT_BRACE statements RIGHT_BRACE {  }
                ;

boolexp:        expression comp expression       {  }
                | NOT expression comp expression {  }
                ;

comp:           EQ     {  }
                | LT   {  }
                | GT   {  }
                | LTE  {  }
                | GTE  {  }
                | NEQ  {  }
                ;

expression:     multexpr                 {  }
                | multexpr ADD multexpr  {  }
                | multexpr SUB multexpr  {  }
                ;

multexpr:       term             {  }
                | term MULT term {  }
                | term DIV term  {  }
                | term MOD term  {  }
                ;

term:           var {  }
                | number {  }
                | LEFT_PARAN expression RIGHT_PARAN {  }
                ;

var:            identifier {  }
                | identifier LEFT_BRACKET expression RIGHT_BRACKET {  }
                ;

%%


int main(int argc, char *argv[]) {
  if (argc != 2) {
    printf("Not correct usage of the command.", argv[0]);
    exit(1);
  }
  FILE *inputFile = fopen(argv[1], "r");
  if (inputFile == NULL) {
    printf("Unable to open input file: %s\n", argv[1]);
    exit(1);
  }
  yyin = inputFile;
  yyparse();

  return 0;
}

void yyerror(const char* s) {
  extern int yylineno;
  extern char *yytext;
  fprintf(stderr, "ERROR: (syntax error) %s on line %d, at token: %s \n", s, yylineno, yytext);
  exit(1);
}
