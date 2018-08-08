#======================================================================
# Makefile: Diagrams with Graphviz
#
# To create a new Graphviz diagram...
#
# 1. Create a Graphviz file (e.g. my_diagram.dot)
#
# 2. Add a PDF-version of that name to the `GENERATED` variable:
#
# 3. Include the generated PDF in your LaTeX document (be sure to reference the
#    version that is copied to the generated_components/ directory):
#
#         \includegraphics[width=0.5\textwidth]{../generated_components/my_diagram.pdf}
#
# Note that this build process runs the Graphviz documents through the M4 macro
# processor (https://www.gnu.org/software/m4/m4.html) before sending them to
# dot. This lets you use macros in your Graphviz files to define common styles
# and other shortcuts. However, it can make debugging trickier. To see the
# preprocessed output, look at the '*.preprocessed.dot' files that are left
# behind.
#

GENERATED=\
    example_graphviz_diagram.pdf

DOT_INCLUDE=diagram_common.m4.dot

#----------------------------------------------------------------------
# Default rule: generate all and copy to output directory
#
# 1. Create a list of generated file copies
# 2. The Make rule for the copies is to copy them.
# 3. The default rule is to make those copies.
#

GENERATED_COPIES=$(addprefix ../generated_components/, $(GENERATED))

default: $(GENERATED_COPIES)

$(GENERATED_COPIES): $(GENERATED)
	cp $(GENERATED) ../generated_components


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

%.preprocessed.dot: %.dot $(DOT_INCLUDE)
	m4 $(DOT_INCLUDE) $*.dot > $*.preprocessed.dot

%.pdf: %.preprocessed.dot
	dot -Tpdf -o $*.pdf $*.preprocessed.dot

%.png: %.preprocessed.dot
	dot -Tpng -o $*.png $*.preprocessed.dot

# Do not delete preprocessed so they can be inspected for debugging
.PRECIOUS: %.preprocessed.dot
