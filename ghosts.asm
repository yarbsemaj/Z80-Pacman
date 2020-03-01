;Ghost
;Red
initRedGhostX	.EQU	20
initRedGhostY	.EQU	1
storeRedGhostX	.EQU	15
storeRedGhostX	.EQU	15

;Orange
initRedGhostX	.EQU	20
initRedGhostY	.EQU	1
storeRedGhostX	.EQU	15
storeRedGhostX	.EQU	15

;Teal
initRedGhostX	.EQU	20
initRedGhostY	.EQU	1
storeRedGhostX	.EQU	15
storeRedGhostX	.EQU	15

;Prink
initRedGhostX	.EQU	20
initRedGhostY	.EQU	1
storeRedGhostX	.EQU	15
storeRedGhostX	.EQU	15


;Red
clearRedGhost:
				LD		A, (redGhostX)		;Push X to stack
				LD		C,A
				LD		A, (redGhostY)		;Push Y to stack
				LD		B,A
				CALL 	printMapAt
				RET
				
printRedGhost:
				LD		A, (redGhostX)		;Push X to stack
				INC		A
				LD		L,A
				LD		H, $00			;We dont care about msb
				PUSH	HL
				LD		A, (redGhostY)		;Push Y to stack
				INC		A
				LD		L,A
				LD		H, $00			;Again we dont care
				PUSH	HL
				CALL	moveCursor
				LD		HL, redGhost
				CALL 	print
				RET
getRedGhostMapData:	
				LD		A, (redGhostX)
				LD		C,A
				LD		A, (redGhostY)
				LD		B,A
				CALL	getMapAddress
                LD      A,(HL)
				ret
;Move
moveRedGhost:
				LD		A,(redGhostDir)
				LD		DE,redGhostX
				LD		BC,redGhostY
				JP		move
getRedGhostNextMove:
				LD		A, 0FFH
				LD		(ghostDis),A
				CALL	getRedGhostMapData
				LD		D,A
				LD		A,	'W'			;check up
				CALL	isMoveValid
				CALL	NZ,redGhostCheckU
				LD		A,	'S'			;down
				CALL	isMoveValid
				CALL	NZ,redGhostCheckD
				LD		A,	'A'			;left
				CALL	isMoveValid
				CALL	NZ,redGhostCheckL
				LD		A,	'D'			;right
				CALL	isMoveValid
				CALL	NZ,redGhostCheckR
				RET
				
redGhostCheckU:	
				PUSH	AF
				LD		A, (redGhostY)
				DEC		A
				AND		00011111B
				LD		B,A
				LD		A,(redGhostX)
				LD		C,A
				JR		redGhostPathFind
redGhostCheckD:			
				PUSH	AF
				LD		A, (redGhostY)
				INC		A
				AND		00011111B
				LD		B,A
				LD		A,(redGhostX)
				LD		C,A
				JR		redGhostPathFind
redGhostCheckL:		
				PUSH	AF	
				LD		A, (redGhostX)
				DEC		A
				AND		00011111B
				LD		C,A
				LD		A,(redGhostY)
				LD		B,A
				JR		redGhostPathFind
redGhostCheckR:
				PUSH	AF	
				LD		A, (redGhostX)
				INC		A
				AND		00011111B
				LD		C,A
				LD		A,(redGhostY)
				LD		B,A
				JR		redGhostPathFind

redGhostPathFind:
				CALL	getAddressPF
				LD		A,(ghostDis)
				LD		E,(HL)
				CP		E
				JP		NC,redGhostSetNewDir
				POP		AF
				RET
redGhostSetNewDir:
				LD		A,E
				LD		(ghostDis),A
				POP		AF
				LD		(redGhostDir),A
				RET


redGhost:		.BYTE	1BH,"[91mM",1BH,"[0m",0
greenGhost:		.BYTE	1BH,"[92mM",1BH,"[0m",0
blueGhost:		.BYTE	1BH,"[36mM",1BH,"[0m",0
pinkGhost:		.BYTE	1BH,"[95mM",1BH,"[0m",0