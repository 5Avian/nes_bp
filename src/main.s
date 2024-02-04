.include "hardware.inc"

.segment "INES_HEADER"
	.byte "NES", $1a	; iNES magic number
	.byte 1				; 1x16KiB PRG ROM (code, data)
	.byte 1				; 1x8KiB CHR ROM (graphics)
	.byte %00000001		; flags 6 - horizontal nametables
	.byte %00000000		; flags 7 - NROM
	; the rest is zero-filled by the linker

.segment "VECTORS"
	.word nmi_vector
	.word reset_vector
	.word irq_vector

.segment "CODE"
	nmi_vector:
	irq_vector:
		rti

	reset_vector:
		sei			; interrupt disable: true
		cld			; decimal mode: false
		ldx #$ff	; reset stack pointer
		txs			;
		
		bit PPUSTATUS		; clear PPUSTATUS before waiting
		lda #1
	@vblank_wait_1:			; ensure PPU RAM is writable
		bit PPUSTATUS		;
		bne @vblank_wait_1	;
	@vblank_wait_2:			;
		bit PPUSTATUS		;
		bne @vblank_wait_2	;

		lda #%01000000	; disable APU IRQ
		sta JOY2		;
		lda #0
		sta DMC_FREQ	; disable DMC IRQ
		sta SND_CHAN	; disable APU sound
		sta PPUCTRL		; disable NMI
		sta PPUMASK		; disable rendering

		tax						; setup counter
	@zero_fill_zp_oam:
		sta ZERO_PAGE, x		; clear zero page
		sta OAM, x				; clear OAM
		inx
		bne @zero_fill_zp_oam
		lda #>OAM				; submit zeroed OAM to PPU
		sta OAMDMA				;

		lda #>$2000		; set address to first nametable
		sta PPUADDR		;
		lda #<$2000		;
		sta PPUADDR		;
		ldx #>2048		; prepare counters
		ldy #<2048		;
	@zero_fill_nametable_1:
		sta PPUDATA
		dey				; left-to-right
		bne @zero_fill_nametable_1
		dex				; top-to-bottom
		bne @zero_fill_nametable_1

		; nametable 1 + 14 rows * 32 columns = 0x21c0
		lda #>$21c0		; set cursor x
		sta PPUADDR		;
		lda #<$21c0		; set cursor y
		sta PPUADDR		;
		ldx #0			; setup counter
	@draw_text:
		lda message_start, x	; submit tile index
		sta PPUDATA				;
		inx
		cpx #message_end - message_start	; draw all characters
		bne @draw_text

		lda #>$3f00	; select first color of first palette
		sta PPUADDR	;
		lda #<$3f00	;
		sta PPUADDR	;
		lda #$0f	; submit black color
		sta PPUDATA	;
		lda #>$3f01	; select second color of first palette
		sta PPUADDR	;
		lda #<$3f01	;
		sta PPUADDR	;
		lda #$30	; submit white color
		sta PPUDATA	;

		lda #0			; reset PPU scroll for rendering
		sta PPUSCROLL	;
		sta PPUSCROLL	;
		lda #%10000000	; enable NMI
		sta PPUCTRL		;
		lda #%00001110	; enable rendering
		sta PPUMASK		;

		cli	; interrupt disable: false
	@infinite_loop:
		jmp @infinite_loop

.segment "DATA"
	message_start:
		.byte "           Hello NES!           "
		.byte "https://github.com/5Avian/nes_bp"
	message_end:

.segment "CHR"
	.incbin "ppf.chr"
