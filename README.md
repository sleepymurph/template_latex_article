LaTeX Article Template
==================================================

This is a starter LaTeX article with many customizations that I use consistently.


## Building the Article PDFs

To build the article PDFs in a Docker-controlled environment with all dependencies:

    (cd article-latex-src/ && ./docker_make.sh render)

Be warned: A LaTeX installation (TeX Live) makes for a very large container, about 3 GB.
We have tried to separate container layers so that the container with just the base OS and TeX Live can be reused for other documents, but it is still going to take up a decent amount of space on your `/var/` partition.

See the [README file in the LaTeX source subdirectory](article-latex-src/README.md) for more build process information,
including instructions for cleaning up Docker images,
and faster build options for actively working on the document.


## Creating a new document from this skeleton

To base a new document off of this skeleton:

1. Clone this repository.
2. Edit `doc.tex` and change the title, author, and git URL
3. Write the document contents in `doc-content.tex`, `abstract.txt`, etc.
4. Edit `Makefile` and change `DOC_NAME` to the desired PDF file names
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


## Notes on the document skeleton


### Abstract in plain text

The abstract for the document comes from `abstract.txt`.
This file is deliberately in plain text so that it will be easier to copy-and-paste the abstract text elsewhere, without having to worry about TeX escapes for common characters like `%` and `&`.
If you do not need an abstract at all, simply delete the file, and the template will skip the abstract section entirely.


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


### The "final" option

This template is set up to obey the `final` option in the `\documentclass`.
There are many draft-only notes, annotations, and even sections that will
disappear when `final` is added.

I even define a several custom macros for draft-only (non-`final`) content.
See `macros-general.tex` for their definitions and `doc-content-example.tex` for examples of their use.


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

        # To include a diagram generated from diagram_example.dot
        DOC_DEPS=\
            diagram_example.pdf \
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


### Git Info

I give draft after draft to collaborators for feedback.
To make it easier to keep track of revisions, I have macros that include Git
information directly into the document.

There are a few important things to note about this Git information:

- It only lists changes inside the document source subdirectory.
    This is another advantage of keeping document source in subdirectories.
    More subdirectories can be included by editing the `DOC_SOURCE_DIRS` variable in the Makefile.

- The repository URL can be changed by editing the `\GitUrl` macro in `doc.tex`.
    Or just delete it if you don't have a repository URL.

- The history will not be included when the document is marked `final`.

To get a clean history in the document: commit the source directory, run `make`
again, and then commit the rendered PDF in the parent directory.

How it works is a little tricky:

1. The make process runs a script called `gen_meta_tex.sh` which extracts Git
   information and writes out a TeX file full of macros.

2. The document includes the generated TeX file and uses the macros.

3. The make process also generates the Git log as a plain text (`.txt`) file,
   and the document includes that as well. The history is a separate file
   because the `verbatim` package is tricky.
