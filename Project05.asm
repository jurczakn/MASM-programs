TITLE Sorting Random Integers		(Project05.asm)

; AUTHOR: Nick Jurczak		DATE: 03/03/15
; DESCRIPTION: Display program title and programmer's name, ask user's name, greet the user
; prompt the user to enter a number between 10 and 200. Generate that many random numbers.
; Show the user the numbers, 10 per line, show the median value, and show the numbers sorted.
; Extra Credit: Recursive sort function (bubble sort)

INCLUDE Irvine32.inc

UpperLimit = 200

LowerLimit = 10

Lo = 100

Hi = 999

.data
userName	BYTE	33 DUP(0)	;string to be entered by user
request		DWORD	?			;integer to be entered by user
random		DWORD	200 DUP(?)	;array to store random numbers
sorted		DWORD	200 DUP(?)	;array to store sorted random numbers
test1		DWORD	1, 2, 3, 10
median		DWORD	0			;median of random numbers
titl		BYTE	"      Nick Jurczak          Prime Numbers", 0
intro_1		BYTE	"How many random numbers do you want to see? You can see between 10 and 200.", 0
prompt_1	BYTE	"What's your name?", 0
intro_2		BYTE	"Nice to meet you, ", 0
prompt_2	BYTE	"Please enter a number between 10 and 200: ", 0
bool		DWORD	0			;store boolean return of function
err_1		BYTE	"Sorry, please enter a number between 10 and 200.", 0
blank		BYTE	"    ", 0
blank1		BYTE	"   ", 0
blank2		BYTE	"    ", 0
blank3		BYTE	"     ", 0
blank4		BYTE	"      ", 0
blank5		BYTE	"       ", 0
prompt_6	BYTE	"Here are your unsorted random numbers: ", 0
prompt_5	BYTE	"Here is the median of those numbers: ", 0
prompt_4	BYTE	"Here are those numbers again, sorted: ", 0
prompt_3	BYTE	"Results certified by Nick Jurczak", 0
goodBye		BYTE	"Good-bye, ", 0

.code
main PROC

CALL intro

push	OFFSET request	;pass request by reference

CALL input

push	OFFSET sorted
push	request
push	OFFSET random

CALL fill_array

push	request
push	OFFSET random

mov		edx, OFFSET prompt_6
call	WriteString

CALL testARR

push	request
push	OFFSET random

CALL sort_array

push	OFFSET median
push	request
push	OFFSET random

CALL get_median

push	request
push	OFFSET random

mov		edx, OFFSET prompt_4
call	WriteString

CALL	testARR

CALL goodbye_message

CALL ReadInt

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
; preconditions:		address of variable storing request pushed to stack
; recieves:				request on stack
; returns:				request on stack
; registers changed:	edx, eax

input PROC

;set stack

	push	ebp
	mov		ebp, esp

;get first number

	mov		ebx, [ebp+8]

GET_INT:

	mov		edx, OFFSET prompt_2
	call	WriteString
	call	ReadInt
	mov		[ebx], eax

;validate input

	CALL	input_val
	cmp		eax, 1
	jnz		GET_INT

;restore stack

	pop		ebp
	ret		4

input ENDP

;

; Procedure validates input less than upperLimit and greater than lowerLimit
;
; preconditions:		value being checking is in eax reg
; recieves:				UpperLimit, LowerLimit, value in eax
; returns:				1 if in range, 0 if not in eax
; registers changed:	eax

input_val PROC

	cmp		eax, UpperLimit
	jle		PASS_2
	mov		edx, OFFSET Err_1
	call	WriteString
	call	CrLf
	mov		eax, 0
	ret

PASS_2:
	
	cmp		eax, LowerLimit
	jge		PASS_3
	mov		edx, OFFSET Err_1
	call	WriteString
	call	CrLf
	mov		eax, 0
	ret

PASS_3:

	mov		eax, 1
	ret

input_val ENDP

; Procedure fills array with random numbers
;
; preconditions:		address of array pushed to stack, and number of values needed
; recieves:				array to store random values, and number of values
; returns:				filled array of random numbers
; registers changed:	 eax, ecx, esi, edi

fill_array PROC

;set stack

	push	ebp
	mov		ebp, esp

	mov		esi, [ebp+8]	;place number of values needed into ecx to set loop
	mov		ecx, [ebp+12]
	mov		edi, [ebp+16]

	CALL	Randomize

RAND_LOOP:
	
	CALL	random_num
	mov		[esi], eax
	mov		[edi], eax
	add		esi, 4
	add		edi, 4
	loop	RAND_LOOP

	pop		ebp
	ret		12

fill_array ENDP

testArr PROC

;set stack

	push	ebp
	mov		ebp, esp

	mov		esi, [ebp+8]	;place number of values needed into ecx to set loop
	mov		ecx, [ebp+12]

RAND_LOOP:

;new line

	mov		eax, [ebp+12]
	sub		eax, ecx
	cdq
	mov		ebx, 10
	div		ebx
	cmp		edx, 0
	jne		CONT_LN
	call	CrLf

CONT_LN:

	mov		eax, [esi]
	CALL	WriteDec
	CALL	blankSpace
	add		esi, 4
	loop	RAND_LOOP

	Call	CrLf

	pop		ebp
	ret		8

testArr ENDP

; Procedure prints proper white space to align colomns
;
; preconditions:		int2 > 0
; recieves:				int2
; registers changed:	edx, eax, ebx

blankSpace PROC

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

;Procedure creates a random number between lo and hi
;
;returns:	random number in eax
;registers:	changed eax

random_num PROC

	mov		eax, hi
	sub		eax, lo
	inc		eax
	call	RandomRange
	add		eax, lo

	ret

random_num ENDP

; Procedure calculates the median value of a list
; 
; preconditions:		the list, size of list, and place to store result are pushed to stack
; recieves:				array, integer size of array, and empty variable on system stack
; returns:				median value in location passed
; registers changed:	eax, ebx, ecx, edx, esi

get_median PROC

;set stack

	push	ebp
	mov		ebp, esp

	mov		esi, [ebp+8]	;place number of values needed into ecx to set loop
	mov		ecx, [ebp+12]

	mov		edx, OFFSET prompt_5
	call	WriteString

	mov		eax, ecx
	mov		ebx, 2
	mov		edx, 0
	div		ebx
	mov		ecx, edx
	mov		ebx, 4
	mul		ebx
	add		esi, eax
	mov		eax, [esi]
	cmp		ecx, 1
	je		IS_ODD

	sub		esi, 4
	add		eax, [esi]
	mov		ebx, 2
	mov		edx, 0
	div		ebx

IS_ODD:

	call	WriteDec
	call	CrLf

	mov		[ebp+16], eax

	pop		ebp
	ret		12

get_median ENDP

; Procedure sorts an array
;
; preconditions:		two copies of the array are pushed to the stack and size of array
; recieves:				two copies of the array and size of array on the system stack
; returns:				the sorted array in the first array passed
; registers changed:	eax, ecx

sort_array PROC

;set stack

	push	ebp
	mov		ebp, esp

	mov		esi, [ebp+8]
	mov		ecx, [ebp+12]

	cmp		ecx, 1
	je		DONE

	dec		ecx
LOOPOUT:

	mov		eax, [esi]
	mov		ebx, [esi+4]

	cmp		eax, ebx
	jle		SMALLER
	mov		[esi], ebx
	mov		[esi+4], eax

SMALLER:
	
	add		esi, 4
	loop	LOOPOUT

	mov		eax, [ebp+12]
	dec		eax
	mov		ebx, [ebp+8]
	push	eax
	push	ebx

	call	sort_array

DONE:

	pop		ebp
	ret		8

sort_array ENDP

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
