
OBJDIR = obj

all: ascii2utf8.exe

ascii2utf8.exe: ascii2utf8.hs
	ghc --make -j8 -O3 -o $@ -outputdir $(OBJDIR) $<

clean:
	rm -rf $(OBJDIR) *.exe
