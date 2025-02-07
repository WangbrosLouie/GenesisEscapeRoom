ReadIn6	move.b	#$00,c1		;for needless 6 button "support"
	move.l	(sp),(sp)	;double nop apparently
	move.b	c1,d7
	move.b	#$40,c1
	rol.w	#8,d7		;equal in cycles apparently
	move.b	c1,d7
	move.l	(sp),(sp)
	move.b	#$00,c1
	move.l	(sp),(sp)
	move.b	#$40,c1
	move.l	(sp),(sp)
	move.b	#$00,c1
	move.l	(sp),(sp)
	move.b	#$40,c1
	;do some 6 button stuff here i think
	swap	d7
	move.b	#$00,c2
	move.b	c2,d7
	move.b	#$40,c2
	rol.w	#8,d7
	move.b	c2,d7
	rts
P1Ctrl	move.b	#$0,cc1		;only gonna be usin this one anyway methinks
	move.b	#$0,c1
	move.w	$FF000A,$FF0010
	move.b	c1,d1
	move.b	#$40,cc1
	move.b	#$40,c1
	rol.w	#8,d1
	move.b	c1,d1
	move.w	d1,$FF000A
	rts
P2Ctrl	move.b	#$0,cc2
	move.l	(sp),(sp)
	move.b	c2,d7
	rol.w	#8,d7
	move.b	#$40,cc2
	move.b	c2,d7
	move.w	d1,$FF000C
	rts
WaitForVee
	move.w	vc,d0
	andi.b	#8,d0
	bne	WaitForVee
	rts
DoneWithVee
	move.w	vc,d0
	andi.b	#8,d0
	beq	DoneWithVee
	rts
DMA2VM ;Registers: a0: Source d0: Length d1: Destination Note: Call in vblank only as dma is not fast enough for hblank
	move.l	#vc,a6 ;move vdp control address
	move.w	#$8154,(a6) ;enable dma
	move.w	#$8F02,(a6) ;bias = 2
	move.w	#$9300,d2 ;prep for register write
	move.b	d0,d2 ;register data
	move.w	d2,(a6) ;reg 19
	add.w	#$100,d2
	ror.w	#$8,d0
	move.b	d0,d2
	move.w	d2,(a6) ;reg 20
	add.w	#$100,d2
	move.l	a0,d0
	lsr.l	#1,d0
	move.b	d0,d2
	move.w	d2,(a6) ;reg 21
	add.w	#$100,d2
	rol.w	#$8,d0
	move.b	d0,d2
	move.w	d2,(a6) ;reg 22
	add.w	#$100,d2
	swap	d0
	bclr	#7,d0
	move.b	d0,d2
	move.w	d2,(a6) ;reg 23
	movea.l	#$FFFC00,a0 ;start of stack: temporary values only address
	rol.l	#2,d1 ;prep dma destination packets
	ror.w	#2,d1
	bset	#14,d1
	swap	d1
	bset	#7,d1
	move.l	d1,(a0) ;move dest. address to ram to avoid dma bug
	move.w	(a0)+,(a6) ;write address
	move.w	(a0)+,(a6) ;dma starts here
	move.w	vc,d0
	andi.b	#2,d0
	bne	*-$7
	move.w	#$8144,(a6) ;set dma "disenable"
	rts
DMAFILL ;Registers: d0: Source d1: Destination d2: Length in bytes
	movea.l	#vc,a0
	move.w	#$8114,(a0) ;set display off and dma on
	move.w	#$8F01,(a0) ;set bias = 1
	rol.l	#8,d2 ;prep dma length packets
	ror.w	#8,d2
	add.l	#$94009300,d2
	move.w	d2,(a0)
	swap	d2
	move.w	d2,(a0)
	move.w	#$9780,(a0) ;set dma fill mode
	rol.l	#2,d1 ;prep dma destination packets
	ror.w	#2,d1
	bset	#14,d1
	swap	d1
	bset	#7,d1
	move.l	d1,(a0)
	suba.w	#$4,a0
	;movea.l	#$FFFC00,a0 ;start of stack: temporary values only address
	move.w	d0,-(sp) ;move source address to ram to avoid dma bug
	move.w	(sp)+,(a0) ;write address; dma starts here
	move.w	vc,d0
	andi.b	#2,d0
	bne	*-$A
	move.w	#$8104,(a6) ;set dma "disenable"
	rts
new_Obj;a0: pointy pointer to code
	;destroys d0,d1,d2,a1
	;move.w	(-4,a0),d0
	move.l	#$FF0000,a1
	move.l	#$FF0000,d0
	move.w	(-8,a0),d1
	;move.l	a5,(a1)+
	;move.l	a6,(a1)
	;subq.w	#4,a1
new_Obj1
	moveq	#0,d2
	move.w	d1,d2
new_Obj2
	move.w	(8,a1),d0;find next memory thing
	move.l	d0,a1
	cmp.l	#'MEOW',(a1)
	beq	new_Obj1
	dbra	d2,new_Obj2
	move.l	#'MEOW',(a1)+
	move.l	a0,(a1)+
	move.w	d1,(a1)+
	move.w	(-10,a0),(a1)+
	rts
NoCheat	moveq	#0,d1		;NoCheat anti cheating thingy
	move.l	#$3FFF,d0	;like im ever gonna use it tho
	move.l	#$FF0000,a0	;to patch this simply use a cheat
NoChea1	move.l	(a0),d2		;device to turn the moveq to rts
	move.l	d1,(a0)
	tst.l	(a0)
	bne	Cheater		;pumpkin eater detected
	move.l	d2,(a0)+	;whole thing takes 1114092 cycles
	dbra	d0,NoChea1	;or around 1/7 of a second
	rts			;so only call when acceptable
Cheater	illegal			;cheaters get game crashes
