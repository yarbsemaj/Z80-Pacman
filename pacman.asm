;Packman
pacx			.EQU	8100H
pacy			.EQU	8101H
pacCDir			.EQU	8102H		;Pacmans current direction
pacNDir			.EQU	8103H		;Pacman next direction (from key press)
pacLives		.EQU	8105H		;Pacman next direction (from key press)

initPacx		.EQU	14
initPacy		.EQU	14
initLives		.EQU	4

pPelletTics     .EQU    20H         ;Power Pellet last time

pPActive        .EQU    8104H       ;Power Pellet Timer

initPacman:
				LD		HL, 0H
				LD		(score), HL
				LD		a,initLives
				LD		(pacLives),a
resetPacMan:	LD		a, initPacx		;set Pacman Pos
				LD		(pacx),a
				LD		a, initPacy
				LD		(pacy),a
				LD		a, 'D'			;Set start direction
				LD		(pacCDir),A
				LD		(pacNDir),A
				LD		a,0
				LD		(pPActive),A
				RET

clearPM:
				LD		A, (pacx)		;Push X to stack
				LD		C,A
				LD		A, (pacy)		;Push Y to stack
				LD		B,A
				CALL 	printMapAt
				RET
				
printPM:
				LD		A, (pacx)		;Push X to stack
				INC		A
				LD		L,A
				LD		H, $00			;We dont care about msb
				PUSH	HL
				LD		A, (pacy)		;Push Y to stack
				INC		A
				LD		L,A
				LD		H, $00			;Again we dont care
				PUSH	HL
				CALL	moveCursor
				LD		HL, pacman
				CALL 	print
				RET
getPMMapData:	
				LD		A, (pacx)
				LD		C,A
				LD		A, (pacy)
				LD		B,A
				CALL	getMapAddress
                LD      A,(HL)
				ret
eatPellet:		;Eat pellet at packman location
				CALL 	getPMMapData
				BIT		pelletBit,A
				JR		NZ,eatSPellet
                BIT		powerPBit,A
				JR		NZ,eatPPellet
				RET
				
eatSPellet:		
				PUSH	HL		
				LD		HL,(score)
				INC		HL
				LD		(score),HL
				POP		HL
				RES		pelletBit,(HL)
				RET

eatPPellet:		
				LD      A,pPelletTics
                LD      (pPActive),A
                RES		powerPBit,(HL)
				RET
				
getMove:		;Sets the current move var
				CALL	getPMMapData
				LD		D,A
				LD		A,(pacNDir)			;Is the next move valid
				CALL	isMoveValid
				JR		NZ,nextMoveValid
				LD		A,(pacCDir)			;Is the current move valid
				CALL	isMoveValid
				RET		NZ
				JR		calcNextMove
				
nextMoveValid:
				LD		(pacCDir),A
				LD		(pacNDir),A
				RET
				
calcNextMove:	
				CP		'A'
				JR		Z,checkV
				CP		'D'
				JR		Z,checkV
				JR		checkH
checkH:
				LD		A,'A'
				CALL	isMoveValid
				JR		NZ,nextMoveValid
				LD		A,'D'
				CALL	isMoveValid
				JR		NZ,nextMoveValid
checkV:
				LD		A,'W'
				CALL	isMoveValid
				JR		NZ,nextMoveValid
				LD		A,'S'
				CALL	isMoveValid
				JR		NZ,nextMoveValid
				JR		checkH
;Move
movePM:
				LD      A,(pPActive)
                OR      A
                JP      Z,movePMA
                DEC     A
                LD      (pPActive),A
movePMA:        LD		A,(pacCDir)
				LD		DE,pacx
				LD		BC,pacy
				JP		move

killPacman:
				POP		HL
				POP		HL
				LD		A,(pacLives)
				DEC		A
				OR		A
				JP		Z,endGame
				LD		(pacLives),A
				CALL	resetPacMan
				CALL	initGhost
				JP		gameLoop

pacman:			.BYTE	1BH,"[93mC",1BH,"[0m",0