score			.EQU	8900H		;Score

printHud:
				CALL	printScore
				CALL	printLives
				RET
;Hud elements
printScore:					
				LD		C, $02
				LD		B, $23
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
				LD		C, $02
				LD		B, $24
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