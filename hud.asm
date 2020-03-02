score			.EQU	8900H		;Score

printHud:
				CALL	printScore
				CALL	printLives
				RET
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

printLives:					
				LD		HL, $02
				PUSH	HL
				LD		HL, $24
				PUSH	HL
				CALL	moveCursor
				LD 		A,(pacLives)
				DEC		A
				OR		A
				JP		Z,removeOldLives
				LD		B,A
printLivesLoop:	LD		HL, pacman
				CALL 	print
				DJNZ	printLivesLoop
removeOldLives:	LD		HL, liveBlanking
				CALL 	print
				RET

scoreHUD:     	.BYTE "Score: ",0
liveBlanking	.BYTE "   ",0