# Master Makefile for document

default: latex


# The name of the main document (tex and pdf)
#
# pdflatex will be invoked with this name, meaning it will look for DOCNAME.tex
# and generate DOCNAME.pdf
#
export DOC_NAME=doc

clean:
	git clean -fX .

render: clean
	cd src_latex/ && $(MAKE) $(DOC_NAME).pdf $(DOC_NAME)-final.pdf
	cp src_latex/doc.pdf $(DOC_NAME)-draft.pdf
	cp src_latex/doc-final.pdf $(DOC_NAME)-final.pdf

latex: graphviz git_metadata
	cd src_latex && $(MAKE)

graphviz:
	cd src_graphviz && $(MAKE)

git_metadata:
	cd src_git_metadata/ && $(MAKE)
