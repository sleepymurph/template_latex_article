# Master Makefile for document

default: latex


# The name of the main document (tex and pdf)
#
# pdflatex will be invoked with this name, meaning it will look for DOCNAME.tex
# and generate DOCNAME.pdf
#
export DOC_NAME=doc


#----------------------------------------------------------------------
# Other high-level targets
#

clean:
	git clean -fX .

# Create a date-stamped PDF to send to a collaborator
datestamp: clean latex
	cp src_latex/$(DOC_NAME).pdf $(DOC_NAME).$(shell date +%Y%m%d).pdf

# Create a date-and-git-hash-stamped PDF to send to a collaborator
gitstamp: clean git_metadata latex
	cp src_latex/$(DOC_NAME).pdf $(DOC_NAME).$(shell date +%Y%m%d).$(shell cat generated_components/generated_git_short_hash.txt).pdf


#----------------------------------------------------------------------
# Build subsystems
#

latex: graphviz git_metadata
	cd src_latex && $(MAKE)

graphviz:
	cd src_graphviz && $(MAKE)

git_metadata:
	cd src_git_metadata/ && $(MAKE)
