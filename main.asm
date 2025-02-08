	org	0
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
cc1 = $A10009
cc2 = $A1000B
zbr = $A11100 ;z80 bus req
zr = $A11200 ;z80 reset
vc = $C00004 ;vdp control
vd = $C00000 ;vdp data
vrw = $40000000 ;vram write
crw = $C0000000 ;cram write
vsw = $40000010 ;vsram write
vrr = $0 ;vram read
crr = $20 ;cram read
vsr = $10 ;vsram read
sca = $8000 ;Scroll A
scb = $A000 ;Scroll B
scw = $C000 ;Window
sch = $C800 ;H Scroll
sat = $CC00 ;Sprite Attrib. Table

hdl = 16 ;obj header length

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

;actual code starts here by the way
pstart	cmpi.l	#'MRAU',$FF0004	;check if soft or hard reset
	beq	VDP			;if it is then skip init
	move.b	$A10001,d0		;do the tmss thing
	andi.b	#$0F,d0
	beq SetIO
	move.l	#'SEGA',$A14000
SetIO	move.b	#0,$A10009	;make them controllers readable
	move.b	#0,$A1000B
	move.b	#0,$A1000D
ClrAll	;move.l	#$FF0000,d0	;clear the registers
	;movea.l	d0,a0
	;moveq	#0,d0
	;move.l	d0,(a0)
	;movem.l	(a0),d1-d7/a1-a6
	
	move.w	#$2700,sr
VDP	lea	VDPStuff,a1	;load them vdp registers
	moveq	#$18,d0		;i would make this into a
	moveq	#0,d1		;subroutine but im too lazy rn
	move.w	#$8000,d1
SetVDP	move.b	(a1)+,d1
	move.w	d1,vc
	addi.w	#$100,d1
	dbra	d0,SetVDP
InitM	moveq	#0,d1		;Init Memory
	move.l	#$3FFF,d0
	move.l	#$FF0000,a0
InitM1	move.l	d1,(a0)+
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
InitG	lea	palette1,a0	;initialize game
	moveq	#31,d0
	bsr	LoadCM
	lea	mousepointer,a0
	move.l	#24*8,d0
	moveq	#$20,d1
	move.w	#$8F02,vc
	bsr	DMA2VM
	moveq	#1,d1		;initialize of the object of the mouse
	bra	mewo_v2
mewo	moveq	#0,d0		;make some objects
	move.l	#'MEOW',(a0)+	;this mewo aint a reference to mysticat btw
	move.l	#testobj,(a0)+	;its only a typo
	move.w	d0,(a0)+	
	move.l	#$F00,(a0)+
	move.l	d0,(a0)+
	dbra	d1,mewo
mewo_v2	lea	mouse,a0
	jsr	newObj
	
looop	jsr	WaitForVee	;process the objects and wait for vsync
	bsr	P1Ctrl
	move.l	#$FF0000,a5
lookobj	movea.l	a5,a6		;move current object to last object
	move.l	a5,d0		;because the stupid address is sign extended on a registers
	move.w	(8,a6),d0	;get new object
	move.l	d0,a5
	cmp.l	#'MEOW',(a5)	;is it an object?
	bne	doneobj		;extremely rudimentary error handler/end of loop
	move.l	(4,a5),a0
	jsr	(a0)		;do the object subroutine
	bra	lookobj
doneobj	bsr	DoneWithVee		;done with processing the objects
	bsr	drawing
	bra	looop
	dc.w	$FFFF
	dc.w	%0000000000000000	;object stuff pay it no mind
	dc.w	$1
testobj	add.w	hdl+2,a5		;seizure inducing background flash goooo-
	move.w	#$8700,d0
	move.b	(a5),d0
	add.b	#1,d0
	move.b	d0,(a5)
	move.l	#vc,a0
	move.w	d0,(a0)
	sub.w	#hdl+2,a5
	rts
	dc.w	$1	;this is the mouse's id
	dc.w	%0000000000000000
	dc.w	$1	;curse that minimum variable size
mouse	add.w	#$10,a5
	move.l	$FF0016,d1	;mouse x stuff
	move.w	$FF000A,d0	;move the controller input into d0
	not.l	d0
	and.w	#$F,d0
	bne	*+6
	clr.b	(a5)
	bra	mouse2
	cmp.b	#$FF,(a5)
	bcs	*+6
	moveq	#$5,d2
	bra	mouse1
	add.b	#$1,(a5)
	cmp.b	#$BF,(a5)
	bcs	*+6
	moveq	#$4,d2
	bra	mouse1
	cmp.b	#$7F,(a5)
	bcs	*+6
	moveq	#$3,d2
	bra	mouse1
	cmp.b	#$3F,(a5)
	bcs	*+6
	moveq	#$2,d2
	bra	mouse1
	moveq	#$1,d2
mouse1	btst	#$0,d0		;more testing than schools
	beq	*+4		;or maybe not
	sub.w	d2,d1
	btst	#$1,d0
	beq	*+4
	add.w	d2,d1
	tst.w	d1		;check if mouse x went to negative
	bpl	*+6
	sub.w	d1,d1		;set it back to 0
	bra	*+12
	cmp.w	#$E0,d1	;check if the mouse is too far right
	blt	*+6
	move.w	#$DF,d1		;set it to the max x coord
	swap	d1		;mouse y stuff
	btst	#$2,d0
	beq	*+4
	sub.w	d2,d1
	btst	#$3,d0
	beq	*+4
	add.w	d2,d1
	tst.w	d1		;check is mouse y went to negative
	bpl	*+6
	sub.w	d1,d1		;set it back to 0
	bra	*+12
	cmp.w	#$100,d1	;check if the mouse is too far down
	blt	*+6
	move.w	#$FF,d1
	swap	d1
mouse2	move.l	d1,$FF0016
	;draw somethin now ya doofus
	;make the draw function put mouse on top priority
	sub.w	#$10,a5
	rts
	dc.w	$2	;this is the button's id
	dc.w	%0000000000000000
	dc.w	$4
button	;button processing here	
	rts
;the variables are one byte which is which colour in the palette to swap to and a one bit debounce.
;the code checks if the a button is pushed, then if not debounced, then if the pointer is in range.
;if all checks pass then the colour changes and the debounce is set.
;if the a button is released and it is debounced then the debounce is cleared.
return	bra	*-0	;generic return
afault	bra	*-0
aerror	bra	*-0
illins	bra	*-0
intdb0	bra	*-0	;$14 Integer Div by 0
chkins	bra	*-0	;$18 CHK, CHK2 Instruction
ftrapv	bra	*-0	;$1C FTRAP, TRAP, TRAPV Instructions
privio	bra	*-0	;$20 Priveledge Violation
trace	bra	*-0	;$24 Trace
ln1010	bra	*-0	;$28 Line 1010($A) Emulator
ln1111	bra	*-0	;$2C Line 1111($F) Emulator
copvio	bra	*-0	;$34 Coprocessor Violation
format	bra	*-0	;$38 Format Error
uninit	bra	*-0	;$3C Uninitialized Interrupt
Hblank	rts		;Horizontal Interrupt i should map these to ram addresses
Vblank	rts		;Vertical Interrupt   so that i can jump to whatever i want
inter0	bra	*-0	;$60 Interrupt #0 (Unused)
inter1	bra	*-0	;$64 Interrupt #1
extint	bra	*-0	;$68 Interrupt #2
inter3	bra	*-0	;$6C Interrupt #3
inter5	bra	*-0	;$74 Interrupt #5
inter7	bra	*-0	;$7C Interrupt #7
trap00	bra	*-0	;$80 TRAP #0 D 15 Instruction Vectors
LoadCM	;Load into Colour Memory
;a0 = location of colours
;d0 = amount of colours - 1
	movea.l	#vc,a1
	move.w	#$8F02,(a1)
	move.l	#crw,(a1)
	suba.w	a1,a1
	;moveq	#15,d0
LoadCM1	move.w	(4,a1),d1
	and.w	#$0200,d1
	beq	LoadCM1
	move.l	(a0)+,(a1)
	dbra	d0,LoadCM1
	rts
newObj	;>input a0 = address of object subroutine
	;destroys d0 d1 a1 a2
	;<output a1 = start of variables (for object init)
	;wont work for objects with 0 variables (which at that point what does the object even do)
	;you can just have a 1 byte dummy variable as a workaround for now but it aint mem efficient
	moveq	#0,d0
	move.w	(-2,a0),d0	;object size
	movea.l	#$FF0080,a1	;first memory thingy
newObj1	move.l	d0,d1		;make the iterator thing
	addq.w	#1,d1
	divu.w	#2,d1
	bclr.l	#16,d1
	addq.w	#7,d1		;until here
	;addq.w	#2,a1
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
	sub.w	#$10,a1			;move the register to start of object
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
	move.w	(-6,a0),(a1)+
	rts	;i retract my previous statement about not getting insomnia coding this
drawing	move.l	#$FF0000,a5
	moveq	#0,d0		;d0 is the dma length
	move.l	sp,d7		;back up the sp
drawin1	movea.l	a5,a6		;move current object to last object
	move.l	a5,d2		;because the stupid address is sign extended on a registers
	move.w	(8,a6),d2		;get new object
	move.l	d2,a5
	cmp.l	#'MEOW',(a5)	;is it an object?
	bne	drawin3		;extremely rudimentary error handler/end of loop
	moveq	#0,d2		;get the object id
	move.w	(14,a5),d2
	add.w	#$100,d2		;find the sprite struct
	rol.l	#3,d2
	move.l	d2,a1
	move.l	-(a1),-(sp)	;load the sprite
	move.l	-(a1),-(sp)
	add.l	#4,d0
	cmp.w	#1,(14,a5)
	bne	drawin2
	move.w	$FF0016,(6,sp)
	add.w	#$80,(6,sp)
	move.w	$FF0018,(sp)
	add.w	#$80,(sp)
drawin2	bra	drawin1
drawin3	move.l	#$CC00,d1
	move.l	sp,a0
	bsr	DMA2VM
	move.l	d7,sp
	rts
VDPStuff:
	;for 1 ? bit, ?=1 is first, and ?=0 is second if present
	;for 2 or more ? bits, it goes 0 to max value
	dc.b	%00000100;0 Mode 1
			;000? Enable H Int. (Reg. 10)
			;01?0 Disable HV Counter
	dc.b	%01000100;1 Mode 2
			;0? Enable Display
			;? Enable V Int.
			;? DMA Enable
			;?100 30/28 Cell V Res.
	dc.b	%00100000;2 Scroll A
			;00???000 MSBs of 16bit addr.
	dc.b	%00110000;3 Window
			;00?????0 MSBs of 16bit addr.
	dc.b	%00000101;4 Scroll B
			;00000??? MSBs of 16bit addr.
	dc.b	%01100110;5 Sprite Attrib.
			;0??????? MSBs of 16bit addr.
			;LSB is 0 in 40 Cell H Res.
	dc.b	%00000000;6 Unused
	dc.b	%00000000;7 BG Colo(u)r
			;00?? Palette Number
			;???? Colo(u)r Number
	dc.b	%00000000;8 Unused
	dc.b	%00000000;9 Unused
	dc.b	%00000000;10 Horizontal Interrupt Timer
	dc.b	%00000000;11 Mode 3
			;0000? Enable Ext. Int.
			;? 2 Cell/All V Scroll
			;?? All/X/Cell/Line H Scroll
	dc.b	%00000000;12 Mode 4
			;? 40/32 Cell H Res.(bit 0)
			;000? Shadow/Highlight
			;?? No/X/Yes/2xRes. Interlace
			;? 40/32 Cell H Res.(bit 7)
	dc.b	%00110010;13 H Scroll
	dc.b	%00000000;14 Unused
	dc.b	%00000010;15 Auto Increase VRAM Address
	dc.b	%00000000;16 Scroll Size
			;00?? 32/64/X/128 V Scroll Size
			;00?? 32/64/X/128 H Scroll Size
	dc.b	%00000000;17 Window H Position
	dc.b	%00000000;18 Window V Position
	dc.b	%00000000;19 DMA Length Counter Low
	dc.b	%00000000;20 DMA Length Counter High
	dc.b	%00000000;21 DMA Source Counter Low
	dc.b	%00000000;22 DMA Source Counter Mid
	dc.b	%00000000;23 DMA Source Counter High
	include "subroute.asm";good ol recycled file from the stupid genesis tophat turmoil
	org	$800
	include "sprites.asm"
	include "palettes.asm"
	include "mouseTiles.asm"
	include "bgTiles.asm"
	
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
