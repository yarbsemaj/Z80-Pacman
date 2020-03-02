CR              .EQU     0DH
LF              .EQU     0AH

oldStackPointer	.EQU	89F0H		;Old Stack Location 	
originalBC		.EQU	89F2H		;BC before manipulation, used for calculating board position

	.ORG 9000H
			ld		(oldStackPointer), SP
			ld		sp,0FFFFH
			CALL	initPacman
			CALL	initGhost
			CALL	initMap
			LD		HL, cls			;Clear screen
			CALL	print
			LD		HL, hideCursor	;Hide Cursor
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

			call	ghostNextMove
			call	clearGhost
			call	colideGhost
			call	moveGhost
			call	printGhost

			call	colideGhost


			;call 	printPFMap
			
			call 	printHUD
			LD 		B,0FH   ;delay
			LD		C,0FFH
			CALL 	DELAY
			JP		gameLoop
			LD		SP,(oldStackPointer)
			ret

endGame:        LD		HL, showCursor	;Hide Cursor
			    CALL	print
                LD		SP,(oldStackPointer)
				RET	
		
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
void:			.BYTE	" ",0

cls:      	  	.BYTE 1BH,"[H",1BH,"[2J",0
hideCursor:	  	.BYTE	1BH,"[?25l",0
showCursor:	  	.BYTE	1BH,"[?25h",0

;----- Map ------		
	.ORG 0C000H
include map.asm

;-----Path find map
pathFindMap	.EQU	0D000H

liveMap		.EQU	0E000H