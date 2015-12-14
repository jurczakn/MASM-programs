TITLE Integer Accumulator		(Project03.asm)

; AUTHOR: Nick Jurczak		DATE: 02/02/15
; DESCRIPTION: Display program title and programmer's name, ask user's name, greet the user
; prompt the user to enter numbers between 0 and 100. When a number less than 0 is entered
; the average of the numbers entered is displayed.
; Extra Credit: numbers input lines

INCLUDE Irvine32.inc

UpperLimit = 100

.data
userName	BYTE	33 DUP(0)		;string to be entered by user
int1		DWORD	?			;integer to be entered by user
tot			DWORD	0			;running total of all input numbers
num			DWORD	0			;number of inputs from user
avr			DWORD	0			;calculated average of inputs
titl		BYTE	"      Nick Jurczak          Integer Accumulator", 0
intro_1		BYTE	"Please Start by entering number between 0 and 100. When you are finished enter a number less than 0, and the average of all numbers entered will be displayed.", 0
prompt_1	BYTE	"What's your name?", 0
intro_2		BYTE	"Nice to meet you, ", 0
prompt_2	BYTE	"Please enter number 1: ", 0
result_1	BYTE	"You entered ", 0
result_2	BYTE	" numbers.", 0
result_3	BYTE	"The sum of the numbers is ", 0
result_4	BYTE	"The rounded average is ", 0
prompt_4	BYTE	"Would you like to perform another calculation?", 0
prompt_5	BYTE	"Please enter 1 for yes and 0 for no: ", 0
prompt_6	BYTE	"Please enter the remainder of your numbers, or -1 when finished.", 0
prompt_7	BYTE	"Please enter number ", 0
prompt_8	BYTE	" : ", 0
response	DWORD	?			;response to prompt 4 entered by user
bool		DWORD	0			;store boolean return of function
err_1		BYTE	"Sorry, please enter a number between 0 and 100.", 0
err_2		BYTE	"Sorry, please enter a number less than 100.", 0
prompt_3	BYTE	"Results certified by Nick Jurczak", 0
goodBye		BYTE	"Good-bye, ", 0

.code
main PROC

CALL intro

CALL input

CALL calc_avr

CALL results

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

TOP:

	mov		edx, OFFSET prompt_2
	call	WriteString
	call	ReadInt
	mov		int1, eax
	mov		eax, int1
	cmp		eax, 0
	jge		PASS_1
	mov		edx, OFFSET Err_1
	call	WriteString
	call	CrLf
	jmp		TOP

PASS_1:

	CALL input_val

	mov		eax, bool
	cmp		bool, 1
	jnz		TOP
	mov		edx, OFFSET prompt_6
	call	WriteString
	call	CrLf

CALC:

;add to tot

	mov		eax, tot
	add		eax, int1
	mov		tot, eax

;increment num

	mov		eax, num
	add		eax, 1
	mov		num, eax

GET_INT:

;get next int

	mov		edx, OFFSET prompt_7
	call	WriteString
	mov		eax, num
	add		eax, 1
	call	WriteDec
	mov		edx, OFFSET prompt_8
	call	WriteString
	call	ReadInt
	mov		int1, eax

;validate input

	CALL	input_val
	mov		eax, bool
	cmp		bool, 1
	jnz		GET_INT

;check should end

	mov		eax, int1
	cmp		eax, 0
	jnl		CALC

	ret

input ENDP

; Procedure validates input less than upperLimit
;
; recieves:				int1, Err_2, UpperLimit
; returns:				bool
; registers changed:	edx, eax

input_val PROC

	mov		eax, int1
	cmp		eax, UpperLimit
	jle		PASS_2
	mov		edx, OFFSET Err_2
	call	WriteString
	call	CrLf
	mov		bool, 0
	ret

PASS_2:

	mov		bool, 1
	ret

input_val ENDP

; Procedure displays results of program
;
; recieves:				result_1, result_2, result_3, result_4, num, tot, avr
; registers changed:	edx, eax

results PROC

;Display number of ints entered

	mov		edx, OFFSET result_1
	call	WriteString
	mov		eax, num
	call	WriteDec
	mov		edx, OFFSET result_2
	call	WriteString
	call	CrLf

;Display sum

	mov		edx, OFFSET result_3
	call	WriteString
	mov		eax, tot
	call	WriteDec
	call	CrLf

;Display average

	mov		edx, OFFSET result_4
	call	WriteString
	mov		eax, avr
	call	WriteDec
	call	CrLf

	ret

results ENDP

; Procedure calculates the average of user input
;
; returns:				avr
; recieves:				num, tot
; preconditions:		num != 0
; registers changed:	edx, eax, ebx

calc_avr PROC

	mov		eax, tot
	mov		ebx, num
	xor		edx, edx
	div		ebx
	mov		avr, eax

	ret

calc_avr ENDP

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
