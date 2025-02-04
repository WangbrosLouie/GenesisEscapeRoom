vector:	dc.l $FFFFFE ;$00 SP Initial Value
	dc.l pstart ;$04 PC Initial Value
	dc.l afault ;$08 Access Fault
	dc.l aerror ;$0C Address Error
	dc.l illins ;$10 Illegal Instruction
	dc.l intdb0 ;$14 Integer Div by 0
	dc.l chkins ;$18 CHK, CHK2 Instruction
	dc.l ftrapv ;$1C FTRAP, TRAP, TRAPV Instructions
	dc.l privio ;$20 Priveledge Violation
	dc.l trace ;$24 Trace
	dc.l ln1010 ;$28 Line 1010($A) Emulator
	dc.l ln1111 ;$2C Line 1111($F) Emulator
	dc.l return ;$30 Reserved
	dc.l copvio ;$34 Coprocessor Violation
	dc.l format ;$38 Format Error
	dc.l uninit ;$3C Uninitialized Interrupt
	dc.l return ;$40 Reserved
	dc.l return ;$44 Reserved
	dc.l return ;$48 Reserved
	dc.l return ;$4C Reserved
	dc.l return ;$50 Reserved
	dc.l return ;$54 Reserved
	dc.l return ;$58 Reserved
	dc.l return ;$5C Reserved
	dc.l inter0 ;$60 Interrupt #0 (Unused)
	dc.l inter1 ;$64 Interrupt #1
	dc.l extint ;$68 Interrupt #2
	dc.l inter3 ;$6C Interrupt #3
	dc.l Hblank ;$70 Interrupt #4 (H-int)
	dc.l inter5 ;$74 Interrupt #5
	dc.l Vblank ;$78 Interrupt #6 (V-int)
	dc.l inter7 ;$7C Interrupt #7
	dc.l trap00 ;$80 TRAP #0 D 15 Instruction Vectors
	dc.l trap00 ;$84 TRAP #0 D 15 Instruction Vectors
	dc.l trap00 ;$88 TRAP #0 D 15 Instruction Vectors
	dc.l trap00 ;$8C TRAP #0 D 15 Instruction Vectors
	dc.l trap00 ;$90 TRAP #0 D 15 Instruction Vectors
	dc.l trap00 ;$94 TRAP #0 D 15 Instruction Vectors
	dc.l trap00 ;$98 TRAP #0 D 15 Instruction Vectors
	dc.l trap00 ;$9C TRAP #0 D 15 Instruction Vectors
	dc.l trap00 ;$A0 TRAP #0 D 15 Instruction Vectors
	dc.l trap00 ;$A4 TRAP #0 D 15 Instruction Vectors
	dc.l trap00 ;$A8 TRAP #0 D 15 Instruction Vectors
	dc.l trap00 ;$AC TRAP #0 D 15 Instruction Vectors
	dc.l trap00 ;$B0 TRAP #0 D 15 Instruction Vectors
	dc.l trap00 ;$B4 TRAP #0 D 15 Instruction Vectors
	dc.l trap00 ;$B8 TRAP #0 D 15 Instruction Vectors
	dc.l trap00 ;$BC TRAP #0 D 15 Instruction Vectors
	dc.l return ;$C0 FP Branch or Set on Unordered Condition
	dc.l return ;$C4 FP Inexact Result
	dc.l return ;$C8 FP Div by 0
	dc.l return ;$CC FP Underflow
	dc.l return ;$D0 FP Operand Error
	dc.l return ;$D4 FP Overflow
	dc.l return ;$D8 FP Signaling NAN
	dc.l return ;$DC FP Unimplenented Data Type
	dc.l return ;$E0 MMU Configuration Error
	dc.l return ;$E4 MMU Illegal Operation Error
	dc.l return ;$E8 MMU Accesss Level Violation
	dc.l return ;$EC Reserved
	dc.l return ;$F0 Reserved
	dc.l return ;$F4 Reserved
	dc.l return ;$F8 Reserved
	dc.l return ;$FC Reserved
header:	dc.b	"SEGA GENESIS    "
	dc.b	"(C)LOUW 2025.JAN"
	dc.b	"出来ってば逃げる…                     "
	dc.b	"Escape me if you can...                         "
	dc.b	"GM 42042069-69"
	dc.b	"69"
	dc.b	"J               "
	dc.l	$000000
	dc.l	$07FFFF
	dc.l	$FF0000
	dc.l	$FFFFFF
	dc.b	"            "
	dc.b	"            "
	dc.b	"                                        "
	dc.b	"JUE"
	dc.b	"             "
c1 = $A10003
c2 = $A10005
vc = $C00004
vd = $C00000
vrw = $40000000
crw = $C0000000
vsw = $40000010
vrr = $0
crr = $20
vsr = $10
sca = $8000 ;Scroll A
scb = $A000 ;Scroll B
scw = $C000 ;Window
sch = $C800 ;H Scroll
sat = $CC00 ;Sprite Attrib. Table

;quick note for me so that my code aint as unreadable as my java
;for labels (like pstart and VDP which is quite terribly named) i gotta keep them under 8 characters.
;that means max of 7 characters per label. and no blank labels cause thats just nonsensical.
;the instructions are gonna be a nightmare to indent cause the indent defaults at 4
;meaning that mnemonics that take only 3 characters like bra or exg must be double indented.
;even more nightmarish are the operands which can be as little as one character to 20 (at least the ones i might use).
;but the comments i dont care much about as long as all of them in between 2 labels are the same indent level
;indents are at 8 cause i cant configure them in nano i think and also windows 11 notepad
;and thats all i think
;my code is gonna look so old fashioned and retro

pstart	cmpi.l	#'MRAU',$FF0004	;check if soft or hard reset
	beq	InitM			;if it is then skip init
	move.b	$A10001,d0		;do the tmss thing
	andi.b	#$0F,d0
	beq VDP
	move.l	#'SEGA',$A14000
VDP	lea	VDPStuff,a1		;load them vdp registers
	moveq	#$18,d0		;i would make this into a
	moveq	#0,d1		;subroutine but im too lazy rn
	move.w	#$8000,d1
SetVDP	move.b	(a1)+,d1
	move.w	d1,vc
	addi.w	#$100,d1
	dbra	d0,SetVDP
SetIO	move.b	#0,$A10009	;make them controllers readable
	move.b	#0,$A1000B
	move.b	#0,$A1000D
	move.l	#$FF0000,d0
	movea.l	d0,a0
	moveq	#0,d0
	move.l	d0,(a0)
	movem.l	(a0),d1-d7/a1-a6
	move.w	#$2700,sr
InitM	moveq	#0,d1		;Init Memory
	move.l	#$3FFF,d0
	move.l	#$FF0000,a0
InitM1	move.l	d1,(a0)+	;this is what happens when 7 char limit
	dbra	d0,InitM1
InitVM	move.l	#$FF0000,d0
	moveq	#0,d1
	move.l	#$FFFF,d2
	;jsr	DMA2FILL ;gonna debug this later
	movea.l	#vc,a0		;Init Video Memory
	move.l	#crw,(a0)
	suba.w	a0,a0
	move.w	#$0EC2,(a0)
	move.l	#'MRAU',$FF0004	;its meowin finished initializing
InitG	lea	mousepointer,a0	;initialize game
	moveq	#15,d0
	bsr	LoadCM
	moveq	#1,d1		;initialize of the object of the mouse
	bra	mewo2
mewo	moveq	#0,d0		;make some objects
	move.l	#'MEOW',(a0)+
	move.l	#testobj,(a0)+
	move.w	d0,(a0)+
	move.l	#$F00,(a0)+
	move.l	d0,(a0)+
	dbra	d1,mewo
mewo2	lea	testobj,a0
	jsr	newObj
looop	jsr	WaitForVee	;process the objects and wait for vsync
	move.l	#$FF0000,a5
lookobj	movea.l	a5,a6		;move current object to last object
	move.l	a5,d0		;because the stupid address is sign extended on a registers
	move.w	(8,a6),d0	;get new object
	move.l	d0,a5
	cmp.l	#'MEOW',(a5)	;is it an object?
	bne	doneobj		;extremely rudimentary error handler/end of loop
	movea.l	(4,a5),a0
	jsr	(a0)		;do the object subroutine
	bra	lookobj
doneobj	bsr	DoneWithVee		;done with processing the objects
	bra	looop
	dc.w	%0000000000000000	;object stuff pay it no mind
	dc.w	$1
testobj	add.w	#14,a5		;seizure inducing background flash goooo-
	move.w	#$8700,d0
	move.b	(a5),d0
	add.b	#1,d0
	move.b	d0,(a5)
	move.l	#vc,a0
	move.w	d0,(a0)
	sub.w	#14,a5
	rts
	dc.w	%0000000000000000
	dc.w	$2
button	jsr	P1Ctrl	;do the rest later cause im not gettin insomnia today

	rts
;the variables are one byte which is which colour in the palette to swap to and a one bit debounce.
;the code checks if the a button is pushed, then if not debounced, then if the pointer is in range.
;if all checks pass then the colour changes and the debounce is set.
;if the a button is released and it is debounced then the debounce is cleared.
return	bra	*-2	;generic return
afault	bra	*-2
aerror	bra	*-2
illins	bra	*-2
intdb0	bra	*-2	;$14 Integer Div by 0
chkins	bra	*-2	;$18 CHK, CHK2 Instruction
ftrapv	bra	*-2	;$1C FTRAP, TRAP, TRAPV Instructions
privio	bra	*-2	;$20 Priveledge Violation
trace	bra	*-2	;$24 Trace
ln1010	bra	*-2	;$28 Line 1010($A) Emulator
ln1111	bra	*-2	;$2C Line 1111($F) Emulator
copvio	bra	*-2	;$34 Coprocessor Violation
format	bra	*-2	;$38 Format Error
uninit	bra	*-2	;$3C Uninitialized Interrupt
Hblank	rts		;Horizontal Interrupt
Vblank	rts		;Vertical Interrupt
inter0	bra	*-2	;$60 Interrupt #0 (Unused)
inter1	bra	*-2	;$64 Interrupt #1
extint	bra	*-2	;$68 Interrupt #2
inter3	bra	*-2	;$6C Interrupt #3
inter5	bra	*-2	;$74 Interrupt #5
inter7	bra	*-2	;$7C Interrupt #7
trap00	bra	*-2	;$80 TRAP #0 D 15 Instruction Vectors
LoadCM	;im gonna write a dma version of this maybe
;a0 = location of colours
;d0 = amount of colours - 1
	movea.l	#vc,a1
	move.l	#$8F02,(a1)
	move.l	vrw,(a1)
	suba.w	a0,a0
	moveq	#15,d0
LoadCM1	move.l	(a0)+,(a1)
	dbra	d0,LoadCM1
	rts
newObj	;a0 = address of object subroutine
	;destroys d0 d1 a1 a2
	;wont work for objects with 0 variables (which at that point what does the object even do)
	;you can just have a 1 byte dummy variable as a workaround for now but it aint mem efficient
	moveq	#0,d0
	move.w	(-2,a0),d0
	movea.l	#$FF007E,a1
newObj1	move.l	d0,d1
	addq.w	#1,d1
	divu.w	#2,d1
	bclr.l	#16,d1
	addq.w	#7,d1
	addq.w	#2,a1
newObj2	cmp.l	#'MEOW',(a1)	;check for existance of an object
	beq	newObj1
	move.w	#0,(a1)+		;cause if the memory might be used later why not clear it now
	dbra	d1,newObj2		;idk what to do if this search wraps around into the forbidden territory
	move.l	#$FF0000,a2
	tst.w	(8,a2)
	beq newObj4
newObj3	tst.w	(8,a2)			;go look for the last object in the daisy chain
	bne newObj3
newObj4	sub.w	d0,a1			;move the register to start of vars
	sub.w	#$14,a1			;move the register to start of object
	exg	d0,a1
	bclr	#0,d0
	exg	d0,a1
	move.w	a1,(8,a2)
	move.l	#'MEOW',(a1)+	;initialize initialize initialize
	move.l	a0,(a1)+
	move.w	#0,(a1)+
	subq.w	#1,d0
	move.w	d0,(a1)+
	move.w	(-4,a0),(a1)+
	rts	;i retract my previous statement about not getting insomnia coding this
VDPStuff:
	dc.b	%00000100;0 Mode 1
	dc.b	%01000100;1 Mode 2
	dc.b	%00100000;2 Scroll A
	dc.b	%00110000;3 Window
	dc.b	%00000101;4 Scroll B
	dc.b	%01100110;5 Sprite Attrib.
	dc.b	%00000000;6 Unused
	dc.b	%00000000;7 BG Colo(u)r
	dc.b	%00000000;8 Unused
	dc.b	%00000000;9 Unused
	dc.b	%00000000;10 Horizontal Interrupt Timer
	dc.b	%00000000;11 Mode 3
	dc.b	%00000000;12 Mode 4
	dc.b	%00110010;13 H Scroll
	dc.b	%00000000;14 Unused
	dc.b	%00000010;15 Auto Increase VRAM Address
	dc.b	%00000000;16 Scroll Size
	dc.b	%00000000;17 Window H Position
	dc.b	%00000000;18 Window V Position
	dc.b	%00000000;19 
	dc.b	%00000000;20
	dc.b	%00000000;21
	dc.b	%00000000;22
	dc.b	%00000000;23
	include "subroute.asm";good ol recycled file from the stupid genesis tophat turmoil
	include "palettes.asm"
	include "mouseTiles.asm"
	
;Controller Guide;yet again from the stupid seghat genmoil
;0011 0011 0111 1111
;--SA --DU --CB RLDU
;0011 0010 0111 1110 (Up)
;0011 0001 0111 1101 (Dn)
;0011 0011 0111 1011 (Lt)
;0011 0011 0111 0111 (Rt)
;0010 0011 0111 1111 (A)
;0011 0011 0110 1111 (B)
;0011 0011 0101 1111 (C)
;0001 0011 0111 1111 (S)
