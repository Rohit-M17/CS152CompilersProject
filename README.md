# CS 152 Compiler Design Project

**Team 14**
* Rohit Manimaran - 862147396
* Vishal Menon - 862163065
* Lorenzo Largacha Sanz - 862396020

## How to run the code
```
In your terminal, navigate to the project folder: CS152CompilersProject/src  
Execute the command:            make  
And then execute the command:   ./cobra nameOfInputFile  
  
For example:                    ./cobra simple.rlv  

Or:                             ./cobra ../programs/array.rlv  
```

## Language name
* cobra

## Extension name
* .rlv

## Name for the compiler
* snake

## Compiler features and code example
| Language Feature                                                      | Code Example                                                                                                                                         |
|-----------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------|
| Integer scalar variables                                              | b : digit.                                                                                                                                           |
| One-dimensional arrays of integers                                    | digit arr[1, 2, 3].<br>digit arr[] size 5                                                                                                            |
| Assignment statements                                                 | x = 1.                                                                                                                                               |
| Arithmetic operators (e.g., “+”, “-”, “*”, “/”)                       | sum, sub, mult, div                                                                                                                                  | 
| Relational operators (e.g., “<”, “==”, “>”, “!=”)                     | lessthan, equals, greaterthan, notequals                                                                                                             |
| While loop (including "break" and "continue" loop control statements) | <pre>during 2 {<br>  such x lessthan 3 {stop.} <br>  x = x sub 1.<br>}<br><br>during 2 {<br>  such x lessthan 3 {continue.}<br>  x = x sum 1.<br>}   |
| If-then-else statements                                               | <pre>such x equals y {<br>  shout(“Hello”).<br>}<br>next {<br>  shout(“World”).<br>}                                                                 |
| Read and write statements                                             | <pre>read().<br>shout("Hello word").                                                                                                                 |
| Comments                                                              | <pre>// comment<br><br>~<br>Multi-Line<br>comment<br>~                                                                                               |
| Function                                                              | <pre>funct add.<br><br>params {<br>  a : digit.<br>  b : digit.<br>} params<br><br>locals {<br>} locals<br><br>body {<br>  return a sum b.<br>} body |

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
| next                                                                 | ELSE          |
| stop                                                                 | STOP          |
| continue                                                             | CONTINUE      | 
| return                                                               | RETURN        |
| read                                                                 | READ          |
| shout                                                                | WRITE         |
| not                                                                  | NOT           |
| size                                                                 | SIZE          |
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
