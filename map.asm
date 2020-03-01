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