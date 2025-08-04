// This program runs an infinite loop that listens to the keyboard input.
// When a key is pressed (any key), the program blackens the screen, namely, writes “black” in every pixel.
// When no key is pressed, the screen should be cleared. You may choose to blacken and clear the screen in
// any spatial order, as long as pressing a key continuously for long enough will result in a fully blackened
// screen and not pressing any key for long enough will result in a cleared screen. This program has a test
// script (Fill.tst) but no compare file, it should be checked by visibly inspecting the simulated screen.

// first solution

// start of counter for filling
@fillcell
M=0

// start of counter for clearing
@clearcell
M=0

(LOOP)
    // check if keyboard is pressed
    @KBD
    D=M
    @CLEAR
    D;JEQ   // if not pressed jump to CLEAR
    @FILL   
    0;JMP   // if pressed jump to FILL


(CLEAR)
    @fillcell   // reset fillcell for filling so when keyboard pressed start filling from start
    M=0

    @clearcell // clear screen cell
    D=M
    @SCREEN
    A=D+A
    M=0

    @1
    D=A
    @clearcell
    M=D+M

    @SCREEN
    D=A
    @clearcell
    D=M



    @LOOP // jump back to check condition
    0;JMP


(FILL)
    @clearcell // reset clearcell for clearing so when keyboard pressed start clearing from start
    M=0

    @fillcell // fill screen cell
    D=M
    @SCREEN
    A=D+A
    M=-1

    @1
    D=A
    @fillcell
    M=D+M


    @LOOP // jump back to check condition
    0;JMP



// second solution (no checks on start/end of screen)

@SCREEN
D=A
@position
M=D

(LOOP)
    // check if keyboard is pressed
    @KBD
    D=M
    @CLEAR
    D;JEQ   // if not pressed jump to CLEAR
    @FILL   
    0;JMP   // if pressed jump to FILL


(CLEAR)
    @position
    A=M
    M=0

    @position
    D=M-1
    @position
    M=D

    @LOOP // jump back to check condition
    0;JMP


(FILL)
    @position
    A=M
    M=-1

    @position
    D=M+1
    @position
    M=D


    @LOOP // jump back to check condition
    0;JMP