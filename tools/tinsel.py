#!/usr/bin/env python

import argparse
import contextlib
import json
import os
import subprocess
import sys
import urllib

TINSEL_VERSION = '0.3.1'

def tag_cell(cell, cell_type):
    cell['metadata']['tinsel_input'] = cell['input']
    cell['metadata']['tinsel_type'] = cell_type
    return cell

def expand_ribbon(cell):
    with open(cell['input']) as f:
        cell = tag_cell(cell, 'ribbon')
        cell['cell_type'] = 'code'
        cell['language'] = 'r'
        cell['input'] = f.readlines()
        cell['outputs'] = list()
    return cell

def expand_dataset(cell):
    format = cell['metadata']['format']

    if format == 'csv':
        cell = tag_cell(cell, 'dataset')
        cell['cell_type'] = 'code'
        cell['language'] = 'r'
        cell['input'] = "{} <- read.csv('{}', header=TRUE, as.is=TRUE)\n".format(cell['metadata']['r_name'], cell['input'])
        cell['outputs'] = list()
    return cell

def expand_generic(cell):
    with open(cell['input']) as f:
        cell = tag_cell(cell, cell['cell_type'])
        cell['source'] = f.readlines()
        cell.pop('input', None)

def expand(worksheet):
    cells = worksheet['cells']

    for cell in cells:
        if cell['cell_type'] == 'ribbon':
            cell = expand_ribbon(cell)
        elif cell['cell_type'] == 'dataset':
            cell = expand_dataset(cell)
        else:
            cell = expand_generic(cell)

def gather(worksheet):
    cells = worksheet['cells']
    cell_inputs = []

    for cell in cells:
        if cell['cell_type'] == 'code':
            cell_inputs += ["```{{{} echo={}}}\n".format(cell['language'], 'TRUE')]
            cell_inputs += cell['input']
            cell_inputs += ["```\n"]
        elif cell['cell_type'] == 'heading':
            cell_inputs += ["{} {}".format("#" * cell['level'], cell['source'])]
        else:
            cell_inputs += cell['source']

    return cell_inputs

#####

parser = argparse.ArgumentParser(description='tinsel')
parser.add_argument('-c', '--config', required=True)
parser.add_argument('-n', '--notebook-out')
parser.add_argument('-o', '--source-out', required=True)
parser.add_argument('-v', '--version', action='version',
                    version="%(prog)s {}".format(TINSEL_VERSION))
args = parser.parse_args()

with contextlib.closing(urllib.urlopen(args.config)) as response:
    config = json.load(response)

    config['metadata']['tinsel_version'] = TINSEL_VERSION
    config['metadata']['tinsel_args'] = ' '.join(sys.argv[1:])

    worksheet = config['worksheets'][0]
    expand(worksheet)

    if args.notebook_out:
        with open(args.notebook_out, 'w') as notebook:
            json.dump(config, notebook, sort_keys=True, indent=2, separators=(',', ': '))

    with open(args.source_out, 'w') as source:
        cell_inputs = gather(worksheet)
        for line in cell_inputs:
            source.write(line)
