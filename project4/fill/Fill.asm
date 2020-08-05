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

//continously listen for any pressed key



//initialize the addressOfCurrentRegisterInScreen var to the address of the start of the screen in RAM
@SCREEN
D=A
@addressOfCurrentRegisterInScreen
M=D

//create a constant screenSize to refer to it later
@8192
D=A
@screenSize
M=D



(KEYBOARD_LISTENING_LOOP)
//access the word that's respondible for listening to keyboard input and put it into currentlyPressedKey variable
@KBD
D=M

@BLACKEN_THE_SCREEN
D;JNE

@KEYBOARD_LISTENING_LOOP
0;JMP


(BLACKEN_THE_SCREEN)

//blacken the current "word"
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
@KEYBOARD
D=D-A
@KEYBOARD_LISTENING_LOOP
D; JEQ

@BLACKEN_THE_SCREEN













//put the value of the pressed on or not pressed key in the @currentlyPressedKey
// if the value of @currentlyPressedKey != 0 blacken the screen

// else whiten the screen




(END)
@END
0;JMP