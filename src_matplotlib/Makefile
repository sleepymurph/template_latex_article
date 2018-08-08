#======================================================================
# Makefile: Plots with Python and Matplotlib
#
# To create a new Matplotlib diagram
#
# 1. Put data files in the `data/` directory.
#
# 2. Choose a naming convention that identifies different formats of data to go
#    with different processors. For example, `*_multimeter.csv` for multimeter
#    data that will be processed with the multimeter plotting script.
#
# 3. Write a Python script to transform data into a plot (the hard part).
#
# 4. Use Pipenv when adding Python dependencies to your script. For example:
#
#         pipenv install matplotlib
#
# 5. Use your naming convention to create a generic Make rule for different
#    formats of data. See the generic rules below for inspiration.
#
# 6. Add a PDF-version of that name to the `GENERATED` variable.
#
# 7. Include the generated PDF in your LaTeX document (be sure to reference the
#    version that is copied to the generated_components/ directory).
#

GENERATED=\
	example_data_multimeter.pdf \

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


# Tell pipenv to put its virtual environment in the project directory,
# so that we can more easily check that its there
export PIPENV_VENV_IN_PROJECT=1

# The virtual environment
.venv: Pipfile Pipfile.lock
	pipenv install

# Generic rule to use the multimeter script to plot multimeter data
# If there is an additional *_multimeter_yhl.csv file,
# it will be used for extra y-axis labels
%_multimeter.pdf: .venv plot_multimeter_data.py \
    ../data/%_multimeter.csv \
    ../data/%_multimeter_yhl.csv
	pipenv run ./plot_multimeter_data.py \
	    ../data/$*_multimeter.csv \
	    --yhl ../data/$*_multimeter_yhl.csv \
	    $*_multimeter.pdf

# Generic rule to use the multimeter script to plot multimeter data
# (No additional *_multimeter_yhl.csv file)
%_multimeter.pdf: .venv plot_multimeter_data.py \
    ../data/%_multimeter.csv
	pipenv run ./plot_multimeter_data.py \
	    ../data/$*_multimeter.csv \
	    $*_multimeter.pdf
