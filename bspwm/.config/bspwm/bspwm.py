'''A module for interacting with the bspwm X window manager'''
from subprocess import Popen, PIPE, run
import json


def subscribe(*subscribe_args):
    '''Returns a generator for messages from a 'bspc subscribe' call.'''
    proc = Popen(['bspc', 'subscribe'] + list(subscribe_args),
                 stdout=PIPE)
    while proc.poll() is None:
        yield from proc.stdout


def bspc(*bspc_args):
    '''Run the bspc command-line tool'''
    return run(['bspc'] + list(bspc_args), stdout=PIPE)


def get_state():
    '''Returns bspwm's global state JSON object'''
    proc = bspc('wm', '-d')
    return json.loads(proc.stdout)
