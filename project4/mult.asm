// the inputs of this program are the current values stored in R0 and R1 (i.e., the two top RAM locations).
// The program computes the product R0*R1 and stores the result in R2. 
// We assume (in this program) that R0>=0, R1>=0, and R0*R1<32768. 
// Your program need not test these conditions, but rather assume that they hold. 
// The supplied Mult.tst and Mult.cmp scripts will test your program on several representative data values.


// define counter i
@i
M=1

// save the value of R0 in R3
@R0
D=M
@R3
M=D

(LOOP) // label symbol indicated as ("Xxx") in the README
    @R1     // puts in A address R1
    D=M     // set the register D with the value contained in R1
    @i      // puts in A address i
    D=D-M   // subtract to the value contained in R1 the value contained in i
    @END    // Puts in the register A the memory location of the label (END) defined below
    D;JEQ   // if M[R1] - M[i] == 0 jumps to (END) (as the address of the label is in A) otherwise continue

    @R3     // load the address of R3 in A
    D=M     // D = M[R3]
    @R0     // load in D the value of the memory cell whose address is stored in A, so of R0
    M=D+M   // puts in R0 the value of itself + M[R3]

    @i      // load in A address i
    M=M+1   // increment M[i]
    @LOOP   // loads in the A register the memory address of the label (LOOP)
    0;JMP   // jump back to (LOOP) as it jumps to the memory location contained in A register
(END)
    @END
    @R0
    D=M
    @R2
    M=D
