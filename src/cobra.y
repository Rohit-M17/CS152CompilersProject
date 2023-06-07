/* Parser Generation - Syntax Analysis */
/* Code Generation   - Semantic Analysis */
/* cobra.y */

%{
#include <stdio.h>
#include <stdlib.h>
#include <string>
#include <vector>
#include <string.h>
#include <sstream>
#include <stdbool.h>

extern int yylex();
extern int yyparse();
extern FILE* yyin;

bool inputFileHasErrors = false;

void yyerror_lexical(const char* msg);
void yyerror(const char* s);
void yyerror_semantic(const char* msg);


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

// Function to generate the code that gets the function parameters
std::string get_function_parameters() {
    std::string parameters_code = "";
    Function *f = get_function();
    for(int i=0; i < f->declarations.size(); i++) {
        Symbol *param = &f->declarations[i];                // Loop through the vector of declarations of the function
        std::stringstream ss;
        ss << i;
        // Get the function parameter value: = dst, $0
        parameters_code += std::string("= ") + param->name + std::string(", $") + ss.str() + std::string("\n");
    }
    return parameters_code;
}

// Function to find a particular variable using the symbol table,
// grab the most recent function, and linear search to find the symbol you are looking for.
bool find(std::string &value, Type t, std::string &error) {
    Function *f = get_function();
    for(int i=0; i < f->declarations.size(); i++) {
        Symbol *s = &f->declarations[i];
        if (s->name == value) {
            if (s->type == t) {
                return true;
            }
            else {
                if (t == Integer) {
                    error = "Used array variable " + value + " is missing a specified index";
                } else {
                    error = "Specifying an index for the integer variable " + value + " which is not an array";
                }
                return false;
            }
        }
        else {
            error = "Using identifier " + value + " without having first declared it";
        }
    }
    return false;
}

// Function to add a function name to the symbol table
void add_function_to_symbol_table(std::string &value) {
    Function f;
    f.name = value;
    symbol_table.push_back(f);
}

// Function to add a symbol name and type information to the symbol table
void add_variable_to_symbol_table(std::string &value, Type t) {
    Function *foo = get_function();
    for (int i = 0; i < foo->declarations.size(); i++) {
        Symbol *s = &foo->declarations[i];
        // Check if the variable is already declared
        if (s->name == value) {
            yyerror_semantic(("Variable " + value + " is multiply-defined").c_str());
        }
    }
    Symbol s;
    s.name = value;
    s.type = t;
    Function *f = get_function();
    f->declarations.push_back(s);
}

// Function to print out the symbol table to the screen (debugging purposes)
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

// Function to check if the program has a main function
bool has_main() {
    bool TF = false;
    for(int i = 0; i < symbol_table.size(); i++) {
        Function *f = &symbol_table[i];
        if (f->name == "main")
            TF = true;
    }
    return TF;
}

// Function to create a temporary variable (register)
std::string create_temp() {
    static int num = 0;
    std::stringstream ss;
    ss << num;
    std::string value = "_temp" + ss.str();
    num += 1;
    return value;
}

// Function to create an if label
std::string create_if_label() {
    static int num = 0;
    std::stringstream ss;
    ss << num;
    std::string value = "if_true" + ss.str();
    num += 1;
    return value;
}

// Function to create an endif label
std::string create_endif_label() {
    static int num = 0;
    std::stringstream ss;
    ss << num;
    std::string value = "endif" + ss.str();
    num += 1;
    return value;
}

// Function to create an else label
std::string create_else_label() {
    static int num = 0;
    std::stringstream ss;
    ss << num;
    std::string value = "else" + ss.str();
    num += 1;
    return value;
}

// Function to create beginloop label
std::string create_loopstart_label(){
        static int num;
        std::stringstream ss;
        ss << num;
        std::string value = "beginloop" + ss.str();
        num += 1;
        return value; 
}

// Function to create loopbody label
std::string create_while_label() {
        static int num;
        std::stringstream ss;
        ss << num;
        std::string value = "loopbody" + ss.str();
        num += 1;
        return value;
}

// Function to create endloop label
std::string create_endloop_label() {
    static int num;
    std::stringstream ss;
    ss << num;
    std::string value = "endloop" + ss.str();
    num += 1;
    return value;
}

// Function to generate the code that creates a temporary variable
std::string decl_temp_code(std::string &temp) {
    return std::string(". ") + temp + std::string("\n");
}

// Function to generate the code that creates a branch statement
std::string branch_code(std::string &label) {
    return std::string(":= ") + label + std::string("\n");
}

// Function to generate the code that declares a label
std::string decl_label_code(std::string &label) {
    return std::string(": ") + label + std::string("\n");
}

// Function to check if a function has been defined
bool is_function_defined(const std::string &functionName) {
    for (int i=0; i<symbol_table.size(); i++) {
        if (symbol_table[i].name.c_str() == functionName) {
            return true;
        }
    }
    return false;
}

// Code to maintain the loop label stack
std::stack<std::string> loopLabelStack;

// Function to push a loop label onto the stack
void pushLoopLabel(const std::string& label) {
    loopLabelStack.push(label);
}

// Function to pop a loop label from the stack
void popLoopLabel() {
    loopLabelStack.pop();
}

%}


%union {
    int     number_val;
    char*   ident_val;
    struct  CodeNode *code_node;
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
%type   <code_node>     parameters
%type   <code_node>     declarations
%type   <code_node>     declaration
%type   <code_node>     statements
%type   <code_node>     statement
%type   <code_node>     else
%type   <code_node>     function_call
%type   <code_node>     arguments
%type   <code_node>     boolexp
%type   <code_node>     expression
%type   <code_node>     multexpr
%type   <code_node>     term
%type   <code_node>     var
%type   <code_node>     comp
%type   <code_node>     if_statements
%type   <code_node>     loop_statements
%type   <code_node>     loop_statement

%type   <ident_val>     identifier
%type   <ident_val>     function_ident
%type   <number_val>    number


%%
prog_start:     functions {
                    CodeNode *node = $1;
                    if (!has_main()) {
                        yyerror_semantic("Main function not defined");
                    }
                    if (inputFileHasErrors == false) {
                        printf("%s\n", node->code.c_str());
                    } else {
                        exit(1);
                    }

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

function:       FUNCTION function_ident DOT BEGIN_PARAMS parameters END_PARAMS BEGIN_LOCALS declarations END_LOCALS BEGIN_BODY statements END_BODY {
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
                    // Add the function to the symbol table
                    std::string func_name = $1;
                    add_function_to_symbol_table(func_name);
                    $$ = $1;
                }
                ;

parameters:     declarations {
                    CodeNode *node = new CodeNode;
                    CodeNode *declarations = $1;
                    node->code = declarations->code;
                    // Generate the code to get the function parameters
                    node->code += get_function_parameters();
                    $$ = node;
                }

declarations:   %empty {
                    CodeNode *node = new CodeNode;
                    $$ = node;
                }
                | declaration DOT declarations {
                    CodeNode *node = new CodeNode;
                    CodeNode *declaration = $1;
                    CodeNode *declarations = $3;
                    node->code = declaration->code + declarations->code;
                    $$ = node;
                }
                ;

declaration:    identifier COLON DIGIT {
                    CodeNode *node = new CodeNode;
                    std::string id = $1;
                    add_variable_to_symbol_table(id, Integer);
                    // Variable declaration: . name
                    node->code = std::string(". ") + id + std::string("\n");
                    $$ = node;
                }
                | identifier COLON DIGIT ARRAY LEFT_BRACKET RIGHT_BRACKET SIZE number {
                    CodeNode *node = new CodeNode;
                    std::string id = $1;
                    std::stringstream ss;
                    ss << $8;
                    std::string size = ss.str();
                    add_variable_to_symbol_table(id, Array);
                    // Array declaration: .[] name, n
                    node->code = std::string(".[] ") + id + std::string(", ") + size + std::string("\n");
                    $$ = node;
                }
                | error { yyerror("Incorrect declaration structure"); }
                ;

identifier:     IDENT { $$ = $1; }
                ;

number:         NUMBER { $$ = $1; }
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

if_statements:  statement statements {
                    CodeNode *statement = $1;
                    CodeNode *statements = $2;
                    CodeNode *node = new CodeNode;
                    node->code = statement->code + statements->code;
                    $$ = node;
                }
                ;

loop_statements: loop_statement {
                    CodeNode *statement = $1;
                    CodeNode *node = new CodeNode;
                    node->code = statement->code;
                    $$ = node;
                }
                | loop_statement loop_statements {
                    CodeNode *statement = $1;
                    CodeNode *statements = $2;
                    CodeNode *node = new CodeNode;
                    node->code = statement->code + statements->code;
                    $$ = node;
                }
                ;

loop_statement: statement {
                    CodeNode *statement = $1;
                    CodeNode *node = new CodeNode;
                    node->code = statement->code;
                    $$ = node;
                }
                | CONTINUE DOT {
                    CodeNode *node = new CodeNode;
                    node->code = std::string("continue\n");
                    $$ = node;
                }
                | STOP DOT {
                    CodeNode* node = new CodeNode;
                    // Get the top loop label from the stack and generate the code accordingly
                    if (!loopLabelStack.empty()) {
                        std::string loopLabel = loopLabelStack.top();
                        node->code = "goto " + loopLabel + ";\n";
                    } else {
                        // Handle error: STOP statement encountered without an active loop
                        // You can throw an exception, print an error message, or handle it as per your requirements
                    }
                    $$ = node;
                }
                ;

statement:      identifier ASSIGN expression DOT {
                    CodeNode *node = new CodeNode;
                    std::string id = $1;
                    CodeNode *expression = $3;
                    node->code = expression->code;
                    // Variable assignment: = dst, src
                    node->code += std::string("= ") + id + std::string(", ") + expression->name + std::string("\n");
                    std::string error;
                    if (!find(id, Integer, error)) {
                        yyerror_semantic(error.c_str());
                    }
                    $$ = node;
                }
                | identifier ASSIGN function_call DOT {
                    CodeNode *node = new CodeNode;
                    std::string id = $1;
                    CodeNode *call = $3;
                    node->code = call->code;
                    // Variable assignment: = dst, src
                    node->code += std::string("= ") + id + std::string(", ") + call->name + std::string("\n");
                    std::string error;
                    if (!find(id, Integer, error)) {
                        yyerror_semantic(error.c_str());
                    }
                    $$ = node;
                }
                | identifier LEFT_BRACKET expression RIGHT_BRACKET ASSIGN expression DOT {
                    CodeNode *node = new CodeNode;
                    std::string id = $1;
                    CodeNode *index = $3;
                    CodeNode *source = $6;
                    node->code = index->code + source->code;
                    // Array assignment:  []= dst, index, src
                    node->code += std::string("[]= ") + id + std::string(", ") + index->name + std::string(", ") + source->name + std::string("\n");
                    std::string error;
                    if (!find(id, Array, error)) {
                        yyerror_semantic(error.c_str());
                    }
                    $$ = node;
                }
                | identifier LEFT_BRACKET expression RIGHT_BRACKET ASSIGN function_call DOT {
                    CodeNode *node = new CodeNode;
                    std::string id = $1;
                    CodeNode *index = $3;
                    CodeNode *call = $6;
                    node->code = index->code + call->code;
                    // Array assignment:  []= dst, index, src
                    node->code += std::string("[]= ") + id + std::string(", ") + index->name + std::string(", ") + call->name + std::string("\n");
                    std::string error;
                    if (!find(id, Array, error)) {
                        yyerror_semantic(error.c_str());
                    }
                    $$ = node;
                }
                | IF boolexp LEFT_BRACE if_statements RIGHT_BRACE else {
                    CodeNode *node = new CodeNode;
                    std::string if_true_label = create_if_label();
                    std::string endif_label = create_endif_label();
                    CodeNode *condition = $2;
                    CodeNode *if_statements = $4;
                    CodeNode *else_statements = $6;

                    // If Statement:  ?:= label, predicate        if predicate is true (1) goto label
                    //                : label
                    // Recursion to evaluate the condition and create if_true branch statement
                    node->code = condition->code + std::string("?:= ") + if_true_label + std::string(", ") + condition->name + std::string("\n");

                    // Branch to endif or else  := label          goto label
                    std::string else_label = else_statements->name;
                    if (else_label != "") {
                        node->code += branch_code(else_label);
                    } else {
                        node->code += branch_code(endif_label);
                    }

                    // If statements code
                    node->code += decl_label_code(if_true_label) + if_statements->code;
                    // Branch to endif if there is an else
                    if (else_label != "") {
                        node->code += branch_code(endif_label);
                    }

                    // Else statements code
                    node->code += else_statements->code;

                    // endif label
                    node->code += decl_label_code(endif_label);

                    $$ = node;
                }
                | WHILE boolexp LEFT_BRACE loop_statements RIGHT_BRACE {
                    CodeNode* node = new CodeNode;
                    std::string beginloop_label = create_loopstart_label();
                    std::string whileloop_label = create_while_label();
                    std::string endloop_label = create_endloop_label();
                    CodeNode* condition = $2;
                    CodeNode* while_statements = $4;
                    
                    // Push the beginloop_label onto the loop label stack
                    pushLoopLabel(beginloop_label);
                    
                    // While Statement: ?:= label, predicate while predicate is true (1) goto label
                    // : label
                    // Recursion to evaluate the condition and create beginloop branch statement
                    node->code = std::string(": ") + beginloop_label + std::string("\n") + condition->code + std::string("?:=") + whileloop_label + std::string(", ") + condition->name + std::string("\n");

                    // beginloop statements code
                    node->code += decl_label_code(beginloop_label);

                    // While statements code
                    node->code += decl_label_code(whileloop_label) + while_statements->code;
                
                    // Jump back to the beginning of the loop if the condition is true
                    node->code += "if (" + condition->name + ") goto " + beginloop_label + ";\n";
                    node->code += decl_label_code(endloop_label);
                    // Pop the loop label from the stack
                    popLoopLabel();
                    $$ = node;
                }
                | READ LEFT_PARAN var RIGHT_PARAN DOT {
                    // Reads from std_input and writes it into a variable
                    CodeNode *node = new CodeNode;
                    CodeNode *dest = $3;
                    // Output statement: .< dst
                    node->code += std::string(".< ") + dest->name + std::string("\n");
                    $$ = node;
                }
                | WRITE LEFT_PARAN expression RIGHT_PARAN DOT {
                    CodeNode *node = new CodeNode;
                    CodeNode *expression = $3;
                    // Output statement: .> src
                    node->code = expression->code;
                    node->code += std::string(".> ") + expression->name + std::string("\n");
                    $$ = node;
                }
                | RETURN expression DOT {
                    CodeNode *node = new CodeNode;
                    CodeNode *expression = $2;
                    // Output statement: ret src
                    node->code = expression->code;
                    node->code += std::string("ret ") + expression->name + std::string("\n");
                    $$ = node;
                }
                ;

else:           %empty {
                    CodeNode *node = new CodeNode;
                    node->name = "";
                    $$ = node;
                }
                | ELSE LEFT_BRACE statements RIGHT_BRACE {
                    CodeNode *node = new CodeNode;
                    std::string else_label = create_else_label();
                    CodeNode *else_statements = $3;

                    node->code = decl_label_code(else_label);
                    node->code += else_statements->code;
                    node->name = else_label;
                    $$ = node;
                }
                ;

function_call:  identifier LEFT_PARAN arguments RIGHT_PARAN {
                    CodeNode *node = new CodeNode;
                    std::string temp = create_temp();
                    std::string funct_name = $1;
                    CodeNode *arguments = $3;
                    // Recursion and create temporary variable
                    node->code = arguments->code + decl_temp_code(temp);
                    // Function call: call name, dest
                    node->code += std::string("call ") + funct_name + std::string(", ") + temp + std::string("\n");
                    node->name = temp;

                    if (!is_function_defined(funct_name)) {
                        yyerror_semantic(("Undefined function " + funct_name).c_str());
                    }
                    $$ = node;
                }
                ;

arguments:      %empty {
                    CodeNode *node = new CodeNode;
                    $$ = node;
                }
                | expression {
                    $$ = $1;
                }
                | arguments COMMA expression {
                    CodeNode *node = new CodeNode;
                    CodeNode *arg1 = $1;
                    CodeNode *arg2 = $3;
                    // Add parameters to the queue of parameters for the next function call
                    node->code = arg1->code;
                    node->code += std::string("param ") + arg1->name + std::string("\n");
                    node->code += arg2->code;
                    node->code += std::string("param ") + arg2->name + std::string("\n");
                    $$ = node;
                }
                ;

boolexp:        expression comp expression {
                    std::string temp = create_temp();
                    CodeNode *node = new CodeNode;
                    CodeNode *src1 = $1;
                    CodeNode *op = $2;
                    CodeNode *src2 = $3;
                    // Recursion and create temporary variable
                    node->code = src1->code + src2->code + decl_temp_code(temp);
                    // Comparison operator statements: < dst, src1, src2
                    node->code += op->name + std::string(" ") + temp + std::string(", ") + src1->name + std::string(", ") + src2->name + std::string("\n");
                    node->name = temp;
                    $$ = node;
                }
                | NOT expression comp expression {
                    // PROVISIONAL, just for testing, needs to be changed
                    CodeNode *node = new CodeNode;
                    $$ = node;
                }
                ;

comp:           EQ {
                    CodeNode *node = new CodeNode;
                    node->code = "";
                    node->name = "==";
                    $$ = node;
                }
                | LT {
                    CodeNode *node = new CodeNode;
                    node->code = "";
                    node->name = "<";
                    $$ = node;
                }
                | GT {
                    CodeNode *node = new CodeNode;
                    node->code = "";
                    node->name = ">";
                    $$ = node;
                }
                | LTE {
                    CodeNode *node = new CodeNode;
                    node->code = "";
                    node->name = "<=";
                    $$ = node;
                }
                | GTE {
                    CodeNode *node = new CodeNode;
                    node->code = "";
                    node->name = ">=";
                    $$ = node;
                }
                | NEQ {
                    CodeNode *node = new CodeNode;
                    node->code = "";
                    node->name = "!=";
                    $$ = node;
                }
                ;

expression:     multexpr { $$ = $1; }
                | multexpr ADD multexpr {
                    CodeNode *node = new CodeNode;
                    std::string temp = create_temp();
                    CodeNode *leftexpr = $1;
                    CodeNode *rightexpr = $3;
                    // Recursion and create temporary variable
                    node->code = leftexpr->code + rightexpr->code + decl_temp_code(temp);
                    // Add expression: + dst, src1, src2
                    node->code += std::string("+ ") + temp + std::string(", ") + leftexpr->name + std::string(", ") + rightexpr->name + std::string("\n");
                    node->name = temp;
                    $$ = node;
                }
                | multexpr SUB multexpr {
                    CodeNode *node = new CodeNode;
                    std::string temp = create_temp();
                    CodeNode *leftexpr = $1;
                    CodeNode *rightexpr = $3;
                    // Recursion and create temporary variable
                    node->code = leftexpr->code + rightexpr->code + decl_temp_code(temp);
                    // Subtract expression: - dst, src1, src2
                    node->code += std::string("- ") + temp + std::string(", ") + leftexpr->name + std::string(", ") + rightexpr->name + std::string("\n");
                    node->name = temp;
                    $$ = node;
                }
                ;

multexpr:       term { $$ = $1; }
                | term MULT term {
                    CodeNode *node = new CodeNode;
                    std::string temp = create_temp();
                    CodeNode *leftexpr = $1;
                    CodeNode *rightexpr = $3;
                    // Recursion and create temporary variable
                    node->code = leftexpr->code + rightexpr->code + decl_temp_code(temp);
                    // Multiply expression: * dst, src1, src2
                    node->code += std::string("* ") + temp + std::string(", ") + leftexpr->name + std::string(", ") + rightexpr->name + std::string("\n");
                    node->name = temp;
                    $$ = node;
                }
                | term DIV term {
                    CodeNode *node = new CodeNode;
                    std::string temp = create_temp();
                    CodeNode *leftexpr = $1;
                    CodeNode *rightexpr = $3;
                    // Recursion and create temporary variable
                    node->code = leftexpr->code + rightexpr->code + decl_temp_code(temp);
                    // Divide expression: / dst, src1, src2
                    node->code += std::string("/ ") + temp + std::string(", ") + leftexpr->name + std::string(", ") + rightexpr->name + std::string("\n");
                    node->name = temp;
                    $$ = node;
                }
                | term MOD term {
                    CodeNode *node = new CodeNode;
                    std::string temp = create_temp();
                    CodeNode *leftexpr = $1;
                    CodeNode *rightexpr = $3;
                    // Recursion and create temporary variable
                    node->code = leftexpr->code + rightexpr->code + decl_temp_code(temp);
                    // Mod expression: % dst, src1, src2
                    node->code += std::string("% ") + temp + std::string(", ") + leftexpr->name + std::string(", ") + rightexpr->name + std::string("\n");
                    node->name = temp;
                    $$ = node;
                }
                ;

term:           var {
                    CodeNode *node = new CodeNode;
                    CodeNode *var = $1;
                    node->code = var->code;
                    node->name = var->name;
                    $$ = node;
                }
                | number {
                    CodeNode *node = new CodeNode;
                    //std::string num = $1;
                    std::stringstream ss;
                    ss << $1;
                    std::string num = ss.str();
                    node->code = "";
                    node->name = num;
                    $$ = node;
                }
                | LEFT_PARAN expression RIGHT_PARAN {
                    CodeNode *node = new CodeNode;
                    CodeNode *expression = $2;
                    node->code = expression->code;
                    node->name = expression->name;
                    $$ = node;
                }
                ;

var:            identifier {
                    CodeNode *node = new CodeNode;
                    std::string id = $1;
                    node->code = "";
                    node->name = id;
                    std::string error;
                    if (!find(id, Integer, error)) {
                        yyerror_semantic(error.c_str());
                    }
                    $$ = node;
                }
                | identifier LEFT_BRACKET expression RIGHT_BRACKET {
                    CodeNode *node = new CodeNode;
                    std::string temp = create_temp();
                    std::string id = $1;
                    CodeNode *index = $3;
                    // Recursion and create temporary variable
                    node->code = index->code + decl_temp_code(temp);
                    // Array access: =[] dst, src, index
                    node->code += std::string("=[] ") + temp + std::string(", ") + id + std::string(", ") + index->name + std::string("\n");
                    node->name = temp;

                    std::string error;
                    if (!find(id, Array, error)) {
                        yyerror_semantic(error.c_str());
                    }
                    $$ = node;
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

void yyerror_lexical(const char* msg) {
    extern int yylineno;
    extern char *yytext;
    fprintf(stderr, "ERROR: (lexical error) %s", msg);
    //inputFileHasErrors = true;
    exit(1);
}

void yyerror(const char* s) {
    extern int yylineno;
    extern char *yytext;
    fprintf(stderr, "ERROR: (syntax error) %s on line %d, at token: %s \n", s, yylineno, yytext);
    exit(1);
}

void yyerror_semantic(const char* msg) {
    extern int yylineno;
    extern char *yytext;
    fprintf(stderr, "ERROR: (semantic error) %s on line %d, at token: %s \n", msg, yylineno, yytext);
    inputFileHasErrors = true;
}
