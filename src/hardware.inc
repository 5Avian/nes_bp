; https://www.nesdev.org/wiki/CPU_memory_map
;
; Memory access is a lot faster in the zero-page.

ZERO_PAGE	= $0000
OAM			= $0200

; https://www.nesdev.org/wiki/PPU_registers
; https://www.nesdev.org/wiki/2A03
;
; PPU registers have shared state, which
; needs to be cleared before rendering.
; https://www.nesdev.org/wiki/PPU_scrolling#Register_controls

PPUCTRL		= $2000
PPUMASK		= $2001
PPUSTATUS	= $2002
OAMADDR		= $2003
OAMDATA		= $2004
PPUSCROLL	= $2005
PPUADDR		= $2006
PPUDATA		= $2007

SQ1_VOL		= $4000
SQ1_SWEEP	= $4001
SQ1_LO		= $4002
SQ1_HI		= $4003
SQ2_VOL		= $4004
SQ2_SWEEP	= $4005
SQ2_LO		= $4006
SQ2_HI		= $4007
TRI_LINEAR	= $4008
TRI_LO		= $400a
TRI_HI		= $400b
NOISE_VOL	= $400c
NOISE_LO	= $400e
NOISE_HI	= $400f
DMC_FREQ	= $4010
DMC_RAW		= $4011
DMC_START	= $4012
DMC_LEN		= $4013
OAMDMA		= $4014
SND_CHAN	= $4015
JOY1		= $4016
JOY2		= $4017
