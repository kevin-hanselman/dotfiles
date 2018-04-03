'''A module for interacting with the bspwm X window manager'''
from subprocess import Popen, PIPE, run, TimeoutExpired
import json


def __process_stdout_generator(proc):
    '''Create a generator for a Popen object's STDOUT'''
    while proc.poll() is None:
        yield from proc.stdout


def subscribe(*subscribe_args, timeout=0.1):
    '''Returns a generator for messages from a 'bspc subscribe' call.'''
    cmd = ['bspc', 'subscribe'] + list(subscribe_args)

    # Check to make sure the command won't error-out immediately
    try:
        run(cmd, check=True, timeout=timeout)
    except TimeoutExpired:
        pass

    return __process_stdout_generator(Popen(cmd, stdout=PIPE))


def bspc(*bspc_args):
    '''Run the bspc command-line tool'''
    return run(['bspc'] + list(bspc_args), stdout=PIPE)


def get_state():
    '''Returns bspwm's global state JSON object'''
    proc = bspc('wm', '-d')
    return json.loads(proc.stdout)
