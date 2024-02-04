# LD65 Linker Script for the NES
#
# https://cc65.github.io/doc/ld65.html#s5
# https://www.nesdev.org/wiki/CPU_memory_map
# https://www.nesdev.org/wiki/INES
# https://www.nesdev.org/wiki/NROM

MEMORY {
	INES_HEADER:	start = $4242, size = $0010, type = ro, file = %O, fill = yes, fillval = $00;
	ZERO_PAGE:		start = $0000, size = $0100, type = rw, file = "";
	STACK:			start = $0100, size = $0100, type = rw, file = "";
	OAM:			start = $0200, size = $0100, type = rw, file = "";
	RAM:			start = $0300, size = $0500, type = rw, file = "";
	PRG_ROM:		start = $c000, size = $4000, type = ro, file = %O, fill = yes, fillval = $42;
	CHR_ROM:		start = $4242, size = $2000, type = ro, file = %O, fill = yes, fillval = $42;
}

SEGMENTS {
	INES_HEADER:	load = INES_HEADER, type = ro;
	ZERO_PAGE:		load = ZERO_PAGE, type = bss, optional = yes;
	RAM:			load = RAM, type = bss, optional = yes;
	CODE:			load = PRG_ROM, type = ro;
	DATA:			load = PRG_ROM, type = ro;
	VECTORS:		load = PRG_ROM, type = ro, start = $fffa;
	CHR:			load = CHR_ROM, type = ro;
}
