/* Parser Generation */
/* cobra.y */

%{
#include <stdio.h>
#include <stdlib.h>

int yyerror(char *s);
int yylex(void);

/* extern int yylex(); */
extern int yyparse();
/* extern FILE* yyin; */

void yyerror(const char* s);
%}

%union{
  int		int_val;
  string*	op_val;
}

%start function

%token	<int_val>	INTEGER_LITERAL
%type	<int_val>	exp
%left	PLUS
%left	MULT


%%

input:      /* empty */
		    | exp	{ cout << "Result: " << $1 << endl; }
		    ;

exp:		INTEGER_LITERAL	{ $$ = $1; }
		    | exp PLUS exp	{ $$ = $1 + $3; }
		    | exp MULT exp	{ $$ = $1 * $3; }
		    ;

function:   /* empty */
            | FUNCTION IDENT SEMICOLON BEGIN_PARAMS declarations END_PARAMS BEGIN_LOCALS declarations END_LOCALS BEGIN_BODY statements END_BODY
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

int main(int argc, char **argv)
{
  if ((argc > 1) && (freopen(argv[1], "r", stdin) == NULL))
  {
    cerr << argv[0] << ": File " << argv[1] << " cannot be opened.\n";
    exit( 1 );
  }

  yyparse();

  return 0;
}


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

