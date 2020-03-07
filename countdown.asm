countdown:
            LD      BC ,0305H
			LD		DE ,1812H 
			CALL	DrawBox
            LD      BC ,0407H
            LD      HL,number3
            CALL    printAtPos
            LD      BC, 0FFFFH
            CALL    delay
            CALL    delay
            CALL    delay
            CALL    delay
            LD      BC ,0407H
            LD      HL,number2
            CALL    printAtPos
            LD      BC, 0FFFFH
            CALL    delay
            CALL    delay
            CALL    delay
            CALL    delay
            LD      HL,number1
            LD      BC ,0407H
            CALL    printAtPos
            LD      BC, 0FFFFH
            CALL    delay
            CALL    delay
            CALL    delay
            CALL    delay
            RET

;Font 'doh'
number1:            .BYTE   "      1111111       ",0,1
                    .BYTE   "     1::::::1       ",0,1
                    .BYTE   "    1:::::::1       ",0,1
                    .BYTE   "    111:::::1       ",0,1
                    .BYTE   "       1::::1       ",0,1
                    .BYTE   "       1::::1       ",0,1
                    .BYTE   "       1::::1       ",0,1
                    .BYTE   "       1::::l       ",0,1
                    .BYTE   "       1::::l       ",0,1
                    .BYTE   "       1::::l       ",0,1
                    .BYTE   "       1::::l       ",0,1
                    .BYTE   "       1::::l       ",0,1
                    .BYTE   "    111::::::111    ",0,1
                    .BYTE   "    1::::::::::1    ",0,1
                    .BYTE   "    1::::::::::1    ",0,1
                    .BYTE   "    111111111111    ",0,0

number2:            .BYTE   " 222222222222222    ",0,1
                    .BYTE   "2:::::::::::::::22  ",0,1
                    .BYTE   "2::::::222222:::::2 ",0,1
                    .BYTE   "2222222     2:::::2 ",0,1
                    .BYTE   "            2:::::2 ",0,1
                    .BYTE   "            2:::::2 ",0,1
                    .BYTE   "         2222::::2  ",0,1
                    .BYTE   "    22222::::::22   ",0,1
                    .BYTE   "  22::::::::222     ",0,1
                    .BYTE   " 2:::::22222        ",0,1
                    .BYTE   "2:::::2             ",0,1
                    .BYTE   "2:::::2             ",0,1
                    .BYTE   "2:::::2       222222",0,1
                    .BYTE   "2::::::2222222:::::2",0,1
                    .BYTE   "2::::::::::::::::::2",0,1
                    .BYTE   "22222222222222222222",0,0

number3:            .BYTE   "  333333333333333   ",0,1
                    .BYTE   " 3:::::::::::::::33 ",0,1
                    .BYTE   " 3::::::33333::::::3",0,1
                    .BYTE   " 3333333     3:::::3",0,1
                    .BYTE   "             3:::::3",0,1
                    .BYTE   "             3:::::3",0,1
                    .BYTE   "     33333333:::::3 ",0,1
                    .BYTE   "     3:::::::::::3  ",0,1
                    .BYTE   "     33333333:::::3 ",0,1
                    .BYTE   "             3:::::3",0,1
                    .BYTE   "             3:::::3",0,1
                    .BYTE   "             3:::::3",0,1
                    .BYTE   " 3333333     3:::::3",0,1
                    .BYTE   " 3::::::33333::::::3",0,1
                    .BYTE   " 3:::::::::::::::33 ",0,1
                    .BYTE   "  333333333333333   ",0,0