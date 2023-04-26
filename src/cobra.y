/* Parser Generation */
/* cobra.y */

%{
#include <stdio.h>
#include <stdlib.h>

/*int yyerror(char *s);*/
/*int yylex();*/
/*int yyparse();*/

extern int yylex();
extern int yyparse();
extern FILE* yyin;

void yyerror(const char* s);
%}

%union{
  int		digit_val;
  string*	ident_val;
}

%define yylval YYSTYPE

%start function

%token	<digit_val>	DIGIT
%type   <ident_val> declarations
%type   <ident_val> statements
%left	FUNCTION
%left	IDENT
%left	DOT
%left   BEGIN_PARAMS END_PARAMS
%left   BEGIN_LOCALS END_LOCALS
%left   BEGIN_BODY END_BODY


%%

function:       %empty
                | FUNCTION IDENT DOT BEGIN_PARAMS declarations END_PARAMS BEGIN_LOCALS declarations END_LOCALS BEGIN_BODY statements END_BODY { printf("function -> FUNCTION..."); }
                ;

declarations:   %empty
                ;

statements:     %empty
                ;

%%
/*
int main() {
  yyin = stdin;

  do {
    printf("Parse.\n");
    yyparse();
  } while(!feof(yyin));
  printf("Parenthesis are balanced!\n");
  return 0;
}

void yyerror(const char* s) {
  fprintf(stderr, "Parse error: %s. Parenthesis are not balanced!\n", s);
  exit(1);
}
*/

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
  fprintf(stderr, "ERROR: Parse error %s.\n", s);
  exit(1);
}


/*
int yyerror(string s)
{
  extern int yylineno;	// defined and maintained in lex.c
  extern char *yytext;	// defined and maintained in lex.c

  cerr << "ERROR: " << s << " at symbol \"" << yytext;
  cerr << "\" on line " << yylineno << endl;
  exit(1);
}


int yyerror(char *s)
{
  return yyerror(string(s));
}
*/
