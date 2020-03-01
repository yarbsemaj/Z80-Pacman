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