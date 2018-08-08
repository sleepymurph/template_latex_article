#!/usr/bin/env python3

import matplotlib as mpl
mpl.use("pdf")

import matplotlib.pyplot as plt
import numpy as np
import cycler

import argparse
import sys
import csv
import datetime


# First line of file that real data appears on (1-indexed)
firstdataline = 20

def build_argparser():
    parser = argparse.ArgumentParser(
            description="Plot multimeter data from CSV")

    parser.add_argument('infilename', type=str,
            help="CSV file to plot")

    parser.add_argument('--yhl', type=str,
            help="CSV file of y-axis highlights to label")

    parser.add_argument('outfilename', type=str,
            default="test.pdf",
            help="name of PDF file to output to")

    return parser

def parsetimestamp(ts):
    #ts = ts.decode("utf-8")
    parsed = np.datetime64(datetime.datetime.strptime(ts, "%H:%M:%S:%f"))
    return parsed

def maybeindex(haystack, needle):
    try:
        return haystack.index(needle)
    except ValueError:
        return None


if __name__ == "__main__":

    parser = build_argparser()
    args = parser.parse_args()

    currents = []
    times = []
    annotations = []

    with open(args.infilename) as csvfile:
        for i, line in enumerate(csvfile):
            if i < firstdataline - 1:
                continue
            values = line.strip().split(';')

            currents.append(values[0])
            times.append(values[3])
            annotations.append(values[4] if len(values) > 4 else "")

    special_currents = []
    if args.yhl:
        with open(args.yhl) as yhlfile:
            yhlvalues = csv.reader(yhlfile, delimiter=',', quotechar='"',
                    skipinitialspace=True)
            for row in yhlvalues:
                print(row)
                special_currents.append( (float(row[0]), row[1].strip()) )

    currents = np.array(currents)
    times = np.array(times)

    currents = np.vectorize(float)(currents)
    times = np.vectorize(parsetimestamp)(times)

    START = maybeindex(annotations, "START")
    if START != None:
        annotations[START] = ""
        currents = currents[START:]
        times = times[START:]
        annotations = annotations[START:]

    END = maybeindex(annotations, "END")
    if END != None:
        annotations[END] = ""
        currents = currents[:END+1]
        times = times[:END+1]
        annotations = annotations[:END+1]

    times = np.divide(times - times[0], np.timedelta64(1, 's'))
    currents = currents * 1000

    # Black and white output strategy, taken from
    # http://olsgaard.dk/monochrome-black-white-plots-in-matplotlib.html
    monochrome = (
            cycler.cycler('color', ['k'])
            * cycler.cycler('linestyle', ['-', '--', ':', '=.'])
            * cycler.cycler('marker', ['', '^',',', '.'])
            )

    fig, ax = plt.subplots()
    fig.set_size_inches(fig.get_size_inches()*.80)
    ax.set_prop_cycle(monochrome)
    ax.plot(times, currents)

    ax.set(
            xlabel='time (s)',
            ylabel='current (mA)',
           )
    ax.set_ylim([-25,550])
    ax.grid(color="black", alpha=.20)

    for i,ann in enumerate(annotations):
        if ann:
            ax.axvline(x=times[i], color='black', linestyle='dotted')
            ax.annotate(ann,
                    xycoords="data", xy=(times[i], currents[i]),
                    textcoords=("offset points","axes fraction"), xytext=(3,.98),
                    horizontalalignment="left",
                    verticalalignment="top",
                    rotation=90,
                    )
            print(i, ann)

    for ma, ann in special_currents:
        ax.axhline(ma, color='black', linestyle='dotted')
        ax.annotate("{:>3}".format(ma),
                xycoords=("axes fraction","data"), xy=(1, ma),
                textcoords="offset points", xytext=(3, 0),
                horizontalalignment="left",
                verticalalignment="center",
                )
        ax.annotate(ann,
                xycoords=("axes fraction","data"), xy=(1, ma),
                textcoords="offset points", xytext=(-3, 3),
                horizontalalignment="right",
                verticalalignment="bottom",
                )

    fig.savefig(args.outfilename)
