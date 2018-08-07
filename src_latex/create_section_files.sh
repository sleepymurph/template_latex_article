#!/bin/bash

# Helper script to generate separate files for document sections
#
# For each section heading given as an argument, the script will:
#
# 1. Create a section file for that section (lowercasing and hyphenating the heading)
# 2. Print an \input{} command for that file
#
# Example invocation:
#
# ./create_section_files.sh "Introduction" "Related Works" "Conclusions"
#
# Output:
#
# \input{doc-introduction.tex}
# \input{doc-related-works.tex}
# \input{doc-conclusions.tex}
#
# So to use this script:
#
# 1. Run with the desired sections as arguments
# 2. Copy and paste the resulting input commands into doc.tex
#

for SECTION in "$@"
do
    CODIFIED="$(echo "$SECTION" | tr "A-Z " "a-z-")"
    FILE="doc-$CODIFIED.tex"
    if [ ! -f "$FILE" ]
    then
        echo "\\section{$SECTION}" >> $FILE
        echo >> $FILE
        echo "\\towrite{$SECTION}" >> $FILE
    fi
    echo "\\input{$FILE}"
done
