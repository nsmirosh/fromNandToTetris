// This file is part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
// File name: projects/04/Fill.asm

// Runs an infinite loop that listens to the keyboard input.
// When a key is pressed (any key), the program blackens the screen,
// i.e. writes "black" in every pixel;
// the screen should remain fully black as long as the key is pressed. 
// When no key is pressed, the program clears the screen, i.e. writes
// "white" in every pixel;
// the screen should remain fully clear as long as no key is pressed.

// Put your code here.


//create a constant screenSize with the width * height of the screen to refer to it later
@8192
D=A
@screenSize
M=D


(KEYBOARD_LISTENING_LOOP)

//initialize the addressOfCurrentRegisterInScreen var to the address of the start of the screen in RAM
@SCREEN
D=A
@addressOfCurrentRegisterInScreen
M=D


//access the word that's respondible for listening to keyboard input and put it into currentlyPressedKey variable
@KBD
D=M

@BLACKEN_THE_SCREEN
D;JNE

@WHITEN_THE_SCREEN
D;JEQ

@KEYBOARD_LISTENING_LOOP
0;JMP




(BLACKEN_THE_SCREEN)

//blacken the current "word" - go to the address stored in addressOfCurrentRegisterInScreen 
//and assign a decimal -1 to it, or make everything black in binary basically
@addressOfCurrentRegisterInScreen
A=M
M=-1

//increment the addressOfCurrentRegisterInScreen
@addressOfCurrentRegisterInScreen
D=M
@addressOfCurrentRegisterInScreen
M=D+1

//if the addressOfCurrentRegisterInScreen minus the KEYBOARD constant equals 0 
//(i.e. we completely iterated over the screen) jump back to listening for the keyboard input
@addressOfCurrentRegisterInScreen
D=M
@KBD
D=D-A
@KEYBOARD_LISTENING_LOOP
D;JEQ

@BLACKEN_THE_SCREEN
0;JMP




(WHITEN_THE_SCREEN)
@addressOfCurrentRegisterInScreen
A=M
M=0

//increment the addressOfCurrentRegisterInScreen
@addressOfCurrentRegisterInScreen
D=M
@addressOfCurrentRegisterInScreen
M=D+1

//if the addressOfCurrentRegisterInScreen minus the KEYBOARD constant equals 0 
//(i.e. we completely iterated over the screen) jump back to listening for the keyboard input
@addressOfCurrentRegisterInScreen
D=M
@KBD
D=D-A
@KEYBOARD_LISTENING_LOOP
D;JEQ


@WHITEN_THE_SCREEN
0;JMP




(END)
@END
0;JMP