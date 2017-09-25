#!/usr/bin/python
from itertools import imap
from subprocess import check_output
import sys
import json


def print_line(message):
    """ Non-buffered printing to stdout. """
    sys.stdout.write(message + '\n')
    sys.stdout.flush()


for i, line in enumerate(imap(lambda l: l.strip(), iter(sys.stdin.readline, ''))):
    if i < 2:
        print_line(line.strip())
    else:
        output = check_output(['setxkbmap', '-query']).splitlines()
        current_layout = [l.split()[1] for l in output if l.startswith('layout:')][0]

        prefix = ''
        if line.startswith(','):
            line, prefix = line[1:], ','

        j = json.loads(line)
        j.append({
            'name' : 'kblayout',
            'instance' : 'current',
            'full_text': current_layout,
            'color' : '#00C0C0'
        })
        # insert information into the start of the json
        # and echo back new encoded json
        print_line(prefix + json.dumps(j))
