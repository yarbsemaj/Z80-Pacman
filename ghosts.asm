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

include ghosts/red.asm
include ghosts/orange.asm
include ghosts/pink.asm
include ghosts/teal.asm


sGhost0:	.BYTE	1BH,"[34mM",1BH,"[0m",0
sGhost1:	.BYTE	1BH,"[97mM",1BH,"[0m",0