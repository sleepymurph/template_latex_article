#======================================================================
# Makefile: LaTeX
#

# Options to pass to pdflatex
PDFLATEX_OPTS=-halt-on-error


# Source documents for the TeX process (tex files, bib database, abstract, etc.)
#
# If this list contains any files that are missing, Make will suddenly not
# remember how to run LaTeX. So if you delete the abstract to disable it, be
# sure to remove it from this list.
#
TEX_DEPS=\
	 $(wildcard *.tex) \
	 $(wildcard *.bib) \
	 $(wildcard *.txt) \
	 $(wildcard ../src_*/*.tex) \
	 $(wildcard ../generated_components/*) \


# Default target: build the document
# The DOC_NAME is set by the parent build process
$(DOC_NAME).pdf:


# Generic LaTeX build process
%.pdf: %.tex $(TEX_DEPS)
	pdflatex $(PDFLATEX_OPTS) $*.tex
	bibtex $*.aux
	makeglossaries $*
	pdflatex $(PDFLATEX_OPTS) $*.tex
	pdflatex $(PDFLATEX_OPTS) $*.tex
