CR              .EQU     0DH
LF              .EQU     0AH

;----- Map data bit positions
upBit			.EQU	0
downBit			.EQU	1
leftBit			.EQU	2
rightBit		.EQU	3
powerpBit		.EQU	4
pelletBit		.EQU	5
wallBit			.EQU	6
sfBit			.EQU	7
;--------Initial Stats
initPacx		.EQU	14
initPacy		.EQU	14

initRedGhostX	.EQU	20
initRedGhostY	.EQU	1

;-----Varr
;Packman
pacx			.EQU	8100H
pacy			.EQU	8101H
pacCDir			.EQU	8102H		;Pacmans current direction
pacNDir			.EQU	8103H		;Pacman next direction (from key press)

;RedGhost
redGhostX		.EQU	8110H		
redGhostY		.EQU	8111H
redGhostDir		.EQU	8112H
redGhostDis		.EQU	8113H		;Red ghost move distance from pacman

seed			.EQU	8888H		;Random seed

score			.EQU	8900H		;Score

oldStackPointer	.EQU	89FEH		;Old Stack Location 	





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
			
			call	getRedGhostNextMove
			call	clearRedGhost
			call	moveRedGhost
			call	printRedGhost
			
			call 	printScore
			LD 		B,0FFH   ;delay
			LD		C,0FFH
			CALL 	DELAY
			JP		gameLoop
			ret
		
;-------------- Input --------------------------					
input:
				RST		18H
				RET		Z
				RST		10H
				AND     11011111b       ; lower to uppercase
				CP		'W'
				JR		Z,validInput
				CP		'A'
				JR		Z,validInput
				CP		'S'
				JR		Z,validInput
				CP		'D'
				JR		Z,validInput
				RET
validInput:		
				LD		(pacNDir), A
				RET
		
;----------Pacman------;
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
				CALL	getDataAtPos
				ret
eatPellet:		;Eat pellet at packman location
				CALL 	getPMMapData
				BIT		pelletBit,A
				JR		NZ,eatSPellet
				RET
				
eatSPellet:		
				PUSH	HL		
				LD		HL,(score)
				INC		HL
				INC		HL
				LD		(score),HL
				POP		HL
				RES		pelletBit,(HL)
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
				LD		A,(pacCDir)
				LD		DE,pacx
				LD		BC,pacy
				JP		move
;------------Ghost
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
				CALL	getDataAtPos
				ret
;Move
moveRedGhost:
				LD		A,(redGhostDir)
				LD		DE,redGhostX
				LD		BC,redGhostY
				JP		move
getRedGhostNextMove:
				LD		A, 41H
				LD		(redGhostDis),A
				CALL	getRedGhostMapData
				LD		D,A
				LD		A,	'W'			;check up
				CALL	isMoveValid
				CALL	NZ,redGhostSetMove
				LD		A,	'S'			;down
				CALL	isMoveValid
				CALL	NZ,redGhostSetMove
				LD		A,	'A'			;left
				CALL	isMoveValid
				CALL	NZ,redGhostSetMove
				LD		A,	'D'			;right
				CALL	isMoveValid
				CALL	NZ,redGhostSetMove
				RET
				
redGhostSetMove:
				PUSH	AF
				CP		'W'
				JR		Z,redGhostCheckU
				CP		'A'
				JR		Z,redGhostCheckL
				CP		'S'
				JR		Z,redGhostCheckD
				JR		redGhostCheckR
				
redGhostCheckU:			
				LD		A, (redGhostY)
				DEC		A
				AND		00011111B
				LD		C,A
				LD		A,(redGhostX)
				LD		B,A
				JR		redGhostPathFind
redGhostCheckD:			
				LD		A, (redGhostY)
				INC		A
				AND		00011111B
				LD		C,A
				LD		A,(redGhostX)
				LD		B,A
				JR		redGhostPathFind
redGhostCheckL:			
				LD		A, (redGhostX)
				DEC		A
				AND		00011111B
				LD		B,A
				LD		A,(redGhostY)
				LD		C,A
				JR		redGhostPathFind
redGhostCheckR:			
				LD		A, (redGhostX)
				INC		A
				AND		00011111B
				LD		B,A
				LD		A,(redGhostY)
				LD		C,A
				JR		redGhostPathFind

redGhostPathFind:
				LD		A,(redGhostDis)
				LD		E,A
				LD		A,(pacx)
				SUB		B
				CALL	absA
				LD		H,A
				LD		A,(pacy)
				SUB		C
				CALL	absA
				ADD		H
				CP		E
				JP		Z,redGhostSetEqual		;If 2 options are equidistant, chose a random one to prevent a loop
				JP		M,redGhostSetNewDir
				;CALL	NumToHex
				POP		AF
				;RST		08H
				RET
redGhostSetNewDir:
				LD		(redGhostDis),A
				;CALL	NumToHex
				POP		AF
				;RST		08H
				LD		(redGhostDir),A
				RET
redGhostSetEqual:
				LD		B,A
				CALL	randomA
				BIT		1,A
				JR		Z,redGhostRandomSet
				POP		AF
				RET
redGhostRandomSet:
				LD		A,B
				JR		redGhostSetNewDir
;-----------Generic Move Libs -----;
move:
				CP		'W'
				JR		Z,moveU
				CP		'A'
				JR		Z,moveL
				CP		'S'
				JR		Z,moveD
				JR		moveR

moveU:			
				LD		A, (BC)
				DEC		A
				AND		00011111B
				LD		(BC),A
				RET
moveD:			
				LD		A, (BC)
				INC		A
				AND		00011111B
				LD		(BC),A
				RET
moveL:			
				LD		A, (DE)
				DEC		A
				AND		00011111B
				LD		(DE),A
				RET
moveR:			
				LD		A, (DE)
				INC		A
				AND		00011111B
				LD		(DE),A
				RET
isMoveValid:
				CP		'W'
				JR		Z,moveUValid
				CP		'A'
				JR		Z,moveLValid
				CP		'S'
				JR		Z,moveDValid
				JR		moveRValid
moveUValid:			
				BIT		upBit,D
				RET
moveDValid:			
				BIT		downBit,D
				RET
moveLValid:			
				BIT		leftBit,D
				RET
moveRValid:			
				BIT		rightBit,D
				RET
				
;------- Get Map Data ----;
; C - X
; B	- Y
getDataAtPos:
				push	bc
				rlc		b			;Shift b left 5
				rlc		b			;Shift b left 5
				rlc		b			;Shift b left 5
				rlc		b			;Shift b left 5
				rlc		b			;Shift b left 5
				ld		a,b
				and		11100000b	;Mask lower adress
				or		c			;Combine with C
				ld		l,a			;A is now low byte of adress
				ld		a,b
				and		00000011b	;Mask upper adress
				or		0E0H		;Start of map
				ld		h,a
				ld		a,(HL)
				pop		bc
				ret

;------- Get Path Find Map Address----;
; C - X
; B	- Y
getAddressPF:
				push	bc
				rlc		b			;Shift b left 5
				rlc		b			;Shift b left 5
				rlc		b			;Shift b left 5
				rlc		b			;Shift b left 5
				rlc		b			;Shift b left 5
				ld		a,b
				and		11100000b	;Mask lower adress
				or		c			;Combine with C
				ld		l,a			;A is now low byte of adress
				ld		a,b
				and		00000011b	;Mask upper adress
				or		0D0H		;Start of map
				ld		h,a
				pop		bc
				ret


;--------- Map print -------- ;
; C - X
; B	- Y
printMapAt:	
			PUSH	BC
			INC		C
			LD		L,C
			LD		H, $00			;We dont care about msb
			PUSH	HL
			INC		B
			LD		L,B
			LD		H, $00			;Again we dont care
			PUSH	HL
			CALL	moveCursor
			POP 	BC
			CALL	getDataAtPos
			CALL	pmChar
			RET

printMap:
				ld		a,32
				ld		b,a			; 32 chars per line
				ld		c,a			; 32 lines per map
				ld		hl,map
pmLoop:			ld		a,(hl)		; get char
				call	pmChar		; decode what to print
				inc		hl			; next char
				djnz	pmLoop		; if were not at the end of a line, print next char
				call	newline		; if we are, print a new line
				ld		b,c			;are we at the end of a block
				djnz	pmNextLine
				ret
pmNextLine:	
				ld		c,b			;copy decremented b back to c
				ld 		a,32		;refill b withj 32
				ld		b,a
				jr		pmLoop		;draw next char


pmChar:		;-- Print map char a
				push	hl
				bit		powerpBit,a
				jr		nz,printPP
				bit		pelletBit,a
				jr		nz,printP
				bit		wallBit,a
				jr		nz,printWall
				bit		sfBit,a
				jr		nz,printSF
				jr	 	printVoid
			
printPP:
				ld		hl,powerPellet
				call	print
				jr		pmCharRet
printP:
				ld		hl,pellet
				call	print
				jr		pmCharRet
printWall:
				ld		hl,wall
				call	print
				jr		pmCharRet
printSF:
				ld		hl,superFruit
				call	print
				jr		pmCharRet
printVoid:
				ld		hl,void
				call	print
				jr		pmCharRet
pmCharRet:	
				pop 	hl
				ret
				
;-------- Path Find Map -------;
;Initi Path Find Map
initPathFind:
				ld		a,32
				ld		b,a			; 32 chars per line
				ld		c,a			; 32 lines per map
				ld		hl,pathFindMap
pfLoop:			ld		(hl),0FFFFH	; set char
				inc		hl			; next char
				djnz	pfLoop		; if were not at the end of a line, print next char
				ld		b,c			;are we at the end of a block
				djnz	pfNextRow
				ret
pfNextRow:	
				ld		c,b			;copy decremented b back to c
				ld 		a,32		;refill b withj 32
				ld		b,a
				jr		pfLoop		;draw next char

;Calculate Map
calculatePathMap:
				LD		A, (pacx)		;Push X to stack
				LD		C,A
				LD		A, (pacy)		;Push Y to stack
				LD		B,A
				ld		HL,0FFFFH		;Push Stack terminator		
				PUSH	HL
				CALL	getAddressPF
				LD		(HL),00H
				PUSH	BC
calculatePathMapLoop:
				POP		BC			;Get node to visit
				LD		B,A			;Check Its not FFFF
				CP		0FFH
				RET		Z			;We only have to check half the byte as its imposable to have a cord more than 20h

printScore:					
				LD		HL, $02
				PUSH	HL
				LD		HL, $23
				PUSH	HL
				CALL	moveCursor
				LD		HL, scoreHUD
				CALL 	print
				LD		HL, (score)
				CALL	HLToDec
				LD		A,LF
				RST     08H
				LD		A,CR
				RST     08H
				RET
			
;------- Libs ------------;
newline:			
				push 	af
				ld		a, CR
				rst 	08H
				ld		a, LF
				rst 	08H
				pop 	af
				ret
			
;move cursor to (sp,sp-2)				
moveCursor:		
				POP		DE
				LD		A,$1B
				RST     08H
				LD		A,'['
				RST     08H
				POP		HL
				CALL	HLToDec
				LD		A,$3B
				RST     08H
				POP		HL
				CALL	HLToDec
				LD		A,'f'
				RST     08H
				PUSH	DE
				RET

;Prints	hl as decimal			
HLToDec:
				PUSH	AF
				PUSH	BC
				CALL	DispHL
				POP		BC
				POP		AF
				RET
DispHL:
				ld		bc,-10000
				call	Num1
				ld		bc,-1000
				call	Num1
				ld		bc,-100
				call	Num1
				ld		c,-10
				call	Num1
				ld		c,-1
Num1:			ld		a,'0'-1
Num2:			inc		a
				add		hl,bc
				jr		c,Num2
				sbc		hl,bc
				RST     08H
				ret
;Print A as HEX				
NumToHex:    	ld 		c, a   		; a = number to convert
            	call 	Num1H
            	RST     08H
            	ld 		a, c
            	call 	Num2H
            	RST     08H
            	ret

Num1H:        	rra
            	rra
            	rra
           		rra
Num2H:        	or 		$F0
            	daa
            	add 	a, $A0
            	adc 	a, $40 		; Ascii hex at this point (0 to F)   
            	ret

;Get ABS of A
absA:
     or a
     ret p
     neg
     ret

;getArAndomA	 
randomA:				
				ld a, 	(seed)
				ld b, 	a 

				rrca ; multiply by 32
				rrca
				rrca
				xor $1f

				add 	a, b
				sbc a, 255 ; carry

				ld (seed), a
				ret

;------- Print string
print:			PUSH 	AF				; Preserve AF				
printLoop:      LD      A,(HL)          ; Get character
                OR      A               ; Is it $00 ?
                JR     	Z,printRet      ; Then RETurn on terminator
                RST     08H             ; Print it
                INC     HL              ; Next Character
                JR      printLoop       ; Continue until $00
				
;delay loop
printRet:		
				POP		AF
				RET
delay:
				NOP
				DEC 	BC
				LD 		A,B
				OR 		C
				RET 	Z
				JR 		delay

;Strings
wall:			.BYTE	1BH,"[34m#",1BH,"[0m",0
powerPellet:	.BYTE	1BH,"[97mo",1BH,"[0m",0
pellet:			.BYTE	1BH,"[37m*",1BH,"[0m",0
superFruit:		.BYTE	1BH,"[31m@",1BH,"[0m",0

scoreHUD:     	.BYTE "Score: ",0

pacman:			.BYTE	1BH,"[93mC",1BH,"[0m",0

redGhost:		.BYTE	1BH,"[91mM",1BH,"[0m",0
greenGhost:		.BYTE	1BH,"[92mM",1BH,"[0m",0
blueGhost:		.BYTE	1BH,"[36mM",1BH,"[0m",0
pinkGhost:		.BYTE	1BH,"[95mM",1BH,"[0m",0


void:			.BYTE	" ",0

cls:      	  	.BYTE 1BH,"[H",1BH,"[2J",0
;-----Path find map
	.ORG 0D000H
pathFindMap:
;----- Map ------		
	.ORG 0E000H
;----Pellet
ww 		.EQU	40H

hp 		.EQU	2CH		;left 	right	pellet
gp		.EQU	23H		;up		down	pellet

lp		.EQU	26H		;down 	left 	pellet
rp		.EQU	2AH		;down 	right	pellet
up		.EQU	25H		;up 	left	pellet
dp		.EQU	29H		;up 	right	pellet

bp		.EQU	2BH		;up		down	right	pellet
cp		.EQU	27H		;up		down	left	pellet
vp		.EQU	2EH		;down	left	right	pellet
kp		.EQU	2DH		;up		left	right	pellet

xp		.EQU	2FH		;all	pellet
;------- No pellet
hn 		.EQU	0CH		;left 	right	pellet
gn		.EQU	03H		;up		down	pellet

ln		.EQU	06H		;down 	left 	pellet
rn		.EQU	0AH		;down 	right	pellet
un		.EQU	05H		;up 	left	pellet
dn		.EQU	09H		;up 	right	pellet

bn		.EQU	0BH		;up		down	right	pellet
cn		.EQU	07H		;up		down	left	pellet
vn		.EQU	0EH		;down	left	right	pellet
kn		.EQU	0DH		;up		left	right	pellet

xn		.EQU	0FH		;all	pellet
;--------Power Pellet
hs 		.EQU	1CH		;left 	right	pellet
gs		.EQU	13H		;up		down	pellet

ls		.EQU	16H		;down 	left 	pellet
rs		.EQU	1AH		;down 	right	pellet
us		.EQU	15H		;up 	left	pellet
ds		.EQU	19H		;up 	right	pellet

bs		.EQU	1BH		;up		down	right	pellet
cs		.EQU	17H		;up		down	left	pellet
vs		.EQU	1EH		;down	left	right	pellet
ks		.EQU	1DH		;up		left	right	pellet

xs		.EQU	1FH		;all	pellet


map:	.BYTE	00,00,ww,ww,ww,ww,ww,ww,ww,ww,ww,ww,ww,ww,ww,ww,ww,ww,ww,ww,ww,ww,ww,ww,ww,ww,ww,ww,ww,ww,00,00
		.BYTE	00,00,ww,rp,hp,hp,hp,hp,vp,hp,hp,hp,hp,hp,lp,ww,ww,rp,hp,hp,hp,hp,hp,vp,hp,hp,hp,hp,lp,ww,00,00
		.BYTE	00,00,ww,gs,ww,ww,ww,ww,gp,ww,ww,ww,ww,ww,gp,ww,ww,gp,ww,ww,ww,ww,ww,gp,ww,ww,ww,ww,gs,ww,00,00
		.BYTE	00,00,ww,gp,ww,ww,ww,ww,gp,ww,ww,ww,ww,ww,gp,ww,ww,gp,ww,ww,ww,ww,ww,gp,ww,ww,ww,ww,gp,ww,00,00
		.BYTE	00,00,ww,bp,hp,hp,hp,hp,xp,hp,hp,vp,hp,hp,kp,hp,hp,kp,hp,hp,vp,hp,hp,xp,hp,hp,hp,hp,cp,ww,00,00
		.BYTE	00,00,ww,gp,ww,ww,ww,ww,gp,ww,ww,gp,ww,ww,ww,ww,ww,ww,ww,ww,gp,ww,ww,gp,ww,ww,ww,ww,gp,ww,00,00
		.BYTE	00,00,ww,dp,hp,hp,hp,hp,cp,ww,ww,dp,hp,hp,lp,ww,ww,rp,hp,hp,up,ww,ww,bp,hp,hp,hp,hp,up,ww,00,00
		.BYTE	00,00,ww,ww,ww,ww,ww,ww,gp,ww,ww,ww,ww,ww,gn,ww,ww,gn,ww,ww,ww,ww,ww,gp,ww,ww,ww,ww,ww,ww,00,00
		.BYTE	00,00,00,00,00,00,00,ww,gp,ww,ww,rn,hn,hn,kn,hn,hn,kn,hn,hn,ln,ww,ww,gp,ww,00,00,00,00,00,00,00
		.BYTE	00,00,00,00,00,00,00,ww,gp,ww,ww,gn,ww,ww,ww,00,00,ww,ww,ww,gn,ww,ww,gp,ww,00,00,00,00,00,00,00
		.BYTE	ww,ww,ww,ww,ww,ww,ww,ww,gp,ww,ww,gn,ww,00,00,00,00,00,00,ww,gn,ww,ww,gp,ww,ww,ww,ww,ww,ww,ww,ww
		.BYTE	hn,hn,hn,hn,hn,hn,hn,hn,xp,hn,hn,cn,ww,00,00,00,00,00,00,ww,bn,hn,hn,xp,hn,hn,hn,hn,hn,hn,hn,hn
		.BYTE	ww,ww,ww,ww,ww,ww,ww,ww,gp,ww,ww,gn,ww,00,00,00,00,00,00,ww,gn,ww,ww,gp,ww,ww,ww,ww,ww,ww,ww,ww
		.BYTE	00,00,00,00,00,00,00,ww,gp,ww,ww,gn,ww,ww,ww,ww,ww,ww,ww,ww,gn,ww,ww,gp,ww,00,00,00,00,00,00,00
		.BYTE	00,00,00,00,00,00,00,ww,gp,ww,ww,bn,hn,hn,hn,hn,hn,hn,hn,hn,cn,ww,ww,gp,ww,00,00,00,00,00,00,00
		.BYTE	00,00,ww,ww,ww,ww,ww,ww,gp,ww,ww,gn,ww,ww,ww,ww,ww,ww,ww,ww,gn,ww,ww,gp,ww,ww,ww,ww,ww,ww,00,00
		.BYTE	00,00,ww,rp,hp,hp,hp,hp,xp,hp,hp,kp,hp,hp,lp,ww,ww,rp,hp,hp,kp,hp,hp,xp,hp,hp,hp,hp,lp,ww,00,00
		.BYTE	00,00,ww,gp,ww,ww,ww,ww,gp,ww,ww,ww,ww,ww,gp,ww,ww,gp,ww,ww,ww,ww,ww,gp,ww,ww,ww,ww,gp,ww,00,00
		.BYTE	00,00,ww,ds,hp,lp,ww,ww,bp,hp,hp,vp,hp,hp,kp,hp,hp,kp,hp,hp,vp,hp,hp,cp,ww,ww,rp,hp,us,ww,00,00
		.BYTE	00,00,ww,ww,ww,gp,ww,ww,gp,ww,ww,gp,ww,ww,ww,ww,ww,ww,ww,ww,gp,ww,ww,gp,ww,ww,gp,ww,ww,ww,00,00
		.BYTE	00,00,ww,rp,hp,kp,hp,hp,up,ww,ww,dp,hp,hp,lp,ww,ww,rp,hp,hp,up,ww,ww,dp,hp,hp,kp,hp,lp,ww,00,00
		.BYTE	00,00,ww,gp,ww,ww,ww,ww,ww,ww,ww,ww,ww,ww,gp,ww,ww,gp,ww,ww,ww,ww,ww,ww,ww,ww,ww,ww,gp,ww,00,00
		.BYTE	00,00,ww,dp,hp,hp,hp,hp,hp,hp,hp,hp,hp,hp,kp,hp,hp,kp,hp,hp,hp,hp,hp,hp,hp,hp,hp,hp,up,ww,00,00
		.BYTE	00,00,ww,ww,ww,ww,ww,ww,ww,ww,ww,ww,ww,ww,ww,ww,ww,ww,ww,ww,ww,ww,ww,ww,ww,ww,ww,ww,ww,ww,00,00
		.BYTE	00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00
		.BYTE	00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00
		.BYTE	00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00
		.BYTE	00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00
		.BYTE	00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00
		.BYTE	00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00
		.BYTE	00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00
		.BYTE	00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00