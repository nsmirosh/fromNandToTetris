// This file is part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
// File name: projects/04/Mult.asm

// Multiplies R0 and R1 and stores the result in R2.
// (R0, R1, R2 refer to RAM[0], RAM[1], and RAM[2], respectively.)

// create a variable sum, iterator, n and initialize them to 0
@sum
M=0
@iterator
M=0
@n
M=0

// get the value of R0 and store it a variable 'n'
@R0
D=M
@n
M=D

(LOOP)
 // break the loop if we reach the value of n and goto the end of the program
 @iterator
 D=M
 @n
 D=D-M
 @SAVE_RESULT
 D;JEQ

 //increment sum by the value of R1
 @R1
 D=M
 @sum
 M=M+D

 //increment iterator
 @iterator
 M=M+1

 @LOOP
 0;JMP

// store the result of sum in R2
(SAVE_RESULT)
@sum
D=M
@R2
M=D

(END)
@END
0;JMP