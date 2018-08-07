#======================================================================
# Top-Level Makefile for document
#
# Everything that needs tools other than pdflatex and bibtex to build should be
# put in subsystems in src_*/ subdirectories.
#
# The main idea here is that the core LaTeX part of the build should be as
# close as possible to the standard pdflatex-bibtex-pdflatex-pdflatex
# invocation as possible. This way, collaborators and publication editors can
# tweak it and build it in a familiar manner if need be.
#
# To strip the build process to a bare-bones pdflatex invocation:
#
# 1. Include the generated document components in the `generated_components/`
#    directory in any bundle you distribute.
#
#     Commit them with `git add -f generated_components/*`, or simply make sure
#     they're included in any bundles you send out.
#
# 2. Edit the 'latex` target to skip the subsystems you want it to skip.
#

default: latex


#----------------------------------------------------------------------
# Essential metadata for the document
#

# DOC_NAME: The name of the main document (tex and pdf)
#
# pdflatex will be invoked with this name, meaning it will look for DOCNAME.tex
# and generate DOCNAME.pdf
#
# Run 'make metadata_update' to propagate these values to various helper
# scripts

export DOC_NAME=doc

# REPO_HUB_URL: The central hosted space for this repository
#
# The tmux script will open this URL in a browser window when started, and it
# will be embedded into the document by the git_metadata subsystem.

export REPO_HUB_URL=https://github.com/sleepymurph/template_latex_article


#----------------------------------------------------------------------
# Other high-level targets
#

clean:
	git clean -fXd .

# Create a date-stamped PDF to send to a collaborator
datestamp: clean latex
	cp src_latex/$(DOC_NAME).pdf $(DOC_NAME).$(shell date +%Y%m%d).pdf

# Create a date-and-git-hash-stamped PDF to send to a collaborator
gitstamp: clean git_metadata latex
	cp src_latex/$(DOC_NAME).pdf $(DOC_NAME).$(shell date +%Y%m%d).$(shell cat generated_components/git_short_hash.txt).pdf

# Propagate metadata to various helper scripts after changing it above
metadata_update: tmux-session.sh


#----------------------------------------------------------------------
# Build subsystems
#

latex: graphviz git_metadata matplotlib
	cd src_latex && $(MAKE)

graphviz:
	cd src_graphviz && $(MAKE)

git_metadata:
	cd src_git_metadata/ && $(MAKE)

matplotlib:
	cd src_matplotlib/ && $(MAKE)

#----------------------------------------------------------------------
# Scripts to update when high-level metadata changes
#

tmux-session.sh: Makefile
	sed -i "/^DOC_NAME=/cDOC_NAME=$(DOC_NAME)" tmux-session.sh
	sed -i "/^REPO_HUB_URL=/cREPO_HUB_URL=$(REPO_HUB_URL)" tmux-session.sh
