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
prog_start:     functions { printf("prog_start -> functions \n"); }

functions:      %empty { printf("functions -> epsilon \n"); }
                | function functions { printf("functions -> function functions \n"); }
                ;

function:       FUNCTION identifier DOT BEGIN_PARAMS declarations END_PARAMS BEGIN_LOCALS declarations END_LOCALS BEGIN_BODY statements END_BODY { printf("function -> FUNCTION identifier DOT BEGIN_PARAMS declarations END_PARAMS BEGIN_LOCALS declarations END_LOCALS BEGIN_BODY statements END_BODY \n"); }
                ;

declarations:   %empty { printf("declarations -> epsilon \n"); }
                | declaration DOT declarations { printf("declarations -> declaration DOT declarations \n"); }
                ;

declaration:    identifier COLON DIGIT { printf("declaration -> identifier COLON DIGIT \n"); }
                | identifier COLON DIGIT ARRAY LEFT_BRACKET RIGHT_BRACKET SIZE number { printf("declaration -> identifier COLON DIGIT ARRAY LEFT_BRACKET RIGHT_BRACKET SIZE number \n"); }
                | error { yyerror("Incorrect declaration structure"); }
                ;

identifier:     IDENT { printf("identifier -> IDENT %s \n", $1); }
                ;

number:         NUMBER { printf("number -> NUMBER %d \n", $1); }
                ;

statements:     %empty { printf("statements -> epsilon \n"); }
                | statement statements { printf("statements -> statement statements \n"); }
                ;



statement:      var ASSIGN expression DOT{ printf("statement -> var ASSIGN expression DOT\n"); }
                | IF boolexp LEFT_BRACE statement RIGHT_BRACE else { printf("statement -> IF boolexp LEFT_BRACE statement RIGHT_BRACE else \n"); }
                | IF IDENT LEFT_BRACE statement RIGHT_BRACE else { printf("statement -> IF IDENT LEFT_BRACE statement RIGHT_BRACE else \n"); }
                | WHILE boolexp LEFT_BRACE statement RIGHT_BRACE { printf("statement -> WHILE boolexp LEFT_BRACE statement RIGHT_BRACE \n"); }
                | IF boolexp LEFT_BRACE statements RIGHT_BRACE else { printf("statement -> IF boolexp LEFT_BRACE statements RIGHT_BRACE else \n"); }
                | IF IDENT LEFT_BRACE statements RIGHT_BRACE else { printf("statement -> IF IDENT LEFT_BRACE statements RIGHT_BRACE else \n"); }
                | WHILE boolexp LEFT_BRACE statements RIGHT_BRACE { printf("statement -> WHILE boolexp LEFT_BRACE statements RIGHT_BRACE \n"); }
                | READ LEFT_PARAN expression RIGHT_PARAN DOT{ printf("statement -> READ LEFT_PARAN expression RIGHT_PARAN \n"); }
                | WRITE LEFT_PARAN expression RIGHT_PARAN DOT{ printf("statement -> WRITE LEFT_PARAN expression RIGHT_PARAN \n"); }
                | RETURN expression DOT { printf("RETURN expression DOT\n"); }
                | CONTINUE DOT { printf("statement -> CONTINUE \n"); }
                | STOP DOT{ printf("statement -> STOP \n"); }
                ;

else:           %empty { printf("else -> epsilon \n"); }
                | ELSE LEFT_BRACE statements RIGHT_BRACE { printf("else -> ELSE LEFT_BRACE statements RIGHT_BRACE \n"); }
                ;

boolexp:        expression comp expression { printf("boolexp -> expression comp expression \n"); }
                | NOT expression comp expression { printf("boolexp -> NOT expression comp expression \n"); }
                ;

comp:           EQ { printf("comp -> EQ \n"); }
                | LT  { printf("comp -> LT \n"); }
                | GT  { printf("comp -> GT \n"); }
                | LTE  { printf("comp -> LTE \n"); }
                | GTE  { printf("comp -> GTE \n"); }
                | NEQ  { printf("comp -> NEQ \n"); }
                ;

expression:     multexpr { printf("expression -> multexpr \n"); }
                | multexpr ADD multexpr  { printf("expression -> multexpr ADD multexpr \n"); }
                | multexpr SUB multexpr  { printf("expression -> multexpr SUB multexpr \n"); }
                ;

multexpr:       term { printf("multexpr -> term \n"); }
                | term MULT term { printf("multexpr -> term MULT term \n"); }
                | term DIV term  { printf("multexpr -> term DIV term \n"); }
                | term MOD term  { printf("multexpr -> term MOD term \n"); }
                ;

term:           var { printf("term -> var \n"); }
                | number { printf("term -> number \n"); }
                | LEFT_PARAN expression RIGHT_PARAN { printf("term -> LEFT_PARAN expression RIGHT_PARAN \n"); }
                ;

var:            identifier { printf("var -> identifier \n"); }
                | identifier LEFT_BRACKET expression RIGHT_BRACKET { printf("var -> identifier LEFT_BRACKET expression RIGHT_BRACKET \n"); }
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
