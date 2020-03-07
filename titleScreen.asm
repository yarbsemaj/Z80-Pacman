displayTitleScreen:
                LD      BC ,0306H
			    LD		DE ,1614H 
			    CALL	DrawBox
                LD      BC ,0408H
                LD      HL,logo
                CALL    printAtPos
                LD      BC ,0908H
                LD      HL,info
                CALL    printAtPos
                LD      BC ,0D08H
                LD      HL,message
                CALL    printAtPos
                LD      BC ,0F0AH
                LD      HL,startGameMessage
                CALL    printAtPos
                LD      BC ,1008H
                LD      HL,exitMessage
                CALL    printAtPos
titleScreenWaitForInput:
                RST		10H
                CP      '1'
                JP      Z,startGame
                CP      '2'
                JP      Z,quit                     
                JP      titleScreenWaitForInput

;font graceful
logo:
                    .BYTE   1BH,"[91m ____ ",1BH,"[96m _  _   ",1BH,"[33m___ ",0,1
                    .BYTE   1BH,"[91m(  _ \",1BH,"[96m/ )( \ ",1BH,"[33m/ __)",0,1
                    .BYTE   1BH,"[91m ) __/",1BH,"[96m) \/ (",1BH,"[33m( (__ ",0,1
                    .BYTE   1BH,"[91m(__)  ",1BH,"[96m\____/ ",1BH,"[33m\___)", 1BH,"[0m",0,0

info:               .BYTE  "by James Bray 2020",0,0

message:           .BYTE   "Press key to start",0,0
startGameMessage:  .BYTE   "(1) Start Game",0,0
exitMessage:       .BYTE   "(2) Exit to Prompt",0,0