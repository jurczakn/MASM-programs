TITLE Sorting Random Integers		(Project05.asm)

; AUTHOR: Nick Jurczak		DATE: 03/03/15
; DESCRIPTION: Display program title and programmer's name, ask user's name, greet the user
; prompt the user to enter a 10 numbers, validate the input, display teh sum and average.


INCLUDE Irvine32.inc

UpperLimit = 200

LowerLimit = 10

Lo = 100

Hi = 999

.data
userName	BYTE	33 DUP(0)	;string to be entered by user
random		DWORD	10 DUP(?)	;array to numbers input by user
sorted		DWORD	0			;sum
average		DWORD	0			;average of users numbers
titl		BYTE	"      Nick Jurczak          Input Validation", 0
intro_1		BYTE	"How many random numbers do you want to see? You can see between 10 and 200.", 0
prompt_1	BYTE	"What's your name?", 0
intro_2		BYTE	"Nice to meet you, ", 0
prompt_2	BYTE	"Please enter a number: ", 0
prompt_6	BYTE	"Here are your numbers: ", 0
prompt_5	BYTE	"Here is the average of those numbers: ", 0
prompt_4	BYTE	"Here are those numbers again, sorted: ", 0
prompt_3	BYTE	"Results certified by Nick Jurczak", 0
goodBye		BYTE	"Good-bye, ", 0
blank	BYTE	" ", 0

.code
main PROC

CALL intro

push	OFFSET random

CALL fill_array

push	OFFSET random

mov		edx, OFFSET prompt_6
call	WriteString

CALL testARR

;CALL	testARR

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

;get first number

	mov		ebx, [ebp+8]

GET_INT:

	mov		edx, OFFSET prompt_2
	call	WriteString
	call	ReadInt

	ret

input ENDP


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
	mov		ecx, 10

	CALL	input

RAND_LOOP:
	
	mov		[esi], eax
	add		esi, 4
	loop	RAND_LOOP

	pop		ebp
	ret		4

fill_array ENDP

testArr PROC

;set stack

	push	ebp
	mov		ebp, esp

	mov		esi, [ebp+8]	;place number of values needed into ecx to set loop
	mov		ecx, 10

RAND_LOOP:

CONT_LN:

	mov		eax, [esi]
	CALL	WriteDec
	add		esi, 4
	loop	RAND_LOOP

	Call	CrLf

	pop		ebp
	ret		8

testArr ENDP


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
