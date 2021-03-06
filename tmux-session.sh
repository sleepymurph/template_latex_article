#!/bin/bash

set -x

browser_new_window() {
    # Start first arg in new window
    chromium-browser --new-window "$1"
    # Start rest as tabs
    shift
    browser $*
}

browser() {
    for URL do
        chromium-browser "$URL"
    done
}

SCRIPT_DIR="$( dirname "${BASH_SOURCE[0]}" | xargs readlink -f)"
REPO_ROOT_DIR="$(cd $SCRIPT_DIR && git rev-parse --show-toplevel)"


# -------------------------------------------
# ↓↓↓ Set project-specific variables here ↓↓↓

DOC_NAME=doc
REPO_HUB_URL=https://github.com/sleepymurph/template_latex_article

LATEX_SRC_DIR="$SCRIPT_DIR/src_latex"

SESSION_NAME="$DOC_NAME"
SESSION_DIR="$REPO_ROOT_DIR"

WINDOW_0_NAME="$SESSION_NAME"
WINDOW_0_DIR="$REPO_ROOT_DIR"

# ↑↑↑ ----------------------------------- ↑↑↑
# -------------------------------------------


# start tmux session
cd "$SESSION_DIR"
tmux new-session -d -s "$SESSION_NAME" -n "$WINDOW_0_NAME"
tmux select-window -t "$SESSION_NAME:0"
tmux send-keys "cd \"$WINDOW_0_DIR\"" C-m


# ------------------------------------------
# ↓↓↓ Customize session and windows here ↓↓↓

browser_new_window "$REPO_HUB_URL"

xdg-open "$LATEX_SRC_DIR/$DOC_NAME.pdf" &> /dev/null

# In window 0 ($WINDOW_0_DIR)
tmux send-keys "vim -O $LATEX_SRC_DIR/$DOC_NAME.tex $LATEX_SRC_DIR/packages.tex" C-m

# Open a new window with an elaborate vim tab/window layout
#tmux new-window -n "window_1" -c "window_1_dir/"
#tmux send-keys "vim doc.tex \
#    -c 'vsplit doc-content.tex' \
#    -c 'tabnew lecture-schedule.tex' \
#    -c 'botright split special-weeks.tsv' \
#    -c 'botright split lecture-schedule.tsv' \
#    -c 'exe \"normal 2\\<C-W>k\" | vsplit format_schedule.py' \
#    " C-m

# Link window from another session
#tmux link-window -d -s "dao:todo"

# ↑↑↑ ---------------------------------- ↑↑↑
# ------------------------------------------


# back to the beginning
tmux select-window -t "$SESSION_NAME:0"

# finally attach client
tmux attach-session
