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
        cell['input'] = "{} <- read.csv('{}', header=TRUE, as.is=TRUE)".format(cell['metadata']['r_name'], cell['input'])
        cell['outputs'] = list()
    return cell

def expand_generic(cell):
    with open(cell['input']) as f:
        cell = tag_cell(cell, cell['cell_type'])
        cell['source'] = f.readlines()
        cell.pop('input', None)

#####

parser = argparse.ArgumentParser(description='tinsel')
parser.add_argument('-u', '--url', required=True)
parser.add_argument('-v', '--version', action='version',
                    version="%(prog)s {}".format(TINSEL_VERSION))
args = parser.parse_args()

with contextlib.closing(urllib.urlopen(args.url)) as response:
    control = json.load(response)

    control['metadata']['tinsel_version'] = TINSEL_VERSION
    control['metadata']['tinsel_args'] = ' '.join(sys.argv[1:])

    worksheet = control['worksheets'][0]
    cells = worksheet['cells']

    for cell in cells:
        if cell['cell_type'] == 'ribbon':
            cell = expand_ribbon(cell)
        elif cell['cell_type'] == 'dataset':
            cell = expand_dataset(cell)
        else:
            cell = expand_generic(cell)

    json.dump(control, sys.stdout, sort_keys=True, indent=2, separators=(',', ': '))
    print '\n'
