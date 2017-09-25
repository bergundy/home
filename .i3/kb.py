#!/usr/bin/python
from subprocess import check_output, check_call

layouts = ['us', 'il']

output = check_output(['setxkbmap', '-query']).splitlines()
current_layout = [l.split()[1] for l in output if l.startswith('layout:')][0]
next_layout = layouts[(layouts.index(current_layout) + 1) % len(layouts)]
check_call(['setxkbmap', next_layout])
