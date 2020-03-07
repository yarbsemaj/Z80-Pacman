score			.EQU	8900H		;Score
level			.EQU	8902H		;Score
fruits			.EQU	8904H		;Score

printHud:
				CALL	printScore
				CALL	printLives
				CALL	printLevel
				CALL	printFruit
				RET
;Hud elements
printScore:					
				LD		C, $03
				LD		B, $19
				CALL	moveCursor
				LD		HL, scoreHUD
				CALL 	print
				LD		HL, (score)
				CALL	HLToDec
				RET
printLevel:					
				LD		C, $03
				LD		B, $1A
				CALL	moveCursor
				LD		HL, levelHUD
				CALL 	print
				LD		HL, (level)
				CALL	HLToDec
				RET

printLives:					
				LD		C, $03
				LD		B, $1B
				CALL	moveCursor
				LD		HL, livesHUD
				CALL 	print
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

printFruit:					
				LD		C, $03
				LD		B, $1C
				CALL	moveCursor
				LD		HL, fruitHud
				CALL 	print
				LD 		A,(fruits)
				OR		A
				RET		Z
				LD		B,A
printFruitLoop:	LD		HL, superFruit
				CALL 	print
				DJNZ	printFruitLoop
				RET

scoreHUD:     	.BYTE "Score: ",0
levelHUD:     	.BYTE "Level: ",0
livesHUD:     	.BYTE "Lives: ",0
fruitHud:     	.BYTE "Fruit: ",0

liveBlanking	.BYTE "   ",0