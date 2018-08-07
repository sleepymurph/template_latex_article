#======================================================================
# Makefile: LaTeX
#

# The DOC_NAME is set by the parent build process
default: $(DOC_NAME).pdf

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
# Targets
#

# Clean by removing all git-ignored files
clean:
	git clean -fX .


# Generic LaTeX build process
%.pdf: %.tex $(TEX_DEPS)

	pdflatex $(PDFLATEX_OPTS) $*.tex
	bibtex $*.aux
	makeglossaries $*
	pdflatex $(PDFLATEX_OPTS) $*.tex
	pdflatex $(PDFLATEX_OPTS) $*.tex


# for debugging: show all variables
debug-make-vars:
	$(foreach v, $(.VARIABLES), $(info $(v) = $($(v))))
