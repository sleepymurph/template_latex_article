LaTeX Article Template
==================================================

<!-- From-Template TODO: Be sure to change this description -->
This is a starter LaTeX article with many customizations that I use consistently.

<!-- From-Template TODO: Be sure to change all "article-" file names
    if you changed the generated names in the Makefile -->

## To view the article

To view the article in its "final" form, see [article-final.pdf](article-final.pdf)

## To work on or collaborate on the article

To view the article with draft annotations turned on, see
[article-draft.pdf](article-draft.pdf)

See the [`article-latex-src/` source directory](article-latex-src/)
and especially [its `README` file](article-latex-src/README.md)
for information on rebuilding the PDF from source.


<!-- From-Template TODO: Delete everything below here -->

## To create a new document from this skeleton

To base a new document off of this skeleton:

1. Clone this repository.
2. Edit `Makefile` and change `DOC_NAME` to the desired PDF file names
3. Edit `doc.tex` and change the title, author, and git URL
4. Write the document contents in `doc-content.tex`, `abstract.txt`, etc.
5. Edit the `Makefile` to add any document-specific build rules
6. Edit the `Dockerfile` to change build environment dependencies
7. Replace this README with your own


## Why a document skeleton? Why not a Package?

Because I have barely scratched the surface of TeX/LaTeX and I definitely
don't know enough about how packaging works.

I've also had experience with a custom LaTeX document class that did too much.
It brought in so many packages that it clashed with many of the packages I tried to use,
which added another layer of difficulty to working with the document.

This is the nice and lazy way for now:
copy my usual customizations,
but then tweak them as needed for each individual document.


## Notes on this document skeleton


### Font: Open Sans

[Open Sans](https://fonts.google.com/specimen/Open+Sans)
is the official font at the university where I work.
Therefore it is the default font for my templates.

This means that this template requires the
[`opensans` package for LaTeX](https://ctan.org/pkg/opensans).
On Ubuntu this package is part of the
[`texlive-fonts-extra` package](https://packages.ubuntu.com/xenial/texlive-fonts-extra).

    apt install texlive-fonts-extra

Or you can use a different font by editing the `packages.tex` file.
The font packages are near the top.


### US English, A4 paper

I am an American living in Norway.
I write in US English, but I want the European paper size.
In theory I should be able to set up my locales for all of that to happen
automatically, but I haven't managed to figure it out yet.
For now, I just use the `a4paper` option in the main `\documentclass` macro.
If you need to change that, find it at the top of `doc.tex`.

There may be a few more Europe-friendly tweaks to my styles.
For example, I set the `biblatex` package to print dates like "Apr. 7, 2017"
instead of the "04/07/2017" to avoid any possible confusion over MDY vs DMY.


### Graphviz Diagrams

I love Graphviz.
I use it for all kinds of diagrams and visualizations.
So I have it built into the document build process here.

To use Graphviz:

1. Add dot files in the source directory

2. Add the dot file name to the `DOC_DEPS` variable in the Makefile,
    but with a PDF extension

        # To include a diagram generated from example_graphviz_diagram.dot
        DOC_DEPS=\
            example_graphviz_diagram.pdf \
            another_diagram.pdf \

3. Create a figure in the document


#### M4 preprocessing for Graphviz diagrams

The build process runs the diagrams through the `m4` preprocessor first,
then through `dot`.
This lets you use macros in your Graphviz files to define common styles
and other shortcuts.

For example, this macro defines `TENTATIVE` as a shortcut for `style="dashed'`
to create a reusable link style:


    define(TENTATIVE, `style="dashed"')

    digraph{
        hello -> world [TENTATIVE]
        world -> "!" [TENTATIVE]
    }

This layer of indirection can make debugging tricky.
So the intermediate build step is explicit.
The result of M4 expansion will be written to a file with a
`.preprocessed.dot` extension.
This file can be checked for syntax errors and unexpected macro trouble.

Common macros for many diagrams can be put in `diagram_common.m4.dot`.
This file name is specified in the `DOT_INCLUDE` Makefile variable,
if you need to change it.
