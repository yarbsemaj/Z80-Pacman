oGhostInitX	    .EQU	15
oGhostInitY	    .EQU	8
oGhostInitTimer .EQU    20H
oGhostStoreX	.EQU	15
oGhostStoreY	.EQU	11

oGhostX		    .EQU	8120H		
oGhostY		    .EQU	8121H
oGhostDir		.EQU	8122H
oGhostTimer     .EQU    8125H

oGhostClear:
				LD		A, (oGhostX)		;Push X to stack
				LD		C,A
				LD		A, (oGhostY)		;Push Y to stack
				LD		B,A
				CALL 	printMapAt
				RET
				
oGhostPrint:
				LD		A, (oGhostX)		;Push X to stack
				INC		A
				LD		L,A
				LD		H, $00			;We dont care about msb
				PUSH	HL
				LD		A, (oGhostY)		;Push Y to stack
				INC		A
				LD		L,A
				LD		H, $00			;Again we dont care
				PUSH	HL
				CALL	moveCursor
                LD      A,(pPActive)
                OR      A
                JP      NZ, printSGhost
				LD		HL, oGhost
				CALL 	print
				RET
oGhostMapData:	
				LD		A, (oGhostX)
				LD		C,A
				LD		A, (oGhostY)
				LD		B,A
				CALL	getMapAddress
                LD      A,(HL)
				ret


oGhostInit:   
                LD		a, oGhostStoreX	;set oGhost Pos
			    LD		(oGhostX),a
			    LD		a, oGhostStoreY
			    LD		(oGhostY),a
                LD		a, oGhostInitTimer
			    LD		(oGhostTimer),a
                RET

oGhostMove:
                LD      A,(oGhostTimer)     ;Dont move if the ghost is in jale
                OR      A                
                JP      NZ,oGhostDecTimer   ;Decrement the timer if its x
                LD      A,(pPActive)
                BIT     0,A                 ;Move every other tick, bit 0 will always 0 when the power pellet isnt active
                RET     NZ
				LD		A,(oGhostDir)
				LD		DE,oGhostX
				LD		BC,oGhostY
				JP		ghostMove

oGhostDecTimer:
                DEC     A
                LD      (oGhostTimer),A
                OR      A
                RET     NZ              ;IF Zero move ghost out of jale
                LD		a, oGhostInitX	;set oGhost Pos
			    LD		(oGhostX),a
			    LD		a, oGhostInitY
			    LD		(oGhostY),a
                RET

oGhostNextMove:
				LD		A, 0FFH
				LD		(ghostDis),A
				CALL	oGhostMapData
				LD		D,A
				LD		A,	'W'			;check up
				CALL	isMoveValid
				CALL	NZ,oGhostCheckU
				LD		A,	'S'			;down
				CALL	isMoveValid
				CALL	NZ,oGhostCheckD
				LD		A,	'A'			;left
				CALL	isMoveValid
				CALL	NZ,oGhostCheckL
				LD		A,	'D'			;right
				CALL	isMoveValid
				CALL	NZ,oGhostCheckR
				RET
				
oGhostCheckU:	
				PUSH	AF
				LD		A, (oGhostY)
				DEC		A
				AND		00011111B
				LD		B,A
				LD		A,(oGhostX)
				LD		C,A
				JR		oGhostPathFind
oGhostCheckD:			
				PUSH	AF
				LD		A, (oGhostY)
				INC		A
				AND		00011111B
				LD		B,A
				LD		A,(oGhostX)
				LD		C,A
				JR		oGhostPathFind
oGhostCheckL:		
				PUSH	AF	
				LD		A, (oGhostX)
				DEC		A
				AND		00011111B
				LD		C,A
				LD		A,(oGhostY)
				LD		B,A
				JR		oGhostPathFind
oGhostCheckR:
				PUSH	AF	
				LD		A, (oGhostX)
				INC		A
				AND		00011111B
				LD		C,A
				LD		A,(oGhostY)
				LD		B,A
				JR		oGhostPathFind

oGhostPathFind:
				CALL	getAddressPF
				LD		A,(ghostDis)
				LD		E,(HL)
				CP		E
                PUSH    AF
                LD      A,(pPActive)            ;Check power pellet is not activ, if it is, run away
                OR      A
                JP      NZ,oGhostPFPP
                POP     AF
				JP		NC,oGhostSetNewDir
                POP     AF
				POP		AF
				RET
oGhostPFPP:
                POP     AF
                JP		C,oGhostSetNewDir
                CP      0FFH
                JP      Z,oGhostSetNewDir
                POP     AF
				POP		AF
                RET

oGhostSetNewDir:
				LD		A,E
				LD		(ghostDis),A
				POP		AF
				LD		(oGhostDir),A
				RET

oGhostColide:   
                LD      A,(pacx)                ;Compair X
				;CALL	NumToHex
                LD      B,A
                LD      A,(oGhostX)
				;CALL	NumToHex
                CP      B
                RET     NZ
                LD      A,(pacy)                ;Compair Y
				;CALL	NumToHex
                LD      B,A
                LD      A,(oGhostY)
				;CALL	NumToHex
                CP      B
                RET     NZ
                LD      A,(pPActive)              ;Colishion Happened
                OR      A
                JP      Z,killPacman               ;If power pellet not active, run genric deth lib
                LD		a, oGhostStoreX	           ;set oGhost Pos
			    LD		(oGhostX),a
			    LD		a, oGhostStoreY
			    LD		(oGhostY),a
                LD		a, oGhostInitTimer
			    LD		(oGhostTimer),a
                RET
;x = l
;y = h
oGhostStack:
				LD      A,L               		;Compair X
                LD      B,A
                LD      A,(oGhostX)
                CP      B
                RET     NZ
                LD      A,h                		;Compair Y
                LD      B,A
                LD      A,(oGhostY)
                CP      B
                RET

oGhost:		.BYTE	1BH,"[33mM",1BH,"[0m",0