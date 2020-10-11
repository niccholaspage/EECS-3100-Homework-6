;*******************************************************************
; main.s
; Author: Nicholas Nassar
; Date Created: 10/11/2020
; Last Modified: 10/11/2020
; Section Number: Lecture 001, Lab 002
; Instructor: Devinder Kaur
; Homework Number: 6
; Includes 5 functions that implement
; the functionality required from
; homework 6.
;*******************************************************************



	AREA    |.text|, CODE, READONLY, ALIGN=2
	THUMB
	EXPORT  Start
Start
	; Question 1 Testing
	; Integers 1 through 4
	MOV R0, #1 ; 1
	MOV R1, #2 ; 2
	MOV R2, #3 ; 3
	MOV R3, #4 ; 4
	; Integers 5 through 8
	MOV R4, #5 ; 5
	MOV R5, #6 ; 6
	MOV R6, #7 ; 7
	MOV R7, #8 ; 8
	PUSH {R4-R7} ; Push them to the stack
	; This calculates the product
	; of the eight integers passed
	; into it and returns the result.
	BL CalculateProductOfEightIntegers
	; Question 2 Testing
	MOV R0, #4 ; 4 corresponds to letter E
	MOV R1, #5 ; Shift by 5 letters
	; This will shift the letter in R0 by
	; R1, so E should become J.
	BL CaesarShift
	; Question 3 Testing
	MOV R0, #25 ; Age of 25
	; This calculates the movie ticket
	; price based on the passed in age.
	BL MoviePrice
	; Question 4 Testing
	MOV R0, #0xF00F ; 1111 0000 0000 1111 in binary
	; This finds how many one bits exist
	; in a 32-bit number and returns it.
	BL CountOneBits
	; Question 5 Testing
	MOV R0, #0xABCD
	MOV R1, #0xABC0
	; This finds how many bits differ
	; between the two arguments (R0 and
	; R1).
	BL GetHammingDistance


loop   B    loop

; Calculates the product of the eight integers
; passed into the function.
; Parameters:
; R0 - R3: Integers 1 to 4
; 4 items on stack: Integers 5 to 8
; Return value:
; Result (R0)
CalculateProductOfEightIntegers
	MUL R0, R1 ; Multiplies the first integer by the second one
	MUL R0, R2 ; Multiply our result by R2
	MUL R0, R3 ; Multiply our result by R3
	; We have now covered the first 4 parameters, so now
	; we must multiply our result by the 4 items on the
	; stack by repeatedly popping them off and multiplying.
	MOV R2, #4 ; We start with a counter for our loop
ProductLoop
	POP {R1} ; Pop the top value of the stack into R1
	MUL R0, R1 ; Multiply our result by R1
	SUBS R2, #1 ; Subtract 1 from our counter R2
	BXEQ LR ; If our counter is zero, we go back to the caller, we're done!
	B ProductLoop ; Continue looping otherwise.

; Performs Caesar shift encryption on a single
; letter.
; Parameters:
; R0: The letter to shift (0 - 25, which corresponds to A through Z)
; R1: The shift amount
; Return value:
; The encrypted letter (R0)
CaesarShift
	ADD R0, R1
	CMP R0, #25 ; Compare R0 to 25, corresponding to Z
	; If R0 is greater than 25, roll back over
	; to the beginning of the alphabet.
	SUBHI R0, #25
	BX LR

; Calculates the movie ticket price
; based on the given age. If the age
; is less than 12, the price is $6.
; If the age is between 13 and 64, the
; price is $8. If the age is 65 or over,
; the price is $7.
; Parameters:
; R0 - Age (unsigned integer)
; Return value:
; Movie ticket price (R0)
MoviePrice
	CMP R0, #12 ; Compare the age to 12
	BLS Return6 ; If it is 12 or under, branch to return $6.
	CMP R0, #64 ; Compares the age to 64
	BHI Return7 ; If it is greater than 64, branch to return $7.
	; At this point, we are in the final case of the age
	; being between 13 and 64, so we return $8.
	MOV R0, #8 ; Puts $8 into the result
	BX LR ; and goes back to the caller.
Return6
	MOV R0, #6 ; Puts $6 into the result
	BX LR ; and goes back to the caller.
Return7
	MOV R0, #7 ; Puts $6 into the result
	BX LR ; and goes back to the caller.

; Finds how many one bits exist in
; a 32-bit register.
; Parameters:
; R0 - The value to check the bits of
; Return value:
; Number of bits turned on (R0)
CountOneBits
	MOV R1, #0x1 ; Our shifting register for checking bits
	MOV R2, #0 ; Our temporary result
BitLoop
	TST R0, R1 ; Tests if a bit in R0 is equivalent to the current bit we are looking at.
	ADDNE R2, #1; If Z does not equal zero, we increment our temporary result
	CMP R1, #0x80000000 ; Compare our shifting register to the final bit to check
	LSL R1, #1 ; Shift our shifting register to the left one bit
	BNE BitLoop ; If our shifting register is not on the final bit, we continue testing bits
	MOV R0, R2 ; Store our result into R0
	BX LR ; GO back to the caller

; Finds how many bits differ (the hamming distance)
; between two numbers.
; Parameters:
; R0 - The first number
; R1 - The second number
; Return value:
; The number of bits that differ
; between the first and second number
GetHammingDistance
	; We actually can write this subroutine super
	; easily due to our routine above to count one
	; bits.
	; We XOR R0 and R1, storing the result in R0.
	; This will actually make any bits that differ
	; a 1 into R0!
	EOR R0, R1
	; Because of the result of R0 now, we can just
	; count how many bits are on and we are good to go!
	B CountOneBits

	ALIGN      ; make sure the end of this section is aligned
	END        ; end of file
       