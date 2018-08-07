#======================================================================
# Makefile: Extrace metadata from Git to include in LaTeX document
#

default: doc-gen-meta.tex doc-git-log.txt

# List of directories that should be included when listing the Git history
DOC_SOURCE_DIRS=../src_*

#======================================================================
# Document version info (Git)
#

GIT_HEAD=$(shell git rev-parse --show-toplevel)/.git/logs/HEAD
DOC_SOURCE_FILES=$(shell git ls-files $(DOC_SOURCE_DIRS))

doc-gen-meta.tex: $(GIT_HEAD) $(DOC_SOURCE_FILES) gen_meta_tex.sh
	./gen_meta_tex.sh $(DOC_SOURCE_DIRS) > doc-gen-meta.tex

doc-git-log.txt: $(GIT_HEAD) $(DOC_SOURCE_FILES)
	git log --oneline --graph -n10 $(DOC_SOURCE_DIRS) > doc-git-log.txt
