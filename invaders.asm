;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;	Name: John Bumgardner		;
;	Date: November 29, 2017 	;
;	Program 3: Pack Invaders	;
;	Description: This program   ;
;	simulates the game of space ;
; 	albeit, much simplified. 	;
;	A red rectangle will shoot  ;
;	green lasers at several 	;
;	alien ships.				;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


.ORIG x3000

MAIN

ADVANCE_GAME
JSR CLEAR_SCREEN ;changes all pixels on the screen to black
JSR DRAW_ALIEN1 ;draws aliens
JSR DRAW_ALIEN2 ;draws aliens
JSR DRAW_ALIEN3 ;draws aliens
JSR DRAW_ALIEN4 ;draws aliens
JSR DRAW_PACK ;draws the pack ship at whatever the current location has been changed to
GETC ;read in character from the user
JSR CHECK_INPUT ;based on what the user inputed, perform some operation with it

BRnzp ADVANCE_GAME ;loop back and repeat
HALT





CLEAR_SCREEN
;;clear the previous screen
;pixels of screen stored from xC000 to xFDFF
;loop through all pixels and set equal to x0000 (black)

;use R1 to store the memory address of the start of the pixels
;use R2 to store the memory address of the end of the pixels
;start from the top of the memory and work down

;clear previous registers
AND R3 R3 #0
AND R1 R1 #0 
AND R2 R2 #0

LD R2 START_OF_PIXELS
LD R1 END_OF_PIXELS_REAL 

RESET_SCREEN_LOOP
;compare the addresses
	NOT R3 R2 
	ADD R3 R3 #1 ;negate R2
	ADD R3 R3 R1 ;compare the two addresses
BRn SUCCESSFUL_RESET
	AND R3 R3 #0 ;clear R3
	LDR R3 R1 #0 ;load the color value into R3
	AND R3 R3 #0 ;set the pixel value to black
	STR R3 R1 #0 ;put the pixel value back into the memory
	ADD R1 R1 #-1 ;decrement memory address
	BRnzp RESET_SCREEN_LOOP
SUCCESSFUL_RESET
RET

DRAW_ALIEN1
;prints the first alien
LD R0 ALIEN1TOPLEFT ;loads the address of the top left corner of the first alien
AND R4 R4 #0
ADD R4 R4 #14 ;pixels down
OUTERLOOP1
BRz DONEWITHALIEN1
AND R1 R1 #0
ADD R1 R1 #14 ;keeps track of number of pixels needed to go across
INNERLOOP1
BRz LINE1DONE
	;changes the color of the current pixel
	LDR R2 R0 #0 
	LD R2 BLUE
	STR R2 R0 #0
	ADD R0 R0 #1
	ADD R1 R1 #-1
	BRnzp INNERLOOP1
LINE1DONE
;move back to the next row
ADD R0 R0 #-14
LD R3 DROPROW
ADD R0 R0 R3
ADD R4 R4 #-1
BRnzp OUTERLOOP1
DONEWITHALIEN1
RET

DRAW_ALIEN2
;prints the second alien
LD R0 ALIEN2TOPLEFT ;loads the address of the top left corner of the second alien
AND R4 R4 #0
ADD R4 R4 #14 ;pixels down
OUTERLOOP2
BRz DONEWITHALIEN2
AND R1 R1 #0
ADD R1 R1 #14 ;keeps track of number of pixels needed to go across
INNERLOOP2
BRz LINE2DONE
	;changes the color of the current pixel
	LDR R2 R0 #0
	LD R2 BLUE
	STR R2 R0 #0
	ADD R0 R0 #1
	ADD R1 R1 #-1
	BRnzp INNERLOOP2
LINE2DONE
;move back to the next row
ADD R0 R0 #-14
LD R3 DROPROW
ADD R0 R0 R3
ADD R4 R4 #-1
BRnzp OUTERLOOP2
DONEWITHALIEN2
RET

DRAW_ALIEN3
;prints the third alien
LD R0 ALIEN3TOPLEFT ;loads the address of the top left corner of the third alien
AND R4 R4 #0
ADD R4 R4 #14 ;pixels down
OUTERLOOP3
BRz DONEWITHALIEN3
AND R1 R1 #0
ADD R1 R1 #14 ;keeps track of number of pixels needed to go across
INNERLOOP3
BRz LINE3DONE
;changes the color of the current pixel
	LDR R2 R0 #0
	LD R2 BLUE
	STR R2 R0 #0
	ADD R0 R0 #1
	ADD R1 R1 #-1
	BRnzp INNERLOOP3
LINE3DONE
;move back to the next row
ADD R0 R0 #-14
LD R3 DROPROW
ADD R0 R0 R3
ADD R4 R4 #-1
BRnzp OUTERLOOP3
DONEWITHALIEN3
RET

DRAW_ALIEN4
;prints the third alien
LD R0 ALIEN4TOPLEFT ;loads the address of the top left corner of the fourth alien
AND R4 R4 #0
ADD R4 R4 #14 ;pixels down
OUTERLOOP4
BRz DONEWITHALIEN4
AND R1 R1 #0
ADD R1 R1 #14 ;keeps track of number of pixels needed to go across
INNERLOOP4
BRz LINE4DONE
;changes the color of the current pixel
	LDR R2 R0 #0
	LD R2 BLUE
	STR R2 R0 #0
	ADD R0 R0 #1
	ADD R1 R1 #-1
	BRnzp INNERLOOP4
LINE4DONE
;move back to the next row
ADD R0 R0 #-14
LD R3 DROPROW
ADD R0 R0 R3
ADD R4 R4 #-1
BRnzp OUTERLOOP4
DONEWITHALIEN4
RET


DRAW_PACK
;will draw the updated pack at its new location
LD R0 START_LOCATION_PACK ;retrieves the value at which to start drawing
AND R4 R4 #0
ADD R4 R4 #12 ;pixels down
OUTERLOOP5
BRz DONEWITHPACK ;triggers when pack is finished being drawn
AND R1 R1 #0
LD R1 WIDTH ;keeps track of number of pixels needed to go across
INNERLOOP5
BRz LINE5DONE
;changes the color of the pixel to the desired color
	LDR R2 R0 #0
	LD R2 ACTUAL_COLOR
	STR R2 R0 #0
	ADD R0 R0 #1
	ADD R1 R1 #-1
	BRnzp INNERLOOP5
LINE5DONE
LD R5 DROPROWPACK ;moves down a row and will increment and decrement
ADD R0 R0 R5
LD R3 DROPROW
ADD R0 R0 R3
ADD R4 R4 #-1
BRnzp OUTERLOOP5
DONEWITHPACK
RET



CHECK_INPUT
;sees what the user inputs into the program and performs operation

;check to see if input was r
LD R1 r
ADD R1 R1 R0
BRnp NOTr
;means the character entered was r
	LD R1 RED
	ST R1 ACTUAL_COLOR ;changes the color we will use to red
	BRnzp DONE
NOTr
;check to see if input was g
LD R1 g
ADD R1 R1 R0
BRnp NOTg
;means the character entered was g
	LD R1 GREEN
	ST R1 ACTUAL_COLOR ;changes the color we will use to green
	BRnzp DONE
NOTg
;check to see if input was b
LD R1 b
ADD R1 R1 R0
BRnp NOTb
;means the character entered was b
	LD R1 BLUE
	ST R1 ACTUAL_COLOR ;changes the color we will use to blue
	BRnzp DONE
NOTb
;check to see if input was y
LD R1 y
ADD R1 R1 R0
BRnp NOTy
;means the character entered was y
	LD R1 YELLOW
	ST R1 ACTUAL_COLOR ;changes the color we will use to yellow
	BRnzp DONE
NOTy
;check to see if input was w
LD R1 w
ADD R1 R1 R0
BRnp NOTw
;means the character entered was w
	LD R1 WHITE
	ST R1 ACTUAL_COLOR ;changes the color we will use to white
	BRnzp DONE


NOTw
;check to see if input was q
LD R1 q
ADD R1 R1 R0
BRnp NOTq
;means the character entered was q
	HALT ;ends program 
	BRnzp DONE
NOTq

;check to see if input was a
LD R1 a
ADD R1 R1 R0
BRnp NOTa
;means the character entered was a
	LD R1 START_LOCATION_PACK
	;checks to see if move is possible, then moves
	AND R2 R2 #0
	ADD R2 R2 R1 
	LD R3 LOW_RANGE
	NOT R3 R3
	ADD R3 R3 #1
	ADD R3 R3 R2
	ADD R3 R3 #-4
	BRn DONE
	ADD R1 R1 #-4
	ST R1 START_LOCATION_PACK
	BRnzp DONE
NOTa

;check to see if input was d
LD R1 d
ADD R1 R1 R0
BRnp NOTd
;means the character entered was d
	LD R1 START_LOCATION_PACK
	;checks to see if move is possible, then moves
	AND R2 R2 #0
	ADD R2 R2 R1 
	LD R3 HIGH_RANGE
	NOT R3 R3
	ADD R3 R3 #1
	ADD R3 R3 R2
	ADD R3 R3 #4
	BRp DONE
	ADD R1 R1 #4
	ST R1 START_LOCATION_PACK
	BRnzp DONE
NOTd



DONE
RET



START_OF_PIXELS .FILL xC000
END_OF_PIXELS_REAL .FILL xFDFF
RED .FILL x7C00
GREEN .FILL x03E0
BLUE .FILL x001F
YELLOW .FILL x7FED
WHITE .FILL x7FFF
BLACK .FILL x0000

ACTUAL_COLOR .FILL x7C00


ALIEN1TOPLEFT .FILL xC18A
ALIEN2TOPLEFT .FILL xC1A8
ALIEN3TOPLEFT .FILL xC1C6
ALIEN4TOPLEFT .FILL xC1E4

DROPROW .FILL #128

WIDTH .FILL #24
DROPROWPACK .FILL #-24
START_LOCATION_PACK .FILL xF3B3


LOW_RANGE .FILL xF380
HIGH_RANGE .FILL xF3E4

;;memory location for ASCII characters needed
r .FILL #-114 
g .FILL #-103
b .FILL #-98
y .FILL #-121
w .FILL #-119
q .FILL #-113
a .FILL #-97
d .FILL #-100

