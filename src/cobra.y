/* Parser Generation - Syntax Analysis */
/* cobra.y */

%{
#include <stdio.h>
#include <stdlib.h>
#include <string>
#include <vector>
#include <string.h>

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

// Remember that Bison is a bottom up parser: that it parses leaf nodes first before parsing the parent nodes.
// So control flow begins at the leaf grammar nodes and propagates up to the parents.
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

bool has_main() {
  bool TF = false;
  for(int i = 0; i < symbol_table.size(); i++) {
    Function *f = &symbol_table[i];
    if (f->name == "main")
      TF = true;
  }
  return TF;
}

std::string create_temp() {
  static int num = 0;
  std::string value = "_temp" + std::to_string(num);
  num += 1;
  return value;
}

std::string decl_temp_code(std::string &temp) {
  return std::string(". ") + temp + std::string("\n");
}

%}

%union {
  int       number_val;
  char*     ident_val;
  struct    CodeNode *node;
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

%type   <code_node>     functions
%type   <code_node>     function
%type   <code_node>     declarations
%type   <code_node>     declaration
%type   <code_node>     statements
%type   <code_node>     statement

%type   <ident_val>     identifier
%type   <number_val>    number


%%
prog_start:     functions {
                    CodeNode *code_node = $1;
                    printf("%s\n", code_node->code.c_str());
                }

functions:      %empty {
                    CodeNode *node = new CodeNode;
                    $$ = node;
                }
                | function functions {
                    CodeNode *function = $1;
                    CodeNode *functions = $2;
                    CodeNode *node = new CodeNode;
                    node->code = function->code + functions->code;
                    $$ = node;
                }
                ;

function:       FUNCTION identifier DOT BEGIN_PARAMS declarations END_PARAMS BEGIN_LOCALS declarations END_LOCALS BEGIN_BODY statements END_BODY {
                    CodeNode *node = new CodeNode;
                    std::string func_name = $2;
                    node->code = "";
                    // Add function name
                    node->code += std::string("func ") + func_name + std::string("\n");
                    // Add param declarations
                    CodeNode *params = $5;
                    node->code += params->code;
                    // Add local declarations
                    CodeNode *locals = $8;
                    node->code += locals->code;
                    // Add statements
                    CodeNode *statements = $11;
                    node->code += statements->code;
                    node->code += std::string("endfunc\n");
                    $$ = node;
                }
                ;

function_ident: IDENT {
                    // add the function to the symbol table
                    //std::string func_name = $1;
                    //add_function_to_symbol_table(func_name);
                    //printf("func %s\n", func_name.c_str());
                }
                ;

declarations:   %empty {
                    CodeNode *node = new CodeNode;
                    $$ = node;
                }
                | declaration DOT declarations {
                    CodeNode *declaration = $1;
                    CodeNode *declarations = $3;
                    CodeNode *node = new CodeNode;
                    node->code = declaration->code + declarations->code;
                    $$ = node;
                }
                ;

declaration:    identifier COLON DIGIT {
                    CodeNode *node = new CodeNode;
                    std::string id = $1;
                    node->code = std::string(". ") + id + std::string("\n");
                    $$ = node;
                }
                | identifier COLON DIGIT ARRAY LEFT_BRACKET RIGHT_BRACKET SIZE number {

                }
                | error { yyerror("Incorrect declaration structure"); }
                ;

identifier:     IDENT { $$ = $1 }
                ;

number:         NUMBER { $$ = $1 }
                ;

statements:     %empty {
                    CodeNode *node = new CodeNode;
                    $$ = node;
                }
                | statement statements {
                    CodeNode *statement = $1;
                    CodeNode *statements = $2;
                    CodeNode *node = new CodeNode;
                    node->code = statement->code + statements->code;
                    $$ = node;
                }
                ;



statement:      identifier ASSIGN expression DOT {
                    CodeNode *node = new CodeNode;
                    std::string id = $1;
                    CodeNode *expression = $3;
                    node->code = expression->code;
                    node->code += std::string("= ") + id + std::string(", ") + expression->name + std::string("\n");
                    $$ = node;
                }
                | identifier LEFT_BRACKET expression RIGHT_BRACKET ASSIGN expression DOT {

                }
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

term:           var { $$ = $1 }
                | number { $$ = $1 }
                | LEFT_PARAN expression RIGHT_PARAN {  }
                ;

var:            identifier { $$ = $1 }
                | identifier LEFT_BRACKET expression RIGHT_BRACKET {
                    std::string temp = create_temp();
                    CodeNode *node = new CodeNode;
                    // Recursion and create temporary variable
                    node->code = $3->code + decl_temp_code(temp);
                    // Array assignment: =[] dst, src, index
                    node->code += std::string("=[] ") + temp + std::string(", ") +
                    node->name = temp;
                }
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
