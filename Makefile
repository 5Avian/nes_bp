NAME = nes_bp
VERSION = 0.1.0

TARGET = dist/$(NAME)-$(VERSION).nes
SOURCES = $(wildcard src/*.s)
OBJECTS = $(patsubst src/%.s,build/%.o,$(SOURCES))

AS = ca65
ASFLAGS =
LD = ld65
LDFLAGS = -C nes.lds
EMU = Mesen

# ---

all: prep $(TARGET)

prep:
	mkdir -p build/ dist/

clean:
	rm -rf build/ dist/

re: clean all

run: all
	$(EMU) $(TARGET)

rerun: clean run

.PHONY: all prep clean re run rerun

# ---

$(TARGET): $(OBJECTS)
	$(LD) $(LDFLAGS) -o $@ $^

build/%.o: src/%.s
	$(AS) $(ASFLAGS) -o $@ $<
