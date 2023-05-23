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

enum Type { Integer, Array };

struct CodeNode {
    std::string code;
    std::string name;
};

struct Symbol {
    std::string name;
    Type type;
};

struct Function {
    std::string name;
    std::vector<Symbol> declarations;
};

std::vector <Function> symbol_table;

// remember that Bison is a bottom up parser: that it parses leaf nodes first before
// parsing the parent nodes. So control flow begins at the leaf grammar nodes
// and propagates up to the parents.
Function *get_function() {
  int last = symbol_table.size()-1;
  if (last < 0) {
    printf("***Error. Attempt to call get_function with an empty symbol table\n");
    printf("Create a 'Function' object using 'add_function_to_symbol_table' before\n");
    printf("calling 'find' or 'add_variable_to_symbol_table'");
    //exit(1);
  }
  return &symbol_table[last];
}

// when you see a function declaration inside the grammar, add
// the function name to the symbol table
void add_function_to_symbol_table(std::string &value) {
  Function f;
  f.name = value;
  symbol_table.push_back(f);
}

// when you see a symbol declaration inside the grammar, add
// the symbol name as well as some type information to the symbol table
void add_variable_to_symbol_table(std::string &value, Type t) {
  Symbol s;
  s.name = value;
  s.type = t;
  Function *f = get_function();
  f->declarations.push_back(s);
}

// a function to print out the symbol table to the screen
// largely for debugging purposes.
void print_symbol_table(void) {
  printf("symbol table:\n");
  printf("--------------------\n");
  for(int i=0; i<symbol_table.size(); i++) {
    printf("function: %s\n", symbol_table[i].name.c_str());
    for(int j=0; j<symbol_table[i].declarations.size(); j++) {
      printf("  locals: %s\n", symbol_table[i].declarations[j].name.c_str());
    }
  }
  printf("--------------------\n");
}


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

function:       FUNCTION identifier DOT BEGIN_PARAMS declarations END_PARAMS BEGIN_LOCALS declarations END_LOCALS BEGIN_BODY statements END_BODY {
                std::string func_name = $2;
                add_function_to_symbol_table(func_name);
                printf("func %s\n", func_name.c_str()); }
                ;

declarations:   %empty {  }
                | declaration DOT declarations {  }
                ;

declaration:    identifier COLON DIGIT {  }
                | identifier COLON DIGIT ARRAY LEFT_BRACKET RIGHT_BRACKET SIZE number {  }
                | error { yyerror("Incorrect declaration structure"); }
                ;

identifier:     IDENT {  }
                ;

number:         NUMBER {  }
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
  print_symbol_table();

  return 0;
}

void yyerror(const char* s) {
  extern int yylineno;
  extern char *yytext;
  fprintf(stderr, "ERROR: (syntax error) %s on line %d, at token: %s \n", s, yylineno, yytext);
  exit(1);
}
