#!/usr/bin/env python

import argparse
import contextlib
import json
import sys
import urllib

TINSEL_VERSION = '0.2.0'

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
parser.add_argument('-u', '--url', required=True)
parser.add_argument('-n', '--notebook')
parser.add_argument('-d', '--document')
parser.add_argument('-r', '--render-document', action='store_true')
parser.add_argument('-v', '--version', action='version',
                    version="%(prog)s {}".format(TINSEL_VERSION))
args = parser.parse_args()

with contextlib.closing(urllib.urlopen(args.url)) as response:
    control = json.load(response)

    control['metadata']['tinsel_version'] = TINSEL_VERSION
    control['metadata']['tinsel_args'] = ' '.join(sys.argv[1:])

    worksheet = control['worksheets'][0]
    expand(worksheet)

    if args.notebook:
        with open(args.notebook, 'w') as notebook:
            json.dump(control, notebook, sort_keys=True, indent=2, separators=(',', ': '))

    if args.document:
        with open(args.document, 'w') as document:
            cell_inputs = gather(worksheet)
            for line in cell_inputs:
                document.write(line)

    # untested
    if args.document and args.render_document:
        import subprocess
        subprocess.check_call(
            ['R', '-e',
            "rmarkdown::render({}, output_format = 'html_document', output_dir = file.path(getwd(), 'tinsel'))".format(args.document)
            ])
