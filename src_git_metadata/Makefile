#======================================================================
# Makefile: Extrace metadata from Git to include in LaTeX document
#

default: generated_git_metadata.tex generated_git_log.txt

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

generated_git_metadata.tex: $(GIT_HEAD) $(DOC_SOURCE_FILES) generate_git_metadata_tex.sh
	./generate_git_metadata_tex.sh $(DOC_SOURCE_DIRS) > generated_git_metadata.tex

generated_git_log.txt: $(GIT_HEAD) $(DOC_SOURCE_FILES)
	git log --oneline --graph -n10 $(DOC_SOURCE_DIRS) > generated_git_log.txt
