	dc.l $FFFFFE ;$00 SP Initial Value
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
header:
	dc.b	"SEGA GENESIS    "
	dc.b	"(C)LOUW 2023.APR"
	dc.b	"Escape me if you can...                         "
	dc.b	"SEGA GENESIS TEST                               "
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
pstart
	;move.l $A10001,d0
	;andi.b #$0F,d0
	;beq VDP
	move.l	#'SEGA',$A14000
VDP
	lea VDPStuff,a1
	moveq #$18,d0
	moveq #0,d1
	move.w #$8000,d1
SetVDP
	move.b (a1)+,d1
	move.w d1,vc
	addi.w #$100,d1
	dbra d0,SetVDP
SetIO
	move.b #0,$A10009
	move.b #0,$A1000B
	move.b #0,$A1000D
	move.l #$FF0000,d0
	movea.l d0,a0
	moveq #0,d0
	move.l d0,(a0)
	movem.l (a0),d1-d7/a1-a6
	move.w #$2700,sr
InitVRAM
	movea.l #vc,a0
	move.l #crw,(a0)
	suba.w a0,a0
	move.w #$0EC2,(a0)
InitGame;make the mouse object and other ones maybe
	;move the tiles into the vram of the vdp of the genesis of sega of japan of the earth of the solar system of the milky way of the universe
	lea mousepointer, a0
	movea.l #vc,a1
	move.l #8F02,(a1)
	move.l vrw,(a1)
	suba.w a0,a0
	moveq #15,d0
	move.l (a0)+,(a1)
	dbra #-4,d0
	;;initialize of the object of the mouse
	movea.l #$FF0000, a0
	move.w #$0080, (a0)
looop;process the objects and wait for vsync
	bra looop
testobj
	
return
	rts
	dc.w $0000
afault
	rts
	dc.w $0001
aerror
	rts
	dc.w $0002
illins
	rts
	dc.w $0003
intdb0 ;$14 Integer Div by 0
	rts
	dc.w $0004
chkins ;$18 CHK, CHK2 Instruction
	rts
	dc.w $0005
ftrapv ;$1C FTRAP, TRAP, TRAPV Instructions
	rts
	dc.w $0006
privio ;$20 Priveledge Violation
	rts
	dc.w $0007
trace ;$24 Trace
	rts
	dc.w $0008
ln1010 ;$28 Line 1010($A) Emulator
	rts
	dc.w $0009
ln1111 ;$2C Line 1111($F) Emulator
	rts
	dc.w $000a
copvio ;$34 Coprocessor Violation
	rts
	dc.w $000b
format ;$38 Format Error
	rts
	dc.w $000c
uninit ;$3C Uninitialized Interrupt
	rts
	dc.w $000d
Hblank
	rts
Vblank
	rts
inter0 ;$60 Interrupt #0 (Unused)
	rts
	dc.w $000e
inter1 ;$64 Interrupt #1
	rts
	dc.w $000f
extint ;$68 Interrupt #2
	rts
	dc.w $0010
inter3 ;$6C Interrupt #3
	rts
	dc.w $0011
inter5 ;$74 Interrupt #5
	rts
	dc.w $0012
inter7 ;$7C Interrupt #7
	rts
	dc.w $0013
trap00 ;$80 TRAP #0 D 15 Instruction Vectors
	rts
	dc.w $0014
	;dc.l trap01 ;$84 TRAP #0 D 15 Instruction Vectors
	;dc.l trap02 ;$88 TRAP #0 D 15 Instruction Vectors
	;dc.l trap03 ;$8C TRAP #0 D 15 Instruction Vectors
	;dc.l trap04 ;$90 TRAP #0 D 15 Instruction Vectors
	;dc.l trap05 ;$94 TRAP #0 D 15 Instruction Vectors
	;dc.l trap06 ;$98 TRAP #0 D 15 Instruction Vectors
	;dc.l trap07 ;$9C TRAP #0 D 15 Instruction Vectors
	;dc.l trap08 ;$A0 TRAP #0 D 15 Instruction Vectors
	;dc.l trap09 ;$A4 TRAP #0 D 15 Instruction Vectors
	;dc.l trap0a ;$A8 TRAP #0 D 15 Instruction Vectors
	;dc.l trap0b ;$AC TRAP #0 D 15 Instruction Vectors
	;dc.l trap0c ;$B0 TRAP #0 D 15 Instruction Vectors
	;dc.l trap0d ;$B4 TRAP #0 D 15 Instruction Vectors
	;dc.l trap0e ;$B8 TRAP #0 D 15 Instruction Vectors
	;dc.l trap0f ;$BC TRAP #0 D 15 Instruction Vectors
WaitForVee
	move.w vc,d6
	andi.b #8,d6
	bne WaitForVee
	rts
DoneWithVee
	move.w vc,d6
	andi.b #8,d6
	beq DoneWithVee
	rts
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
	include "palettes.asm"
	include "mouseTiles.asm"