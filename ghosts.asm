ghostDis		.EQU	8113H		;ghost move distance from pacman
caughtJaleTime  .EQU    20H

ghostNextMove:
                CALL    rGhostNextMove
                CALL    oGhostNextMove
                CALL    pGhostNextMove
                CALL    tGhostNextMove
                RET
clearGhost:
                CALL    rGhostClear
                CALL    oGhostClear
                CALL    pGhostClear
                CALL    tGhostClear
                RET
printGhost:
                CALL    rGhostPrint
                CALL    oGhostPrint
                CALL    pGhostPrint
                CALL    tGhostPrint
                RET
colideGhost:
                CALL    rGhostColide
                CALL    oGhostColide
                CALL    pGhostColide
                CALL    tGhostColide
                RET
initGhost:
                CALL    rGhostInit
                CALL    oGhostInit
                CALL    pGhostInit
                CALL    tGhostInit
                RET
moveGhost:
                CALL    rGhostMove
                CALL    oGhostMove
                CALL    pGhostMove
                CALL    tGhostMove
                RET

printSGhost:
                BIT     0,A
                JP      Z,sGhost1Print
                LD		HL, sGhost0
				CALL 	print
				RET
sGhost1Print:
                LD		HL, sGhost1
				CALL 	print
				RET

ghostMove:
				CP		'W'
				JR		Z,ghostMoveU
				CP		'A'
				JR		Z,ghostMoveL
				CP		'S'
				JR		Z,ghostMoveD
				JR		ghostMoveR

ghostMoveU:			
				LD      A, (DE)
                LD      L,A         ;ld x
                LD		A, (BC)
				DEC		A
				AND		00011111B
                LD      H,A         ;ld y
                CALL    ghostCheckStack
				LD		(BC),A
				RET
ghostMoveD:		
	            LD      A, (DE)
                LD      L,A         ;ld x
				LD		A, (BC)
				INC		A
				AND		00011111B
                LD      H,A         ;ld y
                CALL    ghostCheckStack
				LD		(BC),A
				RET
ghostMoveL:		
                LD      A, (BC)
                LD      H,A         ;ld y
				LD		A, (DE)
				DEC		A
				AND		00011111B
                LD      L,A         ;ld x
                CALL    ghostCheckStack
				LD		(DE),A
				RET
ghostMoveR:		
                LD      A, (BC)
                LD      H,A         ;ld y
				LD		A, (DE)
				INC		A
				AND		00011111B
                LD      L,A         ;ld x
                CALL    ghostCheckStack
				LD		(DE),A
				RET
ghostCheckStack:
                PUSH   AF
                PUSH   BC
                PUSH   DE
                CALL   rGhostStack
                JP     Z,ghostDoStack
                CALL   oGhostStack
                JP     Z,ghostDoStack
                CALL   pGhostStack
                JP     Z,ghostDoStack
                CALL   tGhostStack
                JP     Z,ghostDoStack
                POP    DE
                POP    BC
                POP    AF
                RET
ghostDoStack:   
                POP    DE
                POP    BC
                POP    AF
                POP    AF
                RET
                
include ghosts/red.asm
include ghosts/orange.asm
include ghosts/pink.asm
include ghosts/teal.asm


sGhost0:	.BYTE	1BH,"[34mM",1BH,"[0m",0
sGhost1:	.BYTE	1BH,"[97mM",1BH,"[0m",0