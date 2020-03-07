pathFindDepth   .EQU	30H

;-------- Map -------;
;InitiMap
initMap:
				LD		BC,400H
				LD		HL,map
				LD		DE,liveMap
				LDIR
				RET

;------- Get Map Data ----;
; C - X
; B	- Y
getMapAddress:
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
				pop		bc
				ret

;--------Check map for pellets ------;
checkNextLevel:
				CALL	checkMap
				LD		A,E
				OR		A
				RET		NZ
				LD		A,D
				OR		A
				RET		NZ

				LD		HL,(level)
				INC		HL
				LD		(level),HL
				CALL	countdown
				CALL	initMap
				CALL	initGhost
				CALL	resetPacman
				LD		HL, home		;Go home
				CALL	print
				CALL 	printMap
				ret

checkMap:
				ld		a,32
				ld		b,a			; 32 chars per line
				ld		c,a			; 32 lines per map
				ld		hl,liveMap
				ld		de,0
checkMapLoop:	ld		a,(hl)		; get char
				call	checkMapChar; check the char
				inc		hl			; next char
				djnz	checkMapLoop; if were not at the end of a line, print next char
				ld		b,c			;are we at the end of a block
				djnz	checkMapNextLine
				ret
checkMapNextLine:	
				ld		c,b			;copy decremented b back to c
				ld 		a,32		;refill b withj 32
				ld		b,a
				jr		checkMapLoop;draw next char

checkMapChar:
				bit		pelletBit,a
				CALL	NZ,incrementDE
				bit		powerpBit,a
				CALL	NZ,incrementDE
				RET
incrementDE:
				INC		DE
				RET

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
			INC		B
			CALL	moveCursor
			POP 	BC
			CALL	getMapAddress
			LD		A,(HL)
			CALL	pmChar
			RET

printMap:
				ld		a,32
				ld		b,a			; 32 chars per line
				ld		c,a			; 32 lines per map
				ld		hl,liveMap
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
initpPFLoop:	ld		D,0FFH		; set char
				LD		(HL),D
				inc		hl			; next char
				djnz	initpPFLoop		; if were not at the end of a line, print next char
				ld		b,c			;are we at the end of a block
				djnz	pfNextRow
				ret
pfNextRow:	
				ld		c,b			;copy decremented b back to c
				ld 		a,32		;refill b withj 32
				ld		b,a
				jp		initpPFLoop		;draw next char

;Calculate Map
calculatePathMap:
				ld		BC,0FFFFH		;Push Stack terminator		
				PUSH	BC
				LD		A, (pacx)		;Push X to stack
				LD		C,A
				LD		A, (pacy)		;Push Y to stack
				LD		B,A
				CALL	getAddressPF
				LD		(HL),00H
				PUSH	BC
calculatePathMapLoop:
				POP		BC			;Get node to visit
				LD		A,B			;Check Its not FFFF
				OR		A
				CP		0FFH
				RET		Z			;We only have to check half the byte as its imposable to have a cord more than 20h
				LD		(originalBC),BC
				CALL	getAddressPF
				LD		A,(HL)
				INC		A
                CP      pathFindDepth
				JP 		Z,calculatePathMapLoop	;Skip if wer getting too long
				LD		E,A			;Keep the distance were working with safe
				CALL	getMapAddress
				LD		D,(HL)
				LD		A,	'W'			;check up
				CALL	isMoveValid
				CALL	NZ,calculateMapU
				LD		A,	'S'			;down
				CALL	isMoveValid
				CALL	NZ,calculateMapD
				LD		A,	'A'			;left
				CALL	isMoveValid
				CALL	NZ,calculateMapL
				LD		A,	'D'			;right
				CALL	isMoveValid
				CALL	NZ,calculateMapR
				JP		calculatePathMapLoop
				
calculateMapU:	
				LD		BC,(originalBC)			;We want to preserve the OG BC Through this process so it can be used again in sub directions		
				LD		A, B				;Make modifications to corod
				DEC		A
				AND		00011111B			;Mask for looping
				LD		B,A
				JP		calculateMapCell
calculateMapD:	
				LD		BC,(originalBC)	
				LD		A, B
				INC		A
				AND		00011111B
				LD		B,A
				JP		calculateMapCell
calculateMapL:	
				LD		BC,(originalBC)
				LD		A, C
				DEC		A
				AND		00011111B
				LD		C,A
				JP		calculateMapCell
calculateMapR:
				LD		BC,(originalBC)
				LD		A, C
				INC		A
				AND		00011111B
				LD		C,A
				JP		calculateMapCell

calculateMapCell:
				CALL	getAddressPF
				LD		A,(HL)

				CP		E			;Compare current data (A) with E (the path were looking at)
				RET		C			;If carry is set (A < E)(whats there already < our path) then this route is a dud
				RET		Z			;If its equal we dont want to continue as we alreay have an equally fast route
				LD		(HL),E
				POP		HL			;We need the return adress on the top of the stack
				PUSH	BC			;Push Cell so it can be visited
				PUSH	HL
				RET

printPFMap:
                LD		C, $01
				LD		B, $1A
				CALL	moveCursor
				ld		a,32
				ld		b,a			; 32 chars per line
                ld		a,$1A
				ld		c,a			; 32 lines per map
				ld		hl,pathFindMap
pmPFLoop:		ld		a,(hl)		; get char
                cp      0FFH
                JP      Z,pmPFSkip
				call	NumToHex	; decode what to print
pmPFAfterSkip:  ld      a,' '
                rst     08H
				inc		hl			; next char
				djnz	pmPFLoop		; if were not at the end of a line, print next char
				call	newline		; if we are, print a new line
				ld		b,c			;are we at the end of a block
				djnz	pmPFNextLine
				ret
pmPFNextLine:	
				ld		c,b			;copy decremented b back to c
				ld 		a,32		;refill b withj 32
				ld		b,a
				jr		pmPFLoop	;draw next char
pmPFSkip:       
                ld      a,' '
                rst     08H
                ld      a,' '
                rst     08H
                JP      pmPFAfterSkip