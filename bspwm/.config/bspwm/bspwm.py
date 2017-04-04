'''A module for interacting with the bspwm X window manager'''
import subprocess
import json


def subscribe(subscribe_args=None):
    '''A generator that returns messages from a 'bspc subscribe' call.'''
    if subscribe_args is None:
        subscribe_args = []
    proc = subprocess.Popen(['bspc', 'subscribe'] + subscribe_args,
                            stdout=subprocess.PIPE)
    while proc.returncode is None:
        for line in proc.stdout:
            yield line
        proc.poll()


def get_state():
    '''Returns bspwm's global state JSON object'''
    output = subprocess.run(['bspc', 'wm', '-d'], stdout=subprocess.PIPE)
    return json.loads(output.stdout)
