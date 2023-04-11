# CS 152 Compiler Design Project - Phase 0

**Team 14**
* Rohit Manimaran - 862147396
* Vishal Menon - 862163065
* Lorenzo Largacha Sanz - 862396020

## Language name
* cobra

## Extension name
* .rlv

## Name for the compiler
* snake

## Compiler features and code example
| Language Feature                                                      | Code Example                                                                                                                     |
|-----------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------|
| Integer scalar variables                                              | digit x.                                                                                                                         |
| One-dimensional arrays of integers                                    | digit arr[x, y, z].                                                                                                              |
| Assignment statements                                                 | x = 1.                                                                                                                           |
| Arithmetic operators (e.g., “+”, “-”, “*”, “/”)                       | sum, sub, mult, div                                                                                                              | 
| Relational operators (e.g., “<”, “==”, “>”, “!=”)                     | lessthan, equals, greaterthan, notequals                                                                                         |
| While loop (including "break" and "continue" loop control statements) | during 2 {<br>such x lessthan 3 stop.<br>x = x sub 1.<br>}<br><br>during 2 {<br>such x lessthan 3 continue.<br>x = x sum 1.<br>} |
| If-then-else statements                                               | such x equals y {<br>shout “Hello”.<br>}<br>next {<br>shout “World”.<br>}                                                        |
| Read and write statements                                             | temp = open(“path/example.txt”, “s”).<br>shout(temp.study())                                                                     |
| Comments                                                              | // comment<br><br>~<br>Multi-Line<br>comment<br>~                                                                                |

## Valid identifier
* Identifiers can only contain letters (both upper and lower case), digits, and underscores. The first character must be a letter or underscore

## Whether your language is case-sensitive or not
* It is not, variables can start with uppercase or lowercase

## What would be white spaces in your language?
* Spaces, tabs and newlines are whitespaces in Cobra. Indenting does not matter

## Tokens list
| Symbol in Language                                                   | Token         |
|----------------------------------------------------------------------|---------------|
| <center> Arithmetic Operators </center>                              |               |
| =                                                                    | ASSIGN        |
| sum                                                                  | ADD           | 
| sub                                                                  | SUB           |
| mult                                                                 | MULT          | 
| div                                                                  | DIV           | 
| mod                                                                  | MOD           |
| <center> Comparison Operators </center>                              |               | 
| equals                                                               | EQ            | 
| notequals                                                            | NEQ           |
| lessthan                                                             | LT            | 
| greaterthan                                                          | GT            | 
| lessorequal                                                          | LTE           |
| greaterorequal                                                       | GTE           | 
| <center> Reserved Words </center>                                    |               |
| funct                                                                | FUNCTION      | 
| params {                                                             | BEGIN_PARAMS  | 
| } params                                                             | END_PARAMS    |
| locals {                                                             | BEGIN_LOCALS  |
| } locals                                                             | END_LOCALS    |
| body {                                                               | BEGIN_BODY    |
| } body                                                               | END_BODY      |
| digit                                                                | DIGIT         |
| during                                                               | WHILE         | 
| arr[]                                                                | ARRAY         |
| such                                                                 | IF            | 
| next                                                                 | NEXT          |
| stop                                                                 | STOP          |
| stopif                                                               | ENDIF         |
| return                                                               | RETURN        |
| same                                                                 | SAME          |
| <center> Identifiers and Symbols </center>                           |               | 
| identifier (e.g., "aardvark", "BIG_PENGUIN", "fLaMInGo_17", "ot73r") | IDENT XXXX    | 
| number (e.g., "17", "101", "90210", "0", "8675309")                  | NUMBER XXXX   | 
| <center> Other Special Symbols </center>                             |               | 
| .                                                                    | DOT           |
| :                                                                    | COLON         |
| (                                                                    | LEFT_PARAN    |
| )                                                                    | RIGHT_PARAN   |
| {                                                                    | LEFT_BRACE    |
| }                                                                    | RIGHT_BRACE   | 
| [                                                                    | LEFT_BRACKET  | 
| ]                                                                    | RIGHT_BRACKET |
| ,                                                                    | COMMA         |
| //                                                                   | COMMENT       |
| _                                                                    | UNDERSCORE    |
| "                                                                    | QUOTATION     |
