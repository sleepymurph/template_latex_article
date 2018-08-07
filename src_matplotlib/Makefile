#======================================================================
# Makefile: Plots with Python and Matplotlib
#

GENERATED=\
	example_data_multimeter.pdf \

default: $(GENERATED)
	cp $(GENERATED) ../generated_components

# Tell pipenv to put its virtual environment in the project directory,
# so that we can more easily check that its there
export PIPENV_VENV_IN_PROJECT=1

# The virtual environment
.venv: Pipfile Pipfile.lock
	pipenv install

# Generic rule to use the multimeter script to plot multimeter data
%_multimeter.pdf: .venv plot_multimeter_data.py \
    ../data/%_multimeter.csv
	pipenv run ./plot_multimeter_data.py \
	    ../data/$*_multimeter.csv \
	    $*_multimeter.pdf
