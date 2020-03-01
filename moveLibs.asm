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