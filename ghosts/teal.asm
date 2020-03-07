tGhostInitX	    .EQU	15
tGhostInitY	    .EQU	8
tGhostInitTimer .EQU    40H
tGhostStoreX	.EQU	17 
tGhostStoreY	.EQU	11

tGhostX		    .EQU	8140H		
tGhostY		    .EQU	8141H
tGhostDir		.EQU	8142H
tGhostTimer     .EQU    8145H

tGhostClear:
				LD		A, (tGhostX)		;Push X to stack
				LD		C,A
				LD		A, (tGhostY)		;Push Y to stack
				LD		B,A
				CALL 	printMapAt
				RET
				
tGhostPrint:
				LD		A, (tGhostX)		;Push X to stack
				INC		A
				LD		C,A
				LD		A, (tGhostY)		;Push Y to stack
				INC		A
				LD		B,A
				CALL	moveCursor
                LD      A,(pPActive)
                OR      A
                JP      NZ, printSGhost
				LD		HL, tGhost
				CALL 	print
				RET
tGhostMapData:	
				LD		A, (tGhostX)
				LD		C,A
				LD		A, (tGhostY)
				LD		B,A
				CALL	getMapAddress
                LD      A,(HL)
				ret

tGhostInit:   
                LD		a, tGhostStoreX	;set tGhost Pos
			    LD		(tGhostX),a
			    LD		a, tGhostStoreY
			    LD		(tGhostY),a
                LD		a, tGhostInitTimer
			    LD		(tGhostTimer),a
                RET

tGhostMove:
                LD      A,(tGhostTimer)     ;Dont move if the ghost is in jale
                OR      A                
                JP      NZ,tGhostDecTimer   ;Decrement the timer if its x
                LD      A,(pPActive)
                BIT     0,A                 ;Move every other tick, bit 0 will always 0 when the power pellet isnt active
                RET     NZ
				LD		A,(tGhostDir)
				LD		DE,tGhostX
				LD		BC,tGhostY
				JP		ghostMove

tGhostDecTimer:
                DEC     A
                LD      (tGhostTimer),A
                OR      A
                RET     NZ              ;IF Zero move ghost out of jale
                LD		a, tGhostInitX	;set tGhost Pos
			    LD		(tGhostX),a
			    LD		a, tGhostInitY
			    LD		(tGhostY),a
                RET

tGhostNextMove:
				LD		A, 0FFH
				LD		(ghostDis),A
				CALL	tGhostMapData
				LD		D,A
				LD		A,	'W'			;check up
				CALL	isMoveValid
				CALL	NZ,tGhostCheckU
				LD		A,	'S'			;down
				CALL	isMoveValid
				CALL	NZ,tGhostCheckD
				LD		A,	'A'			;left
				CALL	isMoveValid
				CALL	NZ,tGhostCheckL
				LD		A,	'D'			;right
				CALL	isMoveValid
				CALL	NZ,tGhostCheckR
				RET
				
tGhostCheckU:	
				PUSH	AF
				LD		A, (tGhostY)
				DEC		A
				AND		00011111B
				LD		B,A
				LD		A,(tGhostX)
				LD		C,A
				JR		tGhostPathFind
tGhostCheckD:			
				PUSH	AF
				LD		A, (tGhostY)
				INC		A
				AND		00011111B
				LD		B,A
				LD		A,(tGhostX)
				LD		C,A
				JR		tGhostPathFind
tGhostCheckL:		
				PUSH	AF	
				LD		A, (tGhostX)
				DEC		A
				AND		00011111B
				LD		C,A
				LD		A,(tGhostY)
				LD		B,A
				JR		tGhostPathFind
tGhostCheckR:
				PUSH	AF	
				LD		A, (tGhostX)
				INC		A
				AND		00011111B
				LD		C,A
				LD		A,(tGhostY)
				LD		B,A
				JR		tGhostPathFind

tGhostPathFind:
				CALL	getAddressPF
				LD		A,(ghostDis)
				LD		E,(HL)
				CP		E
                PUSH    AF
                LD      A,(pPActive)            ;Check power pellet is not activ, if it is, run away
                OR      A
                JP      NZ,tGhostPFPP
                POP     AF
				JP		NC,tGhostSetNewDir
                POP     AF
				POP		AF
				RET
tGhostPFPP:
                POP     AF
                JP		C,tGhostSetNewDir
                CP      0FFH
                JP      Z,tGhostSetNewDir
                POP     AF
				POP		AF
                RET

tGhostSetNewDir:
				LD		A,E
				LD		(ghostDis),A
				POP		AF
				LD		(tGhostDir),A
				RET

tGhostColide:   
                LD      A,(pacx)                ;Compair X
                LD      B,A
                LD      A,(tGhostX)
                CP      B
                RET     NZ
                LD      A,(pacy)                ;Compair Y
                LD      B,A
                LD      A,(tGhostY)
                CP      B
                RET     NZ
                LD      A,(pPActive)              ;Colishion Happened
                OR      A
                JP      Z,killPacman               ;If power pellet not active, run genric deth lib
				CALL	eatGhost
                LD		a, tGhostStoreX	           ;set tGhost Pos
			    LD		(tGhostX),a
			    LD		a, tGhostStoreY
			    LD		(tGhostY),a
                LD		a, tGhostInitTimer
			    LD		(tGhostTimer),a
                RET

;x = l
;y = h
tGhostStack:
				LD      A,L               		;Compair X
                LD      B,A
                LD      A,(tGhostX)
                CP      B
                RET     NZ
                LD      A,h                		;Compair Y
                LD      B,A
                LD      A,(tGhostY)
                CP      B
                RET

tGhost:		.BYTE	1BH,"[96mM",1BH,"[0m",0