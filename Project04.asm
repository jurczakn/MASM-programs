TITLE Prime Numbers		(Project04.asm)

; AUTHOR: Nick Jurczak		DATE: 02/02/15
; DESCRIPTION: Display program title and programmer's name, ask user's name, greet the user
; prompt the user to enter a number between 1 and 200 and display that many prime numbers.
; Extra Credit: aligns columns

INCLUDE Irvine32.inc

UpperLimit = 200

.data
userName	BYTE	33 DUP(0)		;string to be entered by user
int1		DWORD	?			;integer to be entered by user
int2		DWORD	1			;used to check primes
store		DWORD	0			;used to store ecx for nested loop
tot			DWORD	0			;running total of all input numbers
num			DWORD	0			;number of inputs from user
avr			DWORD	0			;calculated average of inputs
titl		BYTE	"      Nick Jurczak          Prime Numbers", 0
intro_1		BYTE	"How many Prime numbers do you want to see? You can see a maximum of 200.", 0
prompt_1	BYTE	"What's your name?", 0
intro_2		BYTE	"Nice to meet you, ", 0
prompt_2	BYTE	"Please enter a number between 1 and 200: ", 0
bool		DWORD	0			;store boolean return of function
err_1		BYTE	"Sorry, please enter a number between 1 and 200.", 0
blank		BYTE	"    ", 0
blank1		BYTE	"   ", 0
blank2		BYTE	"    ", 0
blank3		BYTE	"     ", 0
blank4		BYTE	"      ", 0
blank5		BYTE	"       ", 0
prompt_3	BYTE	"Results certified by Nick Jurczak", 0
goodBye		BYTE	"Good-bye, ", 0

.code
main PROC

CALL intro

CALL input

CALL showPrimes

CALL goodbye_message

	exit
main ENDP

; Procedure displays title, and programmers name, 
; asks users name, greets user, and then displays
; instructions.
;
; recieves:				titl, prompt_1, intro_2, intro_1
; returns:				userName
; registers changed:	edx

intro PROC

;Display title

	mov		edx, OFFSET titl
	call	WriteString
	call	CrLf

;Get user name

	mov		edx, OFFSET prompt_1
	call	WriteString
	mov		edx, OFFSET userName
	mov		ecx, 32
	call	ReadString

;Greet user

	mov		edx, OFFSET intro_2
	call	WriteString
	mov		edx, OFFSET userName
	call	WriteString
	call	CrLf

;Display instructions

	mov		edx, OFFSET intro_1
	call	WriteString
	call	CrLf
	call	CrLf

	ret

intro ENDP

; Procedure takes input from the user
;
; recieves:				prompt_1, int1, Err_1
; returns:				int1
; registers changed:	edx, eax

input PROC

;get first number

GET_INT:

	mov		edx, OFFSET prompt_2
	call	WriteString
	call	ReadInt
	mov		int1, eax

;validate input

	CALL	input_val
	mov		eax, bool
	cmp		bool, 1
	jnz		GET_INT

	ret

input ENDP

; Procedure validates input less than upperLimit
;
; recieves:				int1, Err_1, UpperLimit
; returns:				bool
; registers changed:	edx, eax

input_val PROC

	mov		eax, int1
	cmp		eax, UpperLimit
	jle		PASS_2
	mov		edx, OFFSET Err_1
	call	WriteString
	call	CrLf
	mov		bool, 0
	ret

PASS_2:
	
	mov		eax, int1
	cmp		eax, 1
	jge		PASS_3
	mov		edx, OFFSET Err_1
	call	WriteString
	call	CrLf
	mov		bool, 0
	ret

PASS_3:

	mov		bool, 1
	ret

input_val ENDP

; Procedure shows int1 number of prime numbers in order
;
; preconditions:		int1 > 0
; recieves:				int1
; returns:				bool
; registers changed:	edx, eax, ecx

showPrimes PROC

	mov ecx, int1

LP:

;new line

	mov		eax, int1	;Determine wether to start new line
	sub		eax, ecx
	cdq
	mov		ebx, 10
	div		ebx
	cmp		edx, 0
	jne		CONT_LN
	call	CrLf

CONT_LN:

;increment int2

	mov		eax, int2
	add		eax, 1
	mov		int2, eax

;check if int2 is prime

	mov		store, ecx
	CALL	isPrime
	cmp		ecx, 1
	mov		ecx, store
	jne		CONT_LN

;display prime

	mov		eax, int2
	call	WriteDec
	call	blankSpace
	loop	LP

	ret

showPrimes ENDP

; Procedure determines wether a number is prime
;
; preconditions:		int2 > 1
; recieves:				int2
; returns:				ecx = 1 if prime, ecx != 1 if not prime
; registers changed:	edx, eax, ecx, ebx

isPrime PROC
	
	mov		ecx, int2
	sub		ecx, 1

PRIME_CHECK:

	xor		edx, edx
	mov		eax, int2
	mov		ebx, ecx
	div		ebx
	cmp		edx, 0
	je		DIVISIBLE
	mov		eax, int2
	loop	PRIME_CHECK

DIVISIBLE:

	ret

isPrime	ENDP

; Procedure prints proper white space to align colomns
;
; preconditions:		int2 > 0
; recieves:				int2
; registers changed:	edx, eax, ecx, ebx


blankSpace PROC

	mov		eax, int2

	mov		edx, OFFSET blank5
	cmp		eax, 10
	jl		ENDF
	mov		edx, OFFSET blank4

	cmp		eax, 100
	jl		ENDF
	mov		edx, OFFSET blank3	

	cmp		eax, 1000
	jl		ENDF
	mov		edx, OFFSET blank2		

	cmp		eax, 10000
	jl		ENDF
	mov		edx, OFFSET blank1

	cmp		eax, 100000
	jl		ENDF
	mov		edx, OFFSET blank

ENDF:

	call	WriteString

	ret

blankSpace ENDP

; Procedure displays goodbye message
;
; recieves:				prompt_3, goodBye, username
; registers changed:	edx

goodbye_message PROC

	call	CrLf
	mov		edx, OFFSET prompt_3
	call	WriteString
	call	CrLf
	mov		edx, OFFSET goodBye
	call	WriteString
	mov		edx, OFFSET userName
	call	WriteString
	call	CrLf

	ret

goodbye_message ENDP

END main
