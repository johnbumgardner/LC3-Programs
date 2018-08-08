;;;;;;;;;;;;;;;;;;;;;;;;
;	John Bumgardner
;	ECE 109 - 404 - Program #1
;
;	Program is designed to calculate
;	the sum of odd numbers between two
;	numbers given proper input.
;;;;;;;;;;;;;;;;;;;;;;;;

	.ORIG x3000 	;start program at x3000

	AND R0 R0 #0 	;clears R0-R7
	AND R1 R1 #0 
	AND R2 R2 #0 
	AND R3 R3 #0 
	AND R4 R4 #0 
	AND R5 R5 #0 
	AND R6 R6 #0 
	AND R7 R7 #0 


	;;prompt user for input
	LEA R0 FIRSTTEXT 	;loads address of user prompt
	PUTS 	;outputs text

	AND R0 R0 #0 ;clear the register

	ERRORTRAP1 ; a label used for error trapping

	GETC 	;reads in user input into R0
	OUT	;echo

	;;check to make sure the input lies between x30 and x39
	LD R5 HEXTOINT
	ADD R5 R0 R5
		BRn ERRORTRAP1

	LD R5 HEXTOINT2
	ADD R5 R0 R5
		BRp ERRORTRAP1

	ST R0 NUM1CHAR1 ;;store for later

	LD R1 HEXTOINT ;loads the value to convert the ASCII number to actual value
	ADD R0 R0 R1 ;converts the ASCII value to actual value

	AND R1 R1 #0 ;clears R1
	ADD R1 R0 #0 ;moves the first input number (tens place holder) to R1
	AND R0 R0 #0 ; clears R0

	ERRORTRAP2

	GETC ;reads in the ones place
	OUT ; echo

	;;check to make sure the input lies between x30 and x39
	LD R5 HEXTOINT
	ADD R5 R0 R5
		BRn ERRORTRAP2

	LD R5 HEXTOINT2
	ADD R5 R0 R5
		BRp ERRORTRAP2

	ST R0 NUM1CHAR2 ;;store for later

	;multiply current contents of R1 by 10.
	ADD R3 R3 #9 ;set counter register
	ADD R2 R1 #0 ;move first value to temp location

	loop1 
	ADD R1 R1 R2 ;execute the addition
	ADD R3 R3 #-1 ;decrement counter
		BRp loop1 ;branch back to the loop label

	LD R3 HEXTOINT ;loads number to convert from ASCII to actual value
	ADD R0 R0 R3 ;concerts the 1s place to actual value from ASCII
	ADD R1 R1 R0 ;adds the 1s to the full value

	;clear registers no longer needed
	AND R0 R0 #0
	AND R2 R2 #0
	AND R3 R3 #0

	;;at this point, the hex value for the input number should be stored in register 1

	LEA R0 SECONDTEXT ;load address for second user prompt
	PUTS ;outputs said text

	AND R0 R0 #0 	;clears R0

	ERRORTRAP3

	GETC 	;reads in user input into R0
	OUT	;echo

	;;check to make sure the input lies between x30 and x39

	LD R5 HEXTOINT
	ADD R5 R0 R5
		BRn ERRORTRAP3

	LD R5 HEXTOINT2
	ADD R5 R0 R5
		BRp ERRORTRAP3

	ST R0 NUM2CHAR1 ;;store for later

	LD R6 HEXTOINT
	ADD R0 R0 R6 ;converts the ASCII value to actual value

	AND R2 R2 #0 ;clears R2
	ADD R2 R0 #0 ;moves the first input number (tens place holder) to R2
	AND R0 R0 #0 ; clears R0

	ERRORTRAP4

	GETC ;reads in the ones place
	OUT ; echo

	;;check to make sure the input lies between x30 and x39
	LD R5 HEXTOINT
	ADD R5 R0 R5
		BRn ERRORTRAP4

	LD R5 HEXTOINT2
	ADD R5 R0 R5
		BRp ERRORTRAP4

	ST R0 NUM2CHAR2 ;;store for later

	;multiply current contents of R2 by 10.
	ADD R4 R4 #9 ; serves as loop counter
	ADD R3 R2 #0

	;;;loop to complete multiplication
	loop2 ADD R2 R2 R3
	ADD R4 R4 #-1
		BRp loop2

	LD R4 HEXTOINT
	ADD R0 R0 R4
	ADD R2 R2 R0
	AND R0 R0 #0
	AND R3 R3 #0
	AND R4 R4 #0

	;;both numbers, with correct hex value should be inputted 
	;;into R1 (lower num) and R2 (higher num)
	
	;make sure end value is larger than the start value

	NOT R5 R2 ;find negative of last given input
	ADD R6 R5 R1 ;sums the negative of the last input and the postive of the first
	BRn GOOD ;checks to see if the difference is negative, meaning the last number is bigger than first
		LEA R0 ERROR ;load error message
		PUTS ;print error message
		HALT

	GOOD ;goes here if input is fine
	
	
	
	;;;;;sum the odd integers between R1 and R2
	;;;;main algorithm of the program
	AND R3 R3 #0 ; use R3 to count the sum of odds
	
	BREAK
	;;clear registers
	AND R4 R4 #0 
	AND R5 R5 #0
	;;determine equality between R1 and R2
		NOT R4 R1
		ADD R4 R4 #1
		ADD R5 R4 R2
			BRnz END ;;end loop if they become equal
	;;clear registers
	AND R4 R4 #0
	AND R5 R5 #0
	ADD R1 R1 #1 ;increment again
	;;check equality of the end and first again
	NOT R4 R1
		ADD R4 R4 #1
		ADD R5 R4 R2
			BRnz END
	;;clear registers
	AND R4 R4 #0
	AND R5 R5 #0
	ADD R4 R1 #0
	AND R4 R4 #1
	BRz EVEN
		ADD R3 R3 R1
	EVEN
	BRnzp BREAK
	
	
	
	END
	
	;;STORED IN R3 IS SUM OF ODD INTEGERS
	
	AND R0 R0 #0
	AND R4 R4 #0
	AND R5 R5 #0
	AND R6 R6 #0
	
	
	;;output stuff
	;;;parts of the final sentence along with the numbers will be output.
	LEA R0 FINAL1
		PUTS
	LD R0 NUM1CHAR1
		OUT
	LD R0 NUM1CHAR2
		OUT
	LEA R0 FINAL2
		PUTS
	LD R0 NUM2CHAR1
		OUT
	LD R0 NUM2CHAR2
		OUT
	LEA R0 FINAL3
		PUTS	
	;;has output up to the actual sum, which must be translated	
			
	;;to prep for converting the sum to something that can be printed
	;;first clear all the unnecessary registers
	
	AND R0 R0 #0 	;clears R0-R7, except R3, for it contains the sum.
	AND R1 R1 #0 
	AND R2 R2 #0 
	AND R4 R4 #0 
	AND R5 R5 #0 
	AND R6 R6 #0 
	AND R7 R7 #0 
	
	;let registers serve as tally marks or place holders
	;R0 will store 1000s
	;R1 will store 100s
	;R2 will store 10s
	;R4 will store 1s
	
	;count the 1000s
	ATTEMPT1000 ;label to return to in counting algorithm
	;clear registers
	AND R5 R5 #0
	AND R6 R6 #0
	;load in -1000 into R5
	LD R5 THOU
	ADD R6 R5 R3
	;check to see if this operation can be performed, if not, move on
	BRn END1000
		ADD R0 R0 #1 ;if the op can be performed, add a talley to 1
		ADD R3 R3 R5 ;actually perform the operation
		BRnzp ATTEMPT1000 ;unconditionally branch to the top
	
	END1000
	
	;count the 100s
	ATTEMPT100 ;label to return to in counting algorithm
	;clear registers
	AND R5 R5 #0
	AND R6 R6 #0
	;load in -100 into R5
	LD R5 HUN
	ADD R6 R5 R3
	;check to see if this operation can be performed, if not, move on
	BRn END100
		ADD R1 R1 #1 ;if the op can be performed, add a talley to 1
		ADD R3 R3 R5 ;actually perform the operation
		BRnzp ATTEMPT100 ;unconditionally branch to the top
	
	END100
	
	;count the 10s
	ATTEMPT10 ;label to return to in counting algorithm
	;clear register
	AND R6 R6 #0
	ADD R6 R3 #-10 ;check to see if op can happen
	BRn END10
		ADD R2 R2 #1 ;;see above
		ADD R3 R3 #-10
		BRnzp ATTEMPT10	
	
	END10
	
	;;method nearly identical to above versions - see above
	ATTEMPT1
	AND R6 R6 #0
	ADD R6 R3 #-1
	BRn END1
		ADD R4 R4 #1
		ADD R3 R3 #-1
		BRnzp ATTEMPT1	
	
	END1
	
	;;move the terms into the 0th register and output them to the screen
	
	;;output the sum of odd integers
	AND R6 R6 #0; clear register
	LD R6 HEXTOINT3 ;load in 48 to convert the tallys into values that can be printed
	ADD R0 R0 R6 ; sum the original val and conversion scalar
	OUT ;print it out
	;same but for hundreds
	AND R0 R0 #0
	ADD R0 R1 R0
	ADD R0 R0 R6
	OUT
	;same but for 10s
	AND R0 R0 #0
	ADD R0 R2 R0
	ADD R0 R0 R6
	OUT
	;same but for 1s
	AND R0 R0 #0
	ADD R0 R4 R0
	ADD R0 R0 R6
	OUT
	
HALT

 



FIRSTTEXT .STRINGZ "\nEnter Start Number>"
SECONDTEXT .STRINGZ "\nEnter End Number>"
ERROR .STRINGZ "\nERROR! Invalid Entry!"
HEXTOINT .fill #-48
HEXTOINT2 .FILL #-57
HEXTOINT3 .FILL #48
FIRSTNUM .FILL #0
LASTNUM .FILL #0


LINEFEED .FILL xA

NUM1CHAR1 .FILL #0
NUM1CHAR2 .FILL #0

NUM2CHAR1 .FILL #0
NUM2CHAR2 .FILL #0

FINAL1 .STRINGZ "\nThe sum of the odd numbers between "
FINAL2 .STRINGZ " and "
FINAL3 .STRINGZ " is "


THOU .FILL #-1000
HUN .FILL #-100
