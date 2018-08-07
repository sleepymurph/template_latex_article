#======================================================================
# Makefile: Extrace metadata from Git to include in LaTeX document
#

GENERATED=\
    git_metadata.tex \
    git_log.txt \
    git_short_hash.txt \

default: copy_generated

# List of directories that should be included when listing the Git history
DOC_SOURCE_DIRS=../src_*

#======================================================================
# Document version info (Git)
#

# Use Bash for shell to get <() syntax necessary for getting source files
SHELL:=/bin/bash

GIT_HEAD=$(shell git rev-parse --show-toplevel)/.git/logs/HEAD

# List all files tracked by Git, minus those that are deleted in workdir
DOC_SOURCE_FILES=$(shell \
		comm -23 \
			<(git ls-files $(DOC_SOURCE_DIRS)| sort) \
			<(git ls-files --deleted $(DOC_SRC_DIRS)| sort) \
		)

copy_generated: $(GENERATED)
	cp $(GENERATED) ../generated_components

git_metadata.tex: $(GIT_HEAD) $(DOC_SOURCE_FILES) generate_git_metadata_tex.sh
	./generate_git_metadata_tex.sh $(DOC_SOURCE_DIRS) > git_metadata.tex

git_log.txt: $(GIT_HEAD) $(DOC_SOURCE_FILES)
	git log --oneline --graph -n10 $(DOC_SOURCE_DIRS) > git_log.txt

git_short_hash.txt: $(GIT_HEAD)
	git log -n 1 --pretty=format:%h -- $(DOC_SOURCE_DIRS) > git_short_hash.txt
	echo >> git_short_hash.txt
