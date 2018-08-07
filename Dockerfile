FROM ubuntu:xenial

# latex: basic texlive install
# Start with base texlive install as one layer, because it's huge
RUN apt-get update \
    && apt-get install -y \
            texlive \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/*

# build essentials
RUN apt-get update \
    && apt-get install -y \
            make \
            git \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/*

# latex: install extra texlive packages for this document
#
# texlive-bibtex-extra      needed for biblatex
# texlive-fonts-extra       needed for opensans
# texlive-generic-extra     needed for glossaries
# texlive-science           needed for siunitx
#
# To find what packages on your machine are missing here:
#
# 1) Make sure the build is working on your machine
# 2) Strip these dependencies
# 3) Run the Docker build, and find there TeX error for a missing .sty file
# 4) Plug that name into this command line:
#   dpkg -S $(find /usr/share/texlive/ -name tracklang.sty)
#
# 5) Watch out for package name changes between ubuntu versions
#
RUN apt-get update \
    && apt-get install -y \
            texlive-bibtex-extra \
            texlive-fonts-extra \
            texlive-generic-extra \
            texlive-science \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/*

# graphviz: install dependencies to build graphviz diagrams
RUN apt-get update \
    && apt-get install -y \
            graphviz \
            m4 \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/*

# matplotlib: install dependencies to build matplotlib plots
RUN apt-get update \
    && apt-get install -y \
            python3-pip \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/*

# Create a user
ENV UID 1000
RUN useradd --uid $UID --create-home --shell /bin/bash compile
USER compile

# matplotlib: install pipenv as the user
ENV PATH "/home/compile/.local/bin:${PATH}"
ENV LC_ALL "C.UTF-8"
RUN pip3 install --user pipenv

WORKDIR /home/compile/repo
