rGhostInitX	    .EQU	15
rGhostInitY	    .EQU	8
rGhostInitTimer .EQU    08H
rGhostStoreX	.EQU	14
rGhostStoreY	.EQU	11

rGhostX		    .EQU	8110H		
rGhostY		    .EQU	8111H
rGhostDir		.EQU	8112H
rGhostTimer     .EQU    8115H

rGhostClear:
				LD		A, (rGhostX)		;Push X to stack
				LD		C,A
				LD		A, (rGhostY)		;Push Y to stack
				LD		B,A
				CALL 	printMapAt
				RET
				
rGhostPrint:
				LD		A, (rGhostX)		;Push X to stack
				INC		A
				LD		L,A
				LD		H, $00			;We dont care about msb
				PUSH	HL
				LD		A, (rGhostY)		;Push Y to stack
				INC		A
				LD		L,A
				LD		H, $00			;Again we dont care
				PUSH	HL
				CALL	moveCursor
                LD      A,(pPActive)
                OR      A
                JP      NZ, printSGhost
				LD		HL, rGhost
				CALL 	print
				RET
rGhostMapData:	
				LD		A, (rGhostX)
				LD		C,A
				LD		A, (rGhostY)
				LD		B,A
				CALL	getMapAddress
                LD      A,(HL)
				ret


rGhostInit:   
                LD		a, rGhostStoreX	;set rGhost Pos
			    LD		(rGhostX),a
			    LD		a, rGhostStoreY
			    LD		(rGhostY),a
                LD		a, rGhostInitTimer
			    LD		(rGhostTimer),a
                RET

rGhostMove:
                LD      A,(rGhostTimer)     ;Dont move if the ghost is in jale
                OR      A                
                JP      NZ,rGhostDecTimer   ;Decrement the timer if its x
                LD      A,(pPActive)
                BIT     0,A                 ;Move every other tick, bit 0 will always 0 when the power pellet isnt active
                RET     NZ
				LD		A,(rGhostDir)
				LD		DE,rGhostX
				LD		BC,rGhostY
				JP		move

rGhostDecTimer:
                DEC     A
                LD      (rGhostTimer),A
                OR      A
                RET     NZ              ;IF Zero move ghost out of jale
                LD		a, rGhostInitX	;set rGhost Pos
			    LD		(rGhostX),a
			    LD		a, rGhostInitY
			    LD		(rGhostY),a
                RET

rGhostNextMove:
				LD		A, 0FFH
				LD		(ghostDis),A
				CALL	rGhostMapData
				LD		D,A
				LD		A,	'W'			;check up
				CALL	isMoveValid
				CALL	NZ,rGhostCheckU
				LD		A,	'S'			;down
				CALL	isMoveValid
				CALL	NZ,rGhostCheckD
				LD		A,	'A'			;left
				CALL	isMoveValid
				CALL	NZ,rGhostCheckL
				LD		A,	'D'			;right
				CALL	isMoveValid
				CALL	NZ,rGhostCheckR
				RET
				
rGhostCheckU:	
				PUSH	AF
				LD		A, (rGhostY)
				DEC		A
				AND		00011111B
				LD		B,A
				LD		A,(rGhostX)
				LD		C,A
				JR		rGhostPathFind
rGhostCheckD:			
				PUSH	AF
				LD		A, (rGhostY)
				INC		A
				AND		00011111B
				LD		B,A
				LD		A,(rGhostX)
				LD		C,A
				JR		rGhostPathFind
rGhostCheckL:		
				PUSH	AF	
				LD		A, (rGhostX)
				DEC		A
				AND		00011111B
				LD		C,A
				LD		A,(rGhostY)
				LD		B,A
				JR		rGhostPathFind
rGhostCheckR:
				PUSH	AF	
				LD		A, (rGhostX)
				INC		A
				AND		00011111B
				LD		C,A
				LD		A,(rGhostY)
				LD		B,A
				JR		rGhostPathFind

rGhostPathFind:
				CALL	getAddressPF
				LD		A,(ghostDis)
				LD		E,(HL)
				CP		E
                PUSH    AF
                LD      A,(pPActive)            ;Check power pellet is not activ, if it is, run away
                OR      A
                JP      NZ,rGhostPFPP
                POP     AF
				JP		NC,rGhostSetNewDir
                POP     AF
				POP		AF
				RET
rGhostPFPP:
                POP     AF
                JP		C,rGhostSetNewDir
                CP      0FFH
                JP      Z,rGhostSetNewDir
                POP     AF
				POP		AF
                RET

rGhostSetNewDir:
				LD		A,E
				LD		(ghostDis),A
				POP		AF
				LD		(rGhostDir),A
				RET

rGhostColide:   
                LD      A,(pacx)                ;Compair X
				;CALL	NumToHex
                LD      B,A
                LD      A,(rGhostX)
				;CALL	NumToHex
                CP      B
                RET     NZ
                LD      A,(pacy)                ;Compair Y
				;CALL	NumToHex
                LD      B,A
                LD      A,(rGhostY)
				;CALL	NumToHex
                CP      B
                RET     NZ
                LD      A,(pPActive)              ;Colishion Happened
                OR      A
                JP      Z,killPacman               ;If power pellet not active, run genric deth lib
                LD		a, rGhostStoreX	           ;set rGhost Pos
			    LD		(rGhostX),a
			    LD		a, rGhostStoreY
			    LD		(rGhostY),a
                LD		a, caughtJaleTime
			    LD		(rGhostTimer),a
                RET

rGhost:		.BYTE	1BH,"[91mM",1BH,"[0m",0