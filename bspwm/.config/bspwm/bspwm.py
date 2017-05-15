'''A module for interacting with the bspwm X window manager'''
import subprocess
import json


def subscribe(*subscribe_args):
    '''Returns a generator for messages from a 'bspc subscribe' call.'''
    proc = subprocess.Popen(['bspc', 'subscribe'] + list(subscribe_args),
                            stdout=subprocess.PIPE)
    while proc.poll() is None:
        yield from proc.stdout


def bspc(*bspc_args):
    '''Run the bspc command-line tool'''
    return subprocess.run(['bspc'] + list(bspc_args))


def get_state():
    '''Returns bspwm's global state JSON object'''
    proc = subprocess.run(['bspc', 'wm', '-d'], stdout=subprocess.PIPE)
    return json.loads(proc.stdout)
