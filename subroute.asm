InputRead
	move.b #$00,c1
	move.b c1,d7
	rol.w #8,d7
	move.b #$40,c1
	move.b c1,d7
	swap d7
	move.b #$00,c2
	move.b c2,d7
	rol.w #8,d7
	move.b #$40,c2
	move.b c2,d7
	rts
P1Ctrl
	move.b #$00,c1
	nop
	nop
	move.b c1,d7
	move.b #$40,c1
	rol.w #8,d7
	move.b c1,d7
	rts
P2Ctrl
	move.b #$00,c2
	move.b c2,d7
	rol.w #8,d7
	move.b #$40,c1
	move.b c2,d7
	rts
WaitForVee
	move.w vc,d0
	andi.b #8,d0
	bne WaitForVee
	rts
DoneWithVee
	move.w vc,d0
	andi.b #8,d0
	beq DoneWithVee
	rts
DMA2VRAM ;Registers: a0: Source d0: Length d1: Destination Note: Call in vblank only as dma is not fast enough for hblank
	move.l #vc,a6 ;move vdp control address
	move.w #$8114,(a6) ;enable dma
	move.w #$8F02,(a6) ;bias = 2
	move.w #$9300,d2 ;prep for register write
	move.b d0,d2 ;register data
	move.w d2,(a6) ;reg 19
	add.w #$100,d2
	ror.w #$8,d0
	move.b d0,d2
	move.w d2,(a6) ;reg 20
	add.w #$100,d2
	move.l a0,d0
	lsr.l #1,d0
	move.b d0,d2
	move.w d2,(a6) ;reg 21
	add.w #$100,d2
	rol.w #$8,d0
	move.b d0,d2
	move.w d2,(a6) ;reg 22
	add.w #$100,d2
	swap d0
	bclr #7,d0
	move.b d0,d2
	move.w d2,(a6) ;reg 23
	movea.l #$FFFC00,a0 ;start of stack: temporary values only address
	rol.l #2,d1 ;prep dma destination packets
	ror.w #2,d1
	bset #14,d1
	swap d1
	bset #7,d1
	move.l d1,(a0) ;move dest. address to ram to avoid dma bug
	move.l (a0),(a6) ;write address; dma starts here
;	move.w	vc,d0
;	andi.b	#2,d0
;	bne		*-$7
	move.w #$8104,(a6) ;set dma "disenable"
	rts
DMA2FILL ;Registers: d0: Source d1: Destination d2: Length in bytes
	movea.l #vc,a6
	move.w #$8114,(a6) ;set display off and dma on
	move.w #$8F01,(a6) ;set bias = 1
	rol.l #8,d2 ;prep dma length packets
	ror.w #8,d2
	add.l #$94009300,d2
	move.w d2,(a6)
	swap d2
	move.w d2,(a6)
	move.w #$9780,(a6) ;set dma fill mode
	rol.l #2,d1 ;prep dma destination packets
	ror.w #2,d1
	bset #14,d1
	swap d1
	bset #7,d1
	move.l d1,(a6)
	suba.w #$4,a6
	movea.l #$FFFC00,a0 ;start of stack: temporary values only address
	move.w d0,(a0) ;move source address to ram to avoid dma bug
	move.w (a0),(a6) ;write address; dma starts here
	move.w vc,d0
	andi.b #2,d0
	bne *-$A
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
