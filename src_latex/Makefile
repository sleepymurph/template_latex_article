#======================================================================
# Document-specific variables
#

# Default target
default: doc.pdf

# Basename of current directory
DIR_NAME="$(notdir $(shell pwd))"

# Options to pass to pdflatex
PDFLATEX_OPTS=-halt-on-error

#======================================================================
# Specific rules for this document
#



#======================================================================
# Convenience targets
#

# A version of the PDF in final mode
final: doc-final.pdf

# Clean by removing all git-ignored files
clean:
	git clean -fX .


#======================================================================
# LaTeX
#

TEX_DEPS=\
    *.tex \
    $(shell ls abstract.txt 2>/dev/null) \
    sources.bib \


%.pdf: %.tex $(TEX_DEPS)

	pdflatex $(PDFLATEX_OPTS) $*.tex
	bibtex $*.aux
	makeglossaries $*
	pdflatex $(PDFLATEX_OPTS) $*.tex
	pdflatex $(PDFLATEX_OPTS) $*.tex

# Generate a version of the doc in final mode
%-final.tex: %.tex
	sed 's/%final/final/' $*.tex > $*-final.tex


#======================================================================
# Plots with GnuPlot
#

%.pdf: \
    %.gpi \

	gnuplot -e 'set terminal pdf monochrome size 3in,2in' $*.gpi > $*.pdf

%.svg: \
    %.gpi \

	gnuplot -e 'set terminal svg size 480,360' $*.gpi > $*.svg


#======================================================================
## Debugging

debug-make-vars:
	$(foreach v, $(.VARIABLES), $(info $(v) = $($(v))))
