CR              .EQU     0DH
LF              .EQU     0AH

oldStackPointer	.EQU	89F0H		;Old Stack Location 	
originalBC		.EQU	89F2H		;BC before manipulation, used for calculating board position

	.ORG 9000H
			ld		(oldStackPointer), SP
			ld		sp,0FFFFH
			ld		a, initPacx		;set Pacman Pos
			ld		(pacx),a
			ld		a, initPacy
			ld		(pacy),a
			ld		a, 'D'			;Set start direction
			ld		(pacCDir),A
			ld		(pacNDir),A
			ld		HL, 0H
			LD		(score), HL
			ld		a, initRedGhostX	;set RedGhost Pos
			ld		(redGhostX),a
			ld		a, initRedGhostY
			ld		(redGhostY),a
			LD		HL, cls			;Clear screen
			CALL	print
			call 	printMap
gameLoop:		
			call	input
			call 	getMove
			call 	clearPM
			call	movePM
			call 	printPM
			call	eatPellet

			call	initPathFind
			call	calculatePathMap

			call	getRedGhostNextMove
			call	clearRedGhost
			call	moveRedGhost
			call	printRedGhost

			;call 	printPFMap
			
			call 	printScore
			LD 		B,0FFH   ;delay
			LD		C,0FFH
			;CALL 	DELAY
			JP		gameLoop
			LD		SP,(oldStackPointer)
			ret
		
;-------------- Input --------------------------					
include input.asm	
;----------Pacman------;
include	pacman.asm
;------------Ghost
include ghosts.asm
;-----------Spesific Libs -----;
include movelibs.asm	
include	mapLibs.asm	

;------HUD;
include hud.asm
			
;------- Libs ------------;
include libs.asm

;Strings
wall:			.BYTE	1BH,"[34m#",1BH,"[0m",0
powerPellet:	.BYTE	1BH,"[97mo",1BH,"[0m",0
pellet:			.BYTE	1BH,"[37m*",1BH,"[0m",0
superFruit:		.BYTE	1BH,"[31m@",1BH,"[0m",0

scoreHUD:     	.BYTE "Score: ",0

pacman:			.BYTE	1BH,"[93mC",1BH,"[0m",0

void:			.BYTE	" ",0

cls:      	  	.BYTE 1BH,"[H",1BH,"[2J",0
;-----Path find map
	.ORG 0D000H
pathFindMap:
;----- Map ------		
	.ORG 0E000H
	include map.asm