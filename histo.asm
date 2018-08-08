;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; John Bumgardner						;
; Program 2: Historgram					;
; This program reads in a set of data 	;
;and plots the frequency of each 		;
;piece of data occurring.				;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

.ORIG x3000 ; start program at x3000

;clear registers
AND R0 R0 #0
AND R1 R1 #0
AND R2 R2 #0
AND R3 R3 #0
AND R4 R4 #0
AND R5 R5 #0
AND R6 R6 #0
AND R7 R7 #0

;clear the counter memory from previous run
;R0 store current address of memory being cleared in loop
;R1 counter - starts at #128 because there are 128 counter locations
;R2 receives the value stored in memory


LEA R0 COUNTERS ;load address of the first memory of the counters into R0
LD R1 LENGTH_OF_COUNTERS ;load counter into R1
CLEAR_MEM_LOOP
	BRn CLEARED_MEM ;signals that end of counters has been reached
	LDR R2 R0 #0 ;load the counter from the address stored in R0
	AND R2 R2 #0 ;clear it
	STR R2 R0 #0 ;store back into memory
	ADD R0 R0 #1 ;increment memory location
	ADD R1 R1 #-1 ;decrement counter
	BRnzp CLEAR_MEM_LOOP
CLEARED_MEM
;memory that stores the counters is now cleared


;parse through file starting at first address with value

LD R3 DATA ;get first address of data
LDR R0 R3 #0 ;load the number of data points
AND R3 R3 #0 ;clear R3

;read values and store frequency in memory
;;to accomplish this, loop through the file using the number it
;;gives at the top as a counter. update the counter memory and 
;;restore it into the memory.

LD R1 DATA ;load base memory file
INPUT_LOOP
	AND R2 R2 #0 ;clear registers
	AND R6 R6 #0 
	AND R5 R5 #0
	ADD R1 R1 #1 ;increment by 1
	LDR R2 R1 #0 ;load the value from the data into R2
	LEA R6 COUNTERS ;load the address of where the counters are being stored
	ADD R6 R6 R2 ;move through the memory based off the value of the data
	LDR R5 R6 #0 ;load the current value of the counter into register 5
	ADD R5 R5 #1 ;increment the counter by 1 by 1
	STR R5 R6 #0 ;put the updated counter back into memory
	ADD R0 R0 #-1 ;decrement the counter variable
	BRp INPUT_LOOP ;while it's positive, continue

;file read and frequency now stored in memory

;clear memory addresses
AND R0 R0 #0
AND R1 R1 #0
AND R2 R2 #0
AND R3 R3 #0
AND R4 R4 #0
AND R5 R5 #0
AND R6 R6 #0
AND R7 R7 #0

;;scale the histogram values

;find largest value in the counters

;R0 will store the counter
;R1 will store the memory address
;R2 will contain the max - starts with value of zero

;load counter
LD R0 LENGTH_OF_COUNTERS

;load starting memory address
LEA R1 COUNTERS

MAX_LOOP
;check to see if there are numbers left to be checked
ADD R0 R0 #0 ;reset CC
BRnz END_COUNTERS
	;load temp value from counter then check to see if it is larger than current max
	LDR R5 R1 #0;load the counter for the value at the current memory address
	;negate R5 and put into R6
	NOT R6 R5
	ADD R6 R6 #1
	;compare R6 and R2
	ADD R6 R6 R2
	BRzp KEEP_CURRENT
		AND R2 R2 #0 ;clear current max
		ADD R2 R5 #0 ;move new max into the actual max
	KEEP_CURRENT
	ADD R0 R0 #-1 ;decrement counter
	ADD R1 R1 #1 ;increment memory address
	AND R5 R5 #0
	AND R6 R6 #0
	BRnzp MAX_LOOP
END_COUNTERS

AND R1 R1 #0

;double the max until it is greater than or equal to 64
;R2 contains max
;R1 will store how many times required to accomplish this task.
;compare 62 and the current max
LD R4 BENCHMARK_VALUE ;store the value #62 into R4 for purposes of comparison
DOUBLE_LOOP
	NOT R5 R2 ;negate the max
	ADD R5 R5 #1
	ADD R5 R4 R5
	BRnz MAX_GREATER_62
		ADD R2 R2 R2 ;double the current max
		ADD R1 R1 #1 ;increment the counter
		BRnzp DOUBLE_LOOP
MAX_GREATER_62

;clear other registers, only counter R1 is necessary for next step
AND R4 R4 #0
AND R5 R5 #0
AND R2 R2 #0



;R2 stores the current memory address for what is being doubled
;R1 tells the computer how many times to double the values in the counter memory
;R6 serves as a working number of times to double the value
;R0 stores the length of the counter memory allocated

LD R0 LENGTH_OF_COUNTERS ;load 128 into R0
LEA R2 COUNTERS ;loads the first memory address into R2

DOUBLE_COUNTERS_LOOP
ADD R6 R6 R1
ADD R0 R0 #0 ;update CC
BRnz END_OF_COUNTERS
	LDR R3 R2 #0 ;load the value from the current memory address
	SUM_LOOP
		ADD R3 R3 R3 ;double the value from the memory address
		ADD R6 R6 #-1
		BRp SUM_LOOP
	STR R3, R2, #0 ;store the updated value back into its correct location in memory
	ADD R2 R2 #1 ;increment memory location
	ADD R0 R0 #-1 ;decrement counter
	AND R3 R3 #0 ;clear the temp value
	AND R6 R6 #0 ;clear the working counter of times to multiply
	BRnzp DOUBLE_COUNTERS_LOOP
END_OF_COUNTERS

;clear unnecessary registers
AND R0 R0 #0
AND R1 R1 #0
AND R2 R2 #0
AND R3 R3 #0


;;clear the previous histogram
;pixels of histogram stored from xC000 to xFDFF
;loop through all pixels and set equal to x0000 (black)

;use R1 to store the memory address of the start of the pixels
;use R2 to store the memory address of the end of the pixels
;start from the top of the memory and work down

LD R2 START_OF_PIXELS
LD R1 END_OF_PIXELS_REAL 

RESET_HISTO_LOOP
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
	BRnzp RESET_HISTO_LOOP
SUCCESSFUL_RESET

;clear all registers
AND R0 R0 #0
AND R1 R1 #0
AND R2 R2 #0
AND R3 R3 #0
AND R4 R4 #0
AND R5 R5 #0
AND R6 R6 #0

;;print the data in a histogram
;R0 store the address of counter
;R1 store the counter that makes sure we don't exeed 128

LEA R0 COUNTERS ;load the memory address into R0
ST R0 FIRST_ADDRESS_COUNT
AND R1 R1 #0 ;make sure R1 is cleared to 0


OUTPUT_LOOP
LD R2 LENGTH_OF_COUNTERS ;load the end value of the counter loop

NOT R3 R1 ;negate R1 for comparison
ADD R3 R3 #1

ADD R3 R3 R2 ;compares the 128 and number of iterations
BRnz DONE_WITH_OUTPUT
	AND R2 R2 #0
	AND R3 R3 #0
	
	;if that value is positive, there are more values to be analyzed
	LDR R2 R0 #0 ;load the value stored in the counter into R2
		BRnz NO_VAL ;check to see if any data exists in the value
			
			;find the distance from the current address to the start
			LD R3 FIRST_ADDRESS_COUNT ;load the first address of the count
			NOT R3 R3 ;negate that value
			ADD R3 R3 #1 

			ADD R3 R0 R3 ; put into R3 the distance
			LD R4 END_OF_PIXELS
			ADD R4 R3 R4 ;base of the histogram address value
			
			AND R3 R3 #0 ;clear R3 - use as counter to make sure we print enough pixels
			
			;print the pixels going up the value vertically

			LIL_UZI_VERT

				NOT R5 R3 ;negate R5
				ADD R5 R5 #1

				ADD R5 R5 R2

				;print the columns
				BRnz DONE_VERT 
					AND R5 R5 #0 ;clear space in register
					LDR R5 R4 #0 ;load the current color val from memory
					LD R7 INCREMENTAL_NUM ;load #-128
					ADD R6 R7 R0 ;add the current memory and the base memory value to calculate the value 
					AND R6 R6 #1 ;and to check for even or odd
					BRp ODD 
					LD R5 COLOR_WHITE ;change color to white if even
					BRnzp COLOR_DONE
					ODD 
					LD R5 COLOR_YELLOW ;yellow to odd
					BRnzp COLOR_DONE
					COLOR_DONE
					STR R5 R4 #0 ;place the updated value back into the screen memory
					AND R5 R5 #0 
					LD R5 INCREMENTAL_NUM ;go up a row
					ADD R4 R4 R5 
					ADD R3 R3 #1 ;increment the counter 
					AND R6 R6 #0 
					BRnzp LIL_UZI_VERT
				DONE_VERT
		NO_VAL
		ADD R1 R1 #1 ;increment global counter for memory
		ADD R0 R0 #1 ;increment memory address
		BRnzp OUTPUT_LOOP

DONE_WITH_OUTPUT

HALT


;;memory
START_OF_PIXELS .FILL xC000
END_OF_PIXELS .FILL xFD80 ;not technically last pixel, but more useful
END_OF_PIXELS_REAL .FILL xFDFF
BENCHMARK_VALUE .FILL #62
LENGTH_OF_COUNTERS .FILL #128
INCREMENTAL_NUM .FILL #-128
DATA .FILL x4000
COUNTERS .BLKW #128 ;value counters


FILLER .BLKW x20

COLOR_WHITE .FILL x7FFF
COLOR_YELLOW .FILL x7FE0
FIRST_ADDRESS_COUNT .FILL x0000



