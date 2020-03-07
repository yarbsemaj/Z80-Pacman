seed			.EQU	8888H		;Random seed

newline:			
				push 	af
				ld		a, CR
				rst 	08H
				ld		a, LF
				rst 	08H
				pop 	af
				ret
			
;move cursor to (C,B)				
moveCursor:		
				PUSH	HL
				LD		A,$1B
				RST     08H
				LD		A,'['
				RST     08H
				LD		L,B
				LD		H,0
				CALL	HLToDec
				LD		A,$3B
				RST     08H
				LD		L,C
				LD		H,0
				CALL	HLToDec
				LD		A,'f'
				RST     08H
				POP		HL
				RET

;Prints	hl as decimal			
HLToDec:
				PUSH	AF
				PUSH	BC
				CALL	DispHL
				POP		BC
				POP		AF
				RET
DispHL:
				ld		bc,-10000
				call	Num1
				ld		bc,-1000
				call	Num1
				ld		bc,-100
				call	Num1
				ld		c,-10
				call	Num1
				ld		c,-1
Num1:			ld		a,'0'-1
Num2:			inc		a
				add		hl,bc
				jr		c,Num2
				sbc		hl,bc
				RST     08H
				ret
;Print A as HEX				
NumToHex:    	
				push	bc
                push    af
				ld 		c, a   		; a = number to convert
            	call 	Num1H
            	RST     08H
            	ld 		a, c
            	call 	Num2H
            	RST     08H
                pop     af
				pop		bc
            	ret

Num1H:        	rra
            	rra
            	rra
           		rra
Num2H:        	or 		$F0
            	daa
            	add 	a, $A0
            	adc 	a, $40 		; Ascii hex at this point (0 to F)   
            	ret

;Get ABS of A
absA:
     or a
     ret p
     neg
     ret

;getArAndomA	 
randomA:				
				ld a, 	(seed)
				ld b, 	a 

				rrca ; multiply by 32
				rrca
				rrca
				xor $1f

				add 	a, b
				sbc a, 255 ; carry

				ld (seed), a
				ret

;------- Print string
print:			PUSH 	AF				; Preserve AF				
printLoop:      LD      A,(HL)          ; Get character
                OR      A               ; Is it $00 ?
                JR     	Z,printRet      ; Then RETurn on terminator
                RST     08H             ; Print it
                INC     HL              ; Next Character
                JR      printLoop       ; Continue until $00

printRet:		POP		AF
				RET

;--------Print textBlockAtPos
;HL Start of sprite
;C  Sprite X
;B  Sprite Y

printAtPos:		PUSH 	AF					; Preserve AF				
printAtPosLoop: CALL	moveCursor			; Move cursor to start of line
				CALL	print				; Print Line
				INC		B
				INC		HL
				LD      A,(HL)          	; Get character
                OR      A               	; Is it $00 ?
				INC		HL
                JR      NZ,printAtPosLoop   ; Continue until $00		
				POP		AF
				RET

;------------Draw Box
;C Start X
;B Start Y

;D Width
;E Height
drawBox:
				DEC		E
				DEC		E
				CALL	moveCursor			; Move cursor to start of line
				PUSH	BC
				LD		B,D
topLineLoop:	LD		A,'#'
				RST		08H
				DJNZ	topLineLoop			;Print Top line
				DEC		D					;Remove padding for left and right bars
				DEC		D
				LD		B,E
boxBodyLoop:	LD		E,B
				POP		BC
				INC		B
				CALL	moveCursor
				PUSH	BC
				LD		A,'#'
				RST		08H
				LD		B,D
boxContentLoop:	LD		A,' '
				RST		08H
				DJNZ	boxContentLoop
				LD		A,'#'
				RST		08H
				LD		B,E
				DJNZ	boxBodyLoop
				POP		BC
				INC		B
				CALL	moveCursor			; Move cursor to start of line
				INC		D
				INC		D
				LD		B,D
bottomLineLoop:	LD		A,'#'
				RST		08H
				DJNZ	bottomLineLoop			;Print Top line
				RET		
;--------Delay
delay:
				PUSH	BC
delayLoop:
				NOP
				DEC 	BC
				LD 		A,B
				OR 		C
				JR 		NZ,delayLoop
				POP		BC
				RET