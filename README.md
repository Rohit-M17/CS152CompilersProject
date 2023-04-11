# CS 152 Compiler Design Project - Phase 0
## Language name
cobra

## Extension name
.rlv

## Name for the compiler
snake

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
Identifiers can only contain letters (both upper and lower case), digits, and underscores. The first character must be a letter or underscore

## Whether your language is case-sensitive or not
It is not, variables can start with uppercase or lowercase

## What would be whitespces in your language
Spaces, tabs and newlines are whitespaces in Cobra. Indenting does not matter

## Tokens list
| Symbol in Language       | Token  |
|--------------------------|--------|
| **Arithmetic Operators** |        |
| =                        | ASSIGN |
| sum                      | ADD    | 
|                          |        |

