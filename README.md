LaTeX Article Source Code
==================================================

<!-- From-Template TODO: Be sure to change this description -->
This is a starter LaTeX article with many customizations that I use consistently.


Building the Document
--------------------------------------------------

The build for this document is controlled by GNU Make. If you have the proper
dependencies installed, you should be able to run `make` To generate the
document PDF.

There is also a [Dockerfile](Dockerfile) which describes a Docker container
with all necessary dependencies. If you have Docker installed and set up
correctly, the `docker_make.sh` script will run the `make` build in a
container.

    # Build the document (default)
    make

    # Build the document in a container
    ./docker_make.sh

    # Run the clean target (remove temporary files)
    make clean

    # Run the clean target in a container
    ./docker_make.sh clean

**Warning: 3 GB container.**
Note that installing a full LaTeX environment inside a container makes
for a huge container (~3 GB).
Be sure you have plenty of room in your /var/ partition,
or wherever you have configured Docker to store your containers.
Run `docker_cleanup.sh` to reclaim space.

    # Delete the container image and purge all dangling containers
    ./docker_cleanup.sh

See the [top-level Makefile](Makefile) for additional targets.


Build Modules
--------------------------------------------------

This build is designed to be broken into modules.

- The [top-level Makefile](Makefile) controls the build over-all.
- LaTeX source for the document is in the [`src_latex/`](src_latex) directory.
- Parts of the document that need to be built with other systems go in their
    own `src_*/` directories.

### Stripping everything but LaTeX from the build process

The main idea here is that the core LaTeX part of the build should be as close
as possible to the standard pdflatex-bibtex-pdflatex-pdflatex invocation as
possible. This way, collaborators and publication editors can tweak it and
build it in a familiar manner if need be.

To strip the build process to a bare-bones pdflatex invocation:

1. Include the generated document components in the `generated_components/`
    directory in the bundle.

    Commit them with `git add -f generated_components/*`,
    or simply make sure they're included in any bundles you send out.

2. Edit the [top-level Makefile](Makefile)'s `latex`
    target to skip the subsystems you want it to skip.


After that, you should not have to worry about any of the following subsystems.


### Git Metadata (`src_git_metadata/`)

This document includes a macro that adds Git metadata to the document when it's
not in `final` mode.

Ubuntu dependencies: `apt install git`

How it works:

1. The Makefile runs scripts that query Git and write metadata to
    various .tex and .txt files

2. A TeX macro, `\documenthistory`, reads the generated files and inserts the
   info into the LaTeX document.

See the [src_git_metadata/Makefile](src_git_metadata/Makefile) for details,
and see
[src_latex/macros_general.tex](src_latex/macros_general.tex)
for the definition for the `\documenthistory` macro.


### Graphviz Diagrams (`src_graphviz/`)

Graphviz (<https://www.graphviz.org/>)
is a language for generating diagrams where bubbles point to each other.

Ubuntu dependencies: `apt install graphviz m4`

To create a new Graphviz diagram:

1. Create a Graphviz file (e.g. my_diagram.dot)

2. Edit [src_graphviz/Makefile](src_graphviz/Makefile) and add a PDF-version of
   that name to the `GENERATED` variable:

        GENERATED=\
            example_graphviz_diagram.pdf \
            my_diagram.pdf \

3. Include the generated PDF in your LaTeX document (be sure to reference the
   version that is copied to the generated_components/ directory):

        \includegraphics[width=0.5\textwidth]{../generated_components/my_diagram.pdf}

Note that this build process runs the Graphviz documents through the
[M4 macro processor](https://www.gnu.org/software/m4/m4.html)
before sending them to `dot`.
This lets you use macros in your Graphviz files to define common styles
and other shortcuts.
However, it can make debugging trickier.
To see the preprocessed output, look at the `*.preprocessed.dot` files in the
subdirectory.

See the [src_graphviz/Makefile](src_graphviz/Makefile) for details.


Document Template
--------------------------------------------------

This document and build process is based on a template/skeleton
by Michael Murphy
at the UiT The Arctic University of Norway.

The template is available on GitHub at
<https://github.com/sleepymurph/template_latex_article>


<!-- From-Template TODO: Delete everything below here -->

### To create a new document from this skeleton

To base a new document off of this skeleton:

1. Clone this repository.
2. Rename the main tex file `src_latex/doc.tex` to something more descriptive.
3. Edit the top-level Makefile and change the `DOC_NAME` variable to match your main .tex file name.
4. Change the `REPO_HUB_URL` as well.
5. Run `make metadata_update` to propagate this metadata to other helper scripts.
6. Dig into the code and write your document.
    Start with the former doc.tex, the top-level Makefile, and the top-level Dockerfile
    to get your bearings.


## Why a document skeleton? Why not a Package?

Because I have barely scratched the surface of TeX/LaTeX and I definitely
don't know enough about how packaging works.

I've also had experience with a custom LaTeX document class that did too much.
It brought in so many packages that it clashed with many of the packages I tried to use,
which added another layer of difficulty to working with the document.

This is the nice and lazy way for now:
copy my usual customizations,
but then tweak them as needed for each individual document.
