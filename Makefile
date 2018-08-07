# Master Makefile for document

default: latex


# The document name when using the "render" target
#
# Rendered documents will be DOC_NAME-draft.pdf and DOC_NAME-final.pdf,
# So if DOC_NAME is "article", "article-draft.pdf" and "article-final.pdf"
DOC_NAME="article"


clean:
	git clean -fX .

render: clean
	cd src_latex/ && $(MAKE) doc.pdf doc-final.pdf
	cp src_latex/doc.pdf $(DOC_NAME)-draft.pdf
	cp src_latex/doc-final.pdf $(DOC_NAME)-final.pdf

latex: graphviz git_metadata
	cd src_latex && $(MAKE)

graphviz:
	cd src_graphviz && $(MAKE)

git_metadata:
	cd src_git_metadata/ && $(MAKE)
