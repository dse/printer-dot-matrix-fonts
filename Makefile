TARGETS = $(BDFS) $(TTFS)

DEPS       = src/la120.chars.txt \
             src/la100.chars.txt
SRC_FONTS  = \
             src/la120.font.txt \
             src/la120-10cpi.font.txt \
             src/la120-16point5cpi.font.txt \
             src/la100.font.txt \
             src/la100-10cpi.font.txt \
             src/la100-16point5cpi.font.txt
BDFS       = $(patsubst src/%.font.txt,dist/bdf/%.bdf,$(SRC_FONTS))
TTFS       = $(patsubst src/%.font.txt,dist/ttf/%.ttf,$(SRC_FONTS))

BDFBDF                 = ~/git/dse.d/perl-font-bitmap/bin/bdfbdf
BDFBDF_OPTIONS         =
BITMAPFONT2TTF         = bitmapfont2ttf
BITMAPFONT2TTF_OPTIONS = --dot-width 1 --dot-height 1 --circular-dots

default: $(TARGETS)

debug:
	BITMAPFONT2TTF=1 make default

dist/bdf/%.bdf: src/%.font.txt $(DEPS) Makefile
	mkdir -p bdf || true
	$(BDFBDF) $(BDFBDF_OPTIONS) $< > $@.tmp.bdf
	mv $@.tmp.bdf $@

dist/ttf/%.ttf: dist/bdf/%.bdf Makefile
	mkdir -p ttf || true
	$(BITMAPFONT2TTF) $(BITMAPFONT2TTF_OPTIONS) $< $@.tmp.ttf
	mv $@.tmp.ttf $@

clean:
	/bin/rm $(BDFS) $(TTFS) */*.tmp.* >/dev/null 2>/dev/null || true

publish1:
	rsync -av dist/ttf/ dse@webonastick.com:/www/webonastick.com/htdocs/demos/tractorfeed/fonts
