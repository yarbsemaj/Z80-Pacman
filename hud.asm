score			.EQU	8900H		;Score

printScore:					
				LD		HL, $02
				PUSH	HL
				LD		HL, $23
				PUSH	HL
				CALL	moveCursor
				LD		HL, scoreHUD
				CALL 	print
				LD		HL, (score)
				CALL	HLToDec
				LD		A,LF
				RST     08H
				LD		A,CR
				RST     08H
				RET