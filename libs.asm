newline:			
				push 	af
				ld		a, CR
				rst 	08H
				ld		a, LF
				rst 	08H
				pop 	af
				ret
			
;move cursor to (sp,sp-2)				
moveCursor:		
				POP		DE
				LD		A,$1B
				RST     08H
				LD		A,'['
				RST     08H
				POP		HL
				CALL	HLToDec
				LD		A,$3B
				RST     08H
				POP		HL
				CALL	HLToDec
				LD		A,'f'
				RST     08H
				PUSH	DE
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
				ld 		c, a   		; a = number to convert
            	call 	Num1H
            	RST     08H
            	ld 		a, c
            	call 	Num2H
            	RST     08H
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
				
;delay loop
printRet:		
				POP		AF
				RET
delay:
				NOP
				DEC 	BC
				LD 		A,B
				OR 		C
				RET 	Z
				JR 		delay