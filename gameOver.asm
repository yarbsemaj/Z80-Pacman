displayGameOver:
                LD      BC ,0604H
			    LD		DE ,1A0AH 
			    CALL	DrawBox
                LD      BC ,0705H
                LD      HL,deathMessage1
                CALL    printAtPos
                LD      BC ,0D05H
                LD      HL,deathMessage2
                CALL    printAtPos
gameOverwaitForInput:
                RST		10H
                CP      ' '
                JP      Z,gameTop                    
                JP      gameOverwaitForInput

deathMessage1:
                    .BYTE    1BH,"[91m __          _          ",0,1
                    .BYTE            "/__ _ __  _ / \    _  __",0,1
                    .BYTE            "\_|(_||||(/_\_/\_/(/_ | ",1BH,"[0m",0,0

deathMessage2:      .BYTE    "Press Space to continue!",0,0