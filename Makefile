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
	cd article-latex-src/ && $(MAKE) doc.pdf doc-final.pdf
	cp article-latex-src/doc.pdf $(DOC_NAME)-draft.pdf
	cp article-latex-src/doc-final.pdf $(DOC_NAME)-final.pdf

latex:
	cd article-latex-src && $(MAKE)
