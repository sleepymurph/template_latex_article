#======================================================================
# Makefile: Extrace metadata from Git to include in LaTeX document
#

GENERATED=\
    git_metadata.tex \
    git_log.txt \
    git_short_hash.txt \

# List of directories that should be included when listing the Git history
DOC_SOURCE_DIRS=$(wildcard ../src_*)


#----------------------------------------------------------------------
# Default rule: generate all and copy to output directory
#
# 1. Create a list of generated file copies
# 2. The Make rule for the copies is to copy them.
# 3. The default rule is to make those copies.
#

GENERATED_COPIES=$(addprefix ../generated_components/, $(GENERATED))

$(GENERATED_COPIES): $(GENERATED)
	cp $(GENERATED) ../generated_components


#======================================================================
# Document version info (Git)
#

# Use Bash for shell to get <() syntax necessary for getting source files
SHELL:=/bin/bash

GIT_HEAD=$(shell git rev-parse --show-toplevel)/.git/logs/HEAD

# List all files tracked by Git, minus those that are deleted in workdir
DOC_SOURCE_FILES=$(shell \
		comm -23 \
			<(git ls-files $(DOC_SOURCE_DIRS) | sort) \
			<(git ls-files --deleted $(DOC_SOURCE_DIRS) | sort) \
		)

git_metadata.tex: $(GIT_HEAD) $(DOC_SOURCE_FILES) generate_git_metadata_tex.sh
	./generate_git_metadata_tex.sh $(DOC_SOURCE_DIRS) > git_metadata.tex
	echo "\gdef\GitUrl{\url{$(REPO_HUB_URL)}}" >> git_metadata.tex

git_log.txt: $(GIT_HEAD) $(DOC_SOURCE_FILES)
	git log --oneline --graph -n10 $(DOC_SOURCE_DIRS) > git_log.txt

git_short_hash.txt: $(GIT_HEAD)
	git log -n 1 --pretty=format:%h -- $(DOC_SOURCE_DIRS) > git_short_hash.txt
	echo >> git_short_hash.txt
