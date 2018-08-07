#======================================================================
# Makefile: Diagrams with Graphviz
#

GENERATED=\
    example_graphviz_diagram.pdf

default: copy_generated

DOT_INCLUDE=diagram_common.m4.dot

#----------------------------------------------------------------------
# Generic Rules
#
# These are generic rules to render Graphviz graphs with an M4 processing step.
# PDF seems to be the best vector graphics format for including in LaTeX
# documents.
#
# X.dot -> (m4) X.preprocessed.dot -> (dot) X.pdf OR X.png
#
# You can create a common file of M4 macros to be used in all documents. Just
# add it to the DOT_INCLUDE variable.
#
# If a specific diagram needs to be processed with Neato or other Graphviz
# program, you can create a more specific rule for that diagram.
#

copy_generated: $(GENERATED)
	cp $(GENERATED) ../generated_components

%.preprocessed.dot: %.dot $(DOT_INCLUDE)
	m4 $(DOT_INCLUDE) $*.dot > $*.preprocessed.dot

%.pdf: %.preprocessed.dot
	dot -Tpdf -o $*.pdf $*.preprocessed.dot

%.png: %.preprocessed.dot
	dot -Tpng -o $*.png $*.preprocessed.dot

# Do not delete preprocessed so they can be inspected for debugging
.PRECIOUS: %.preprocessed.dot
