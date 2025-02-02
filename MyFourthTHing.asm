;68kvectors:
	dc.l $FFFFFE ;$00 SP Initial Value
	dc.l pstart ;$04 PC Initial Value
	dc.l return ;$08 Access Fault
	dc.l return ;$0C Address Error
	dc.l return ;$10 Illegal Instruction
	dc.l return ;$14 Integer Div by 0
	dc.l return ;$18 CHK, CHK2 Instruction
	dc.l return ;$1C FTRAP, TRAP, TRAPV Instructions
	dc.l return ;$20 Priveledge Violation
	dc.l return ;$24 Trace
	dc.l return ;$28 Line 1010($A) Emulator
	dc.l return ;$2C Line 1111($F) Emulator
	dc.l return ;$30 Reserved
	dc.l return ;$34 Coprocessor Violation
	dc.l return ;$38 Format Error
	dc.l return ;$3C Uninitialized Interrupt
	dc.l return ;$40 Reserved
	dc.l return ;$44 Reserved
	dc.l return ;$48 Reserved
	dc.l return ;$4C Reserved
	dc.l return ;$50 Reserved
	dc.l return ;$54 Reserved
	dc.l return ;$58 Reserved
	dc.l return ;$5C Reserved
	dc.l return ;$60 Interrupt #0 (Unused)
	dc.l return ;$64 Interrupt #1
	dc.l return ;$68 Interrupt #2
	dc.l return ;$6C Interrupt #3
	dc.l return;h_int  ;$70 Interrupt #4
	dc.l return ;$74 Interrupt #5
	dc.l return;v_int  ;$78 Interrupt #6
	dc.l return ;$7C Interrupt #7
	dc.l return ;$80 TRAP #0 D 15 Instruction Vectors
	dc.l return ;$84 TRAP #0 D 15 Instruction Vectors
	dc.l return ;$88 TRAP #0 D 15 Instruction Vectors
	dc.l return ;$8C TRAP #0 D 15 Instruction Vectors
	dc.l return ;$90 TRAP #0 D 15 Instruction Vectors
	dc.l return ;$94 TRAP #0 D 15 Instruction Vectors
	dc.l return ;$98 TRAP #0 D 15 Instruction Vectors
	dc.l return ;$9C TRAP #0 D 15 Instruction Vectors
	dc.l return ;$A0 TRAP #0 D 15 Instruction Vectors
	dc.l return ;$A4 TRAP #0 D 15 Instruction Vectors
	dc.l return ;$A8 TRAP #0 D 15 Instruction Vectors
	dc.l return ;$AC TRAP #0 D 15 Instruction Vectors
	dc.l return ;$B0 TRAP #0 D 15 Instruction Vectors
	dc.l return ;$B4 TRAP #0 D 15 Instruction Vectors
	dc.l return ;$B8 TRAP #0 D 15 Instruction Vectors
	dc.l return ;$BC TRAP #0 D 15 Instruction Vectors
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
	dc.b	"SEGA GENESIS TEST                               "
	dc.b	"Behold the humour of 2023 me.                   "
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
return
	rte
vc = $C00004
vd = $C00000
pstart
	move.b $A10001,d0
	andi.b #$0F,d0
	beq pstartt
	move.l	#'SEGA',$A14000
pstartt
	move.w #$100,$A11100
	move.w #$100,$A11200
Z80
	btst #0,$A11100
	bne	Z80
	lea	Z80Stuff,a0
	move.l #$A00000,a1
	moveq #$29,d0
SetZ80
	move.b (a0)+,(a1)+
	dbra d0,SetZ80
	move.w #0,$A11200
	move.w #0,$A11100
SetPSG
	move.b #$9F,$C00011
	move.b #$BF,$C00011
	move.b #$DF,$C00011
	move.b #$FF,$C00011
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
	move.l #0,a0
	movem.l (a0),d0-d7/a1-a6
	move.w #$2700,sr
CRAMAccess
	lea Palette1,a1
	move.w #$8F02,vc
	move.l #$C0000003,vc
	moveq #7,d0
CRAMWrite
	move.l (a1)+,$C00000
	dbra d0,CRAMWrite
VRAMAccess
	lea Tile1,a1
	move.l #$40200000,vc
	move.w #$140,d0
VRAMWrite
	move.l (a1)+,vd
	dbra d0,VRAMWrite
PictureAccess
	move.l #$40000003,vc
	lea Pattern1,a1
	moveq #25,d0
	moveq #0,d1
PictureWrite
	move.b (a1)+,d1
	move.w	d1,vd
	dbra d0,PictureWrite
	;move.w #$8700,vc
Scroll
	;move.l #$1111,d0
	;cmp.b #$0,d0
	;move.w d0,vc
	bra Scroll
Endd
	jmp Endd
VDPStuff:
	dc.b	%00010100;0
	dc.b	%01000100;1
	dc.b	%00110000;2
	dc.b	%00000000;3
	dc.b	%00000111;4
	dc.b	%00000000;5
	dc.b	%00000000;6
	dc.b	%00000000;7
	dc.b	%00000000;8
	dc.b	%00000000;9
	dc.b	%00000000;10
	dc.b	%00000000;11
	dc.b	%00000000;12
	dc.b	%00000000;13
	dc.b	%00000000;14
	dc.b	%00000010;15
	dc.b	%00000000;16
	dc.b	%00000000;17
	dc.b	%00000000;18
	dc.b	%00000000;19
	dc.b	%00000000;20
	dc.b	%00000000;21
	dc.b	%00000000;22
	dc.b	%00000000;23
Z80Stuff:
	dc.w	$AF01,$D91F
	dc.w	$1127,$0021
	dc.w	$2600,$F977
	dc.w	$EDB0,$DDE1
	dc.w	$FDE1,$ED47
	dc.w	$ED4F,$D1E1
	dc.w	$F108,$D9C1
	dc.w	$D1E1,$F1F9
	dc.w	$F3ED,$5636
	dc.w	$E9E9,$8104
	dc.w	$8F01
Palette1:
	dc.w	$0000
	dc.w	$000E
	dc.w	$00E0
	dc.w	$0E00
	dc.w	$0000
	dc.w	$0EEE
	dc.w	$00EE
	dc.w	$008E
	dc.w	$0E0E
	dc.w	$0808
	dc.w	$0444
	dc.w	$0888
	dc.w	$0EE0
	dc.w	$000A
	dc.w	$0A00
	dc.w	$00A0
Tile1:
	dc.l	$00010000
	dc.l	$00101000
	dc.l	$001D1D00
	dc.l	$010D0100
	dc.l	$011111D0
	dc.l	$01DDD1D0
	dc.l	$01D001D0
	dc.l	$00D000D0

	dc.l	$01111000
	dc.l	$01DDD100
	dc.l	$01D001D0
	dc.l	$011110D0
	dc.l	$01DDD100
	dc.l	$01D001D0
	dc.l	$011110D0
	dc.l	$00DDDD00

	dc.l	$00111000
	dc.l	$010DD100
	dc.l	$01D000D0
	dc.l	$01D00000
	dc.l	$01D00000
	dc.l	$01D00100
	dc.l	$001110D0
	dc.l	$000DDD00

	dc.l	$01111000
	dc.l	$01DDD100
	dc.l	$01D001D0
	dc.l	$01D001D0
	dc.l	$01D001D0
	dc.l	$01D001D0
	dc.l	$011110D0
	dc.l	$00DDDD00

	dc.l	$01111100
	dc.l	$01DDDDD0
	dc.l	$01D00000
	dc.l	$01111000
	dc.l	$01DDDD00
	dc.l	$01D00000
	dc.l	$01111100
	dc.l	$00DDDDD0

	dc.l	$01111100
	dc.l	$01DDDDD0
	dc.l	$01D00000
	dc.l	$01111000
	dc.l	$01DDDD00
	dc.l	$01D00000
	dc.l	$01D00000
	dc.l	$00D00000

	dc.l	$00111000
	dc.l	$010DD100
	dc.l	$01D000D0
	dc.l	$01D00000
	dc.l	$01D11100
	dc.l	$01D0D1D0
	dc.l	$001110D0
	dc.l	$000DDD00

	dc.l	$01000100
	dc.l	$01D001D0
	dc.l	$01D001D0
	dc.l	$011111D0
	dc.l	$01D001D0
	dc.l	$01D001D0
	dc.l	$01D001D0
	dc.l	$00D000D0

	dc.l	$01111100
	dc.l	$00D1DDD0
	dc.l	$0001D000
	dc.l	$0001D000
	dc.l	$0001D000
	dc.l	$0001D000
	dc.l	$01111100
	dc.l	$00DDDDD0

	dc.l	$00000100
	dc.l	$000001D0
	dc.l	$000001D0
	dc.l	$000001D0
	dc.l	$010001D0
	dc.l	$01D001D0
	dc.l	$001110D0
	dc.l	$000DDD00

	dc.l	$01000100
	dc.l	$01D01000
	dc.l	$01D10D00
	dc.l	$0110D000
	dc.l	$01D10000
	dc.l	$01D01000
	dc.l	$01D00100
	dc.l	$00D000D0

	dc.l	$01000000
	dc.l	$01D00000
	dc.l	$01D00000
	dc.l	$01D00000
	dc.l	$01D00000
	dc.l	$01D00000
	dc.l	$01111100
	dc.l	$00DDDDD0

	dc.l	$01000100
	dc.l	$011011D0
	dc.l	$01D101D0
	dc.l	$01D0D1D0
	dc.l	$01D001D0
	dc.l	$01D001D0
	dc.l	$01D001D0
	dc.l	$00D000D0

	dc.l	$01000100
	dc.l	$011001D0
	dc.l	$01D101D0
	dc.l	$01D011D0
	dc.l	$01D001D0
	dc.l	$01D001D0
	dc.l	$01D001D0
	dc.l	$00D000D0

	dc.l	$00111000
	dc.l	$010DD100
	dc.l	$01D001D0
	dc.l	$01D001D0
	dc.l	$01D001D0
	dc.l	$01D001D0
	dc.l	$001110D0
	dc.l	$000DDD00

	dc.l	$01111000
	dc.l	$01DDD100
	dc.l	$01D001D0
	dc.l	$011110D0
	dc.l	$01DDDD00
	dc.l	$01D00000
	dc.l	$01D00000
	dc.l	$00D00000

	dc.l	$00111000
	dc.l	$010DD100
	dc.l	$01D001D0
	dc.l	$01D001D0
	dc.l	$01D101D0
	dc.l	$001110D0
	dc.l	$000DD100
	dc.l	$000000D0

	dc.l	$01111000
	dc.l	$01DDD100
	dc.l	$01D001D0
	dc.l	$011110D0
	dc.l	$01D1DD00
	dc.l	$01D01000
	dc.l	$01D00100
	dc.l	$00D000D0

	dc.l	$00111000
	dc.l	$010DD100
	dc.l	$01D000D0
	dc.l	$00111000
	dc.l	$000DD100
	dc.l	$010001D0
	dc.l	$00111000
	dc.l	$000DDD00

	dc.l	$01111100
	dc.l	$00D1DDD0
	dc.l	$0001D000
	dc.l	$0001D000
	dc.l	$0001D000
	dc.l	$0001D000
	dc.l	$0001D000
	dc.l	$0000D000

	dc.l	$01000100
	dc.l	$01D001D0
	dc.l	$01D001D0
	dc.l	$01D001D0
	dc.l	$01D001D0
	dc.l	$01D001D0
	dc.l	$001110D0
	dc.l	$000DDD00

	dc.l	$01000100
	dc.l	$01D001D0
	dc.l	$01D001D0
	dc.l	$001010D0
	dc.l	$001D1D00
	dc.l	$001D1D00
	dc.l	$00010D00
	dc.l	$0000D000

	dc.l	$01000100
	dc.l	$01D001D0
	dc.l	$01D001D0
	dc.l	$01D001D0
	dc.l	$01D101D0
	dc.l	$011011D0
	dc.l	$01DD01D0
	dc.l	$00D000D0

	dc.l	$01000100
	dc.l	$01D001D0
	dc.l	$001010D0
	dc.l	$00010D00
	dc.l	$00101000
	dc.l	$010D0100
	dc.l	$01D001D0
	dc.l	$00D000D0

	dc.l	$01000100
	dc.l	$01D001D0
	dc.l	$001010D0
	dc.l	$001D1D00
	dc.l	$00010D00
	dc.l	$0001D000
	dc.l	$0001D000
	dc.l	$0000D000

	dc.l	$01111100
	dc.l	$00DDD1D0
	dc.l	$000010D0
	dc.l	$00010D00
	dc.l	$0010D000
	dc.l	$010D0000
	dc.l	$01111100
	dc.l	$00DDDDD0

	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00001100
	dc.l	$000011D0
	dc.l	$00000DD0

	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00001100
	dc.l	$000011D0
	dc.l	$000001D0

	dc.l	$000D1100
	dc.l	$00D11110
	dc.l	$01D13550
	dc.l	$01D13330
	dc.l	$01D11110
	dc.l	$0DD11110
	dc.l	$00D10D10
	dc.l	$00D10D10

	dc.l	$00111100
	dc.l	$01111110
	dc.l	$011DD11D
	dc.l	$00DD11DD
	dc.l	$00011DD0
	dc.l	$0000DD00
	dc.l	$00011000
	dc.l	$0000DD00

	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000

	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000

	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000

	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000

	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000

	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000

	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000

	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000

	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000

	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
Pattern1:
	dc.b	20
	dc.b	8
	dc.b	9
	dc.b	19
	dc.b	0
	dc.b	9
	dc.b	19
	dc.b	0
	dc.b	1
	dc.b	0
	dc.b	19
	dc.b	21
	dc.b	19
	dc.b	0
	dc.b	9
	dc.b	13
	dc.b	16
	dc.b	15
	dc.b	19
	dc.b	20
	dc.b	5
	dc.b	18
	dc.b	28
	dc.b	0
	dc.b	29
