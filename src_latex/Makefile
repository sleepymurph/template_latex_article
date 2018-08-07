#======================================================================
# Makefile: LaTeX
#

# Default target
default: doc.pdf

# Source documents for the TeX process (tex files, bib database, abstract, etc.)
#
# If this list contains any files that are missing, Make will suddenly not
# remember how to run LaTeX. So if you delete the abstract to disable it, be
# sure to remove it from this list.
#
TEX_DEPS=*.tex *.bib \
	 abstract.txt

# Options to pass to pdflatex
PDFLATEX_OPTS=-halt-on-error


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
## Debugging

debug-make-vars:
	$(foreach v, $(.VARIABLES), $(info $(v) = $($(v))))
