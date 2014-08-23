#!/usr/bin/env python

import argparse
import contextlib
import json
import sys
import urllib

TINSEL_VERSION = '0.2.0'

def expand_ribbon(cell):
    with open(cell['input']) as f:
        cell['cell_type'] = 'code'
        cell['language'] = 'r'
        cell['metadata']['ribbon'] = cell['input']

        cell['input'] = f.read()
    return cell

def expand_dataset(cell):
    format = cell['metadata']['format']

    if format == 'csv':
        cell['cell_type'] = 'code'
        cell['language'] = 'r'
        cell['metadata']['dataset'] = cell['input']

        cell['input'] = "{} <- read.csv('{}', header=TRUE, as.is=TRUE)".format(cell['metadata']['r_name'], cell['input'])
    return cell

#####

parser = argparse.ArgumentParser(description='tinsel')
parser.add_argument('-u', '--url', required=True)
parser.add_argument('-v', '--version', action='version',
                    version="%(prog)s {}".format(TINSEL_VERSION))
args = parser.parse_args()

with contextlib.closing(urllib.urlopen(args.url)) as response:
    control = json.load(response)

    cells = control['cells']
    for cell in cells:
        if cell['cell_type'] == 'ribbon':
            cell = expand_ribbon(cell)
        if cell['cell_type'] == 'dataset':
            cell = expand_dataset(cell)

    json.dump(control, sys.stdout, sort_keys=True, indent=4, separators=(',', ': '))
