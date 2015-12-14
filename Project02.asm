TITLE Fibonacci Number		(Project02.asm)

; AUTHOR: Nick Jurczak		DATE: 01/25/15
; DESCRIPTION: Display program title and programmer's name, ask user's name, greet the user
; prompt the user to enter number of Fibonacci terme to be displayed, get and validate user input.
; Calculate and display all of Fibonacci numbers up to and including the nth term. Display goodbye
; message, terminate program.

OPTION LJMP

INCLUDE Irvine32.inc

UpperLimit = 46

.data
userName	BYTE	33 DUP(0)		;string to be entered by user
int1		DWORD	?			;integer to be entered by user
titl		BYTE	"      Nick Jurczak          Fibonacci Numbers", 0
intro_1		BYTE	"Please enter a number between 1 and 46, and I will show you that many Fibonacci terms.", 0
prompt_1	BYTE	"What's your name?", 0
intro_2		BYTE	"Nice to meet you, ", 0
prompt_2	BYTE	"How many Fibonacci terms do you want? ", 0
blank		BYTE	"     ", 0
blank1		BYTE	"      ", 0
blank2		BYTE	"       ", 0
blank3		BYTE	"        ", 0
blank4		BYTE	"         ", 0
blank5		BYTE	"          ", 0
prompt_4	BYTE	"Would you like to perform another calculation?", 0
prompt_5	BYTE	"Please enter 1 for yes and 0 for no: ", 0
response	DWORD	?			;response to prompt 4 entered by user
err_1		BYTE	"Sorry, please enter a number between 1 and 46.", 0
Fib_num		DWORD	0
Fib_num_2	DWORD	1
prompt_3	BYTE	"Results certified by Nick Jurczak", 0
goodBye		BYTE	"Good-bye, ", 0

.code
main PROC

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

TOP:				;Label to repeat operations from beginning.

;Get first number

	mov		edx, OFFSET prompt_2
	call	WriteString
	call	ReadInt
	mov		int1, eax

	mov		eax, int1
	cmp		eax, 1
	jge		PASS_1
	mov		edx, OFFSET Err_1
	call	WriteString
	call	CrLf
	jmp		TOP

;Validate user input

PASS_1:

	mov		eax, int1
	cmp		eax, UpperLimit
	jle		PASS_2
	mov		edx, OFFSET Err_1
	call	WriteString
	call	CrLf
	jmp		TOP

PASS_2:

;Display Fib numbers

	mov		ecx, int1
	mov		Fib_num, 0
	mov		Fib_num_2, 1

FIB:

	mov		eax, int1	;Determine wether to start new line
	sub		eax, ecx
	cdq
	mov		ebx, 5
	div		ebx
	cmp		edx, 0
	jne		CONT_LN
	call	CrLf

CONT_LN:

	mov		eax, Fib_num
	mov		ebx, Fib_num_2
	add		eax, ebx
	mov		ebx, Fib_num
	mov		Fib_num_2, ebx
	mov		Fib_num, eax
	mov		eax, Fib_num
	call	WriteDec

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

;	cmp		eax, 100000
;	jl		ENDF
;	mov		edx, OFFSET blank

ENDF:

	call	WriteString
	loop	FIB

;Ask user if they want to repeat operation
	
	call	CrLf
	mov		edx, OFFSET prompt_4
	call	WriteString
	call	CrLf
	mov		edx, OFFSET prompt_5
	call	WriteString
	call	ReadInt
	mov		response, eax
	mov		eax, response
	cmp		eax, 1
	je		TOP

;Say "Good-bye"
	call	CrLf

	mov		edx, OFFSET prompt_3
	call	WriteString
	call	CrLf
	mov		edx, OFFSET goodBye
	call	WriteString
	mov		edx, OFFSET userName
	call	WriteString
	call	CrLf

	exit
main ENDP

END main
