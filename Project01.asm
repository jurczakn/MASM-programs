TITLE Dog Years			(Project01.asm)

; AUTHOR: Nick Jurczak		DATE: 01/18/15
; DESCRIPTION: Introduce programmer, ask user's name and age,
; calculate the user's "dog age", produce results, and say good-bye.

INCLUDE Irvine32.inc

.data
int1		DWORD	?			;integer to be entered by user
int2		DWORD	?			;integer to be entered by user
titl		BYTE	"      Nick Jurczak          Programming Assignment #1", 0
intro_1		BYTE	"Please enter two numbers and you will be shown the sum, difference, product, and quotient with remainder of those numbers.", 0
prompt_1	BYTE	"What's your name?", 0
intro_2		BYTE	"Nice to meet you, ", 0
prompt_2	BYTE	"Enter your first number: ", 0
prompt_3	BYTE	"Enter your second number: ", 0
prompt_4	BYTE	"Would you like to perform another calculation?", 0
prompt_5	BYTE	"Please enter 1 for yes and 0 for no: ", 0
response	DWORD	?			;response to prompt 4 entered by user
err_1		BYTE	"Please make sure the first number entered is larger than the second.", 0
sum			DWORD	?
dif			DWORD	?
prod		DWORD	?
quot		DWORD	?
rema		DWORD	?
result_1	BYTE	" = ", 0
result_sum	BYTE	" + ", 0
result_dif	BYTE	" - ", 0
result_pro	BYTE	" x ", 0
result_quo	BYTE	" ÷ ", 0
result_rem	BYTE	" remainder ", 0
goodBye		BYTE	"Good-bye, ", 0

.code
main PROC

;Display title

	mov		edx, OFFSET titl
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

;Get second number

	mov		edx, OFFSET prompt_3
	call	WriteString
	call	ReadInt
	mov		int2, eax
	call	CrLf

;Check if first number larger than second.

	mov		eax, int1
	cmp		eax, int2
	jge		CALC
	mov		edx, OFFSET err_1
	call	WriteString
	call	CrLf
	jmp		TOP

;Calculate product

CALC:				;Label to jump to if input is correct
	mov		eax, int1
	mov		ebx, int2
	mul		ebx
	mov		prod, eax

;Calculate sum

	mov		eax, int1
	add		eax, int2
	mov		sum, eax

;Calculate difference

	mov		eax, int1
	sub		eax, int2
	mov		dif, eax

;Calculate quotient

	mov		eax, int1
	cdq
	mov		ebx, int2
	div		ebx
	mov		quot, eax
	mov		rema, edx

;Report result of sum
	
	mov		eax, int1
	call	WriteDec
	mov		edx, OFFSET result_sum
	call	WriteString
	mov		eax, int2
	call	WriteDec
	mov		edx, OFFSET result_1
	call	WriteString
	mov		eax, sum
	call	WriteDec
	call	CrLf

;Report result of difference
	
	mov		eax, int1
	call	WriteDec
	mov		edx, OFFSET result_dif
	call	WriteString
	mov		eax, int2
	call	WriteDec
	mov		edx, OFFSET result_1
	call	WriteString
	mov		eax, dif
	call	WriteDec
	call	CrLf

;Report result of product
	
	mov		eax, int1
	call	WriteDec
	mov		edx, OFFSET result_pro
	call	WriteString
	mov		eax, int2
	call	WriteDec
	mov		edx, OFFSET result_1
	call	WriteString
	mov		eax, prod
	call	WriteDec
	call	CrLf

;Report result of	quotient
	
	mov		eax, int1
	call	WriteDec
	mov		edx, OFFSET result_quo
	call	WriteString
	mov		eax, int2
	call	WriteDec
	mov		edx, OFFSET result_1
	call	WriteString
	mov		eax, quot
	call	WriteDec
	mov		edx, OFFSET result_rem
	call	WriteString
	mov		eax, rema
	call	WriteDec
	call	CrLf

;Ask user if they want to repeat operation
	
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

	mov		edx, OFFSET goodBye
	call	WriteString
	call	CrLf

	exit
main ENDP

END main
