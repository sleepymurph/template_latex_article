# Master Makefile for document

default: latex


# The name of the main document (tex and pdf)
#
# pdflatex will be invoked with this name, meaning it will look for DOCNAME.tex
# and generate DOCNAME.pdf
#
export DOC_NAME=doc
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

# Update metadata in scripts after changing it above
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
