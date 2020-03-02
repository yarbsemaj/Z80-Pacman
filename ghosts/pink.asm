pGhostInitX	    .EQU	15
pGhostInitY	    .EQU	8
pGhostInitTimer .EQU    30H
pGhostStoreX	.EQU	16
pGhostStoreY	.EQU	11

pGhostX		    .EQU	8130H		
pGhostY		    .EQU	8131H
pGhostDir		.EQU	8132H
pGhostTimer     .EQU    8135H

pGhostClear:
				LD		A, (pGhostX)		;Push X to stack
				LD		C,A
				LD		A, (pGhostY)		;Push Y to stack
				LD		B,A
				CALL 	printMapAt
				RET
				
pGhostPrint:
				LD		A, (pGhostX)		;Push X to stack
				INC		A
				LD		L,A
				LD		H, $00			;We dont care about msb
				PUSH	HL
				LD		A, (pGhostY)		;Push Y to stack
				INC		A
				LD		L,A
				LD		H, $00			;Again we dont care
				PUSH	HL
				CALL	moveCursor
                LD      A,(pPActive)
                OR      A
                JP      NZ, printSGhost
				LD		HL, pGhost
				CALL 	print
				RET
pGhostMapData:	
				LD		A, (pGhostX)
				LD		C,A
				LD		A, (pGhostY)
				LD		B,A
				CALL	getMapAddress
                LD      A,(HL)
				ret


pGhostInit:   
                LD		a, pGhostStoreX	;set pGhost Pos
			    LD		(pGhostX),a
			    LD		a, pGhostStoreY
			    LD		(pGhostY),a
                LD		a, pGhostInitTimer
			    LD		(pGhostTimer),a
                RET

pGhostMove:
                LD      A,(pGhostTimer)     ;Dont move if the ghost is in jale
                OR      A                
                JP      NZ,pGhostDecTimer   ;Decrement the timer if its x
                LD      A,(pPActive)
                BIT     0,A                 ;Move every other tick, bit 0 will always 0 when the power pellet isnt active
                RET     NZ
				LD		A,(pGhostDir)
				LD		DE,pGhostX
				LD		BC,pGhostY
				JP		ghostMove


pGhostDecTimer:
                DEC     A
                LD      (pGhostTimer),A
                OR      A
                RET     NZ              ;IF Zero move ghost out of jale
                LD		a, pGhostInitX	;set pGhost Pos
			    LD		(pGhostX),a
			    LD		a, pGhostInitY
			    LD		(pGhostY),a
                RET

pGhostNextMove:
				LD		A, 0FFH
				LD		(ghostDis),A
				CALL	pGhostMapData
				LD		D,A
				LD		A,	'W'			;check up
				CALL	isMoveValid
				CALL	NZ,pGhostCheckU
				LD		A,	'S'			;down
				CALL	isMoveValid
				CALL	NZ,pGhostCheckD
				LD		A,	'A'			;left
				CALL	isMoveValid
				CALL	NZ,pGhostCheckL
				LD		A,	'D'			;right
				CALL	isMoveValid
				CALL	NZ,pGhostCheckR
				RET
				
pGhostCheckU:	
				PUSH	AF
				LD		A, (pGhostY)
				DEC		A
				AND		00011111B
				LD		B,A
				LD		A,(pGhostX)
				LD		C,A
				JR		pGhostPathFind
pGhostCheckD:			
				PUSH	AF
				LD		A, (pGhostY)
				INC		A
				AND		00011111B
				LD		B,A
				LD		A,(pGhostX)
				LD		C,A
				JR		pGhostPathFind
pGhostCheckL:		
				PUSH	AF	
				LD		A, (pGhostX)
				DEC		A
				AND		00011111B
				LD		C,A
				LD		A,(pGhostY)
				LD		B,A
				JR		pGhostPathFind
pGhostCheckR:
				PUSH	AF	
				LD		A, (pGhostX)
				INC		A
				AND		00011111B
				LD		C,A
				LD		A,(pGhostY)
				LD		B,A
				JR		pGhostPathFind

pGhostPathFind:
				CALL	getAddressPF
				LD		A,(ghostDis)
				LD		E,(HL)
				CP		E
                PUSH    AF
                LD      A,(pPActive)            ;Check power pellet is not activ, if it is, run away
                OR      A
                JP      NZ,pGhostPFPP
                POP     AF
				JP		NC,pGhostSetNewDir
                POP     AF
				POP		AF
				RET
pGhostPFPP:
                POP     AF
                JP		C,pGhostSetNewDir
                CP      0FFH
                JP      Z,pGhostSetNewDir
                POP     AF
				POP		AF
                RET

pGhostSetNewDir:
				LD		A,E
				LD		(ghostDis),A
				POP		AF
				LD		(pGhostDir),A
				RET

pGhostColide:   
                LD      A,(pacx)                ;Compair X
				;CALL	NumToHex
                LD      B,A
                LD      A,(pGhostX)
				;CALL	NumToHex
                CP      B
                RET     NZ
                LD      A,(pacy)                ;Compair Y
				;CALL	NumToHex
                LD      B,A
                LD      A,(pGhostY)
				;CALL	NumToHex
                CP      B
                RET     NZ
                LD      A,(pPActive)              ;Colishion Happened
                OR      A
                JP      Z,killPacman               ;If power pellet not active, run genric deth lib
                LD		a, pGhostStoreX	           ;set pGhost Pos
			    LD		(pGhostX),a
			    LD		a, pGhostStoreY
			    LD		(pGhostY),a
                LD		a, pGhostInitTimer
			    LD		(pGhostTimer),a
                RET

;x = l
;y = h
pGhostStack:
				LD      A,L               		;Compair X
                LD      B,A
                LD      A,(pGhostX)
                CP      B
                RET     NZ
                LD      A,h                		;Compair Y
                LD      B,A
                LD      A,(pGhostY)
                CP      B
                RET

pGhost:		.BYTE	1BH,"[95mM",1BH,"[0m",0