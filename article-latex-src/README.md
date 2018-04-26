LaTeX source code for article
==================================================

## Building the article PDFs

This build process is controlled by Make,
and there is a Docker file to create a container with all needed dependencies.

To render the draft and final PDFs in this directory via Docker:

    ./docker_make.sh render

This will build a Docker container, run the Make process, and copy both the draft and final PDFs out to the parent directory.


## To actively work on the document

The arguments to `docker_make.sh` are Make targets to run inside the container.
There are other targets available:

- `./docker_make.sh` (default):
    Builds `doc.tex` in this subdirectory, in draft mode

- `./docker_make.sh final`:
    Builds `doc-final.tex` in this subdirectory, in final mode

- `./docker_make.sh render`:
    Build both draft and final documents and copy them out into the parent directory

- `./docker_make.sh clean`:
    Remove temporary files

The idea here is to be able
to rapidly generate and view the document as you work on it
(`doc.pdf` and `doc-final.pdf`).
Then at stopping points,
you can commit rendered versions of the document for easier sharing with collaborators
(`../article-draft.pdf` and `../article-final.pdf`).

When committing the rendered PDFs to version control it is recommended to commit source changes first, then `make render` and then commit the new PDFs in a separate commit.
This will make it easier to merge, cherry-pick, and rearrange commits if needed without hitting conflicts from the changing binary PDF files that Git does not know how to merge.

Note that these are all Make targets.
If you install all necessary dependencies on your own machine, you can run Make directly: `make`, `make final`, `make clean render`, etc.
See the `Dockerfile` for necessary dependencies.


## Important files

```
Document skeleton:

    doc.tex             Main document skeleton
    packages.tex        LaTeX Package includes
    macros-general.tex  Macros that are part of this template

Document content:

    doc-content.tex     Place for document contents
    abstract.txt        Abstract (plain text), delete to remove abstract
    macros-doc.tex      Place for document-specific macros
    sources.bib         Bibliography database
    glossary.tex        Place for glossary entries

Build process and helpers:

    Makefile            Build process
    Dockerfile          Docker container description
    docker_make.sh      Helper script to run Make inside Docker
    gen_meta_tex.sh     Script that extracts Git information to include in document
    .gitignore          List of files for Git to ignore (TeX generates a lot of them)
    tmux-session-doc.sh Script to launch a tmux session for this document
```

## Cleaning up Docker

Be warned: A LaTeX installation (TeX Live) makes for a very large container (~3 GB).
We have tried to separate container layers so that the container with just the base OS and TeX Live can be reused, but it is still going to take up a decent amount of space on your `/var/` partition.

To remove the Docker image and reclaim space:

    # First remove the image
    docker rmi article-latex-src

    # Then clean up all dangling layers (list, then remove)
    docker images -f dangling
    docker images purge

Note that the docker image takes its name from the source directory.
So if you change the directory name, you must change the image name given in the `docker rmi` command.

For more information on cleaning up unused Docker resources,
Digital Ocean has an excellent tutorial, [How to Remove Docker Images, Containers, and Volumes](https://www.digitalocean.com/community/tutorials/how-to-remove-docker-images-containers-and-volumes).
