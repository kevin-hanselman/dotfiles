#!/usr/bin/env python
'''Increase padding on bspwm desktops with only one node (a.k.a. window)'''
import bspwm


def auto_pad(*, vpad_scale, hpad_scale):
    '''Auto-pad bspwm desktops with only one node

    Parameters:
        (h/v)pad_scale: size of padding as a fraction of screen width/height
    '''
    bspwm_state = bspwm.get_state()
    focused_desktop_ids = [mon['focusedDesktopId']
                           for mon in bspwm_state['monitors']]

    focused_desktops_first = sorted(get_all_desktops(bspwm_state),
                                    key=lambda id: id in focused_desktop_ids,
                                    reverse=True)

    for desktop in focused_desktops_first:
        # Get all clients (open windows) on the desktop.
        # NOTE: Sometimes there are null-valued clients. Why?
        clients = find_keys(desktop, 'client')

        # Count the number of windows in the desktop that are tiled.
        # (i.e. Ignore floating windows, etc.)
        # Using timeit,
        # len(list(<generator>)) was slightly faster than
        # len(tuple(<generator>)) and much faster than
        # sum(1 for _ in <generator>)
        num_tiled_clients = len(list(c for c in clients
                                     if c and c['state'] == 'tiled'))
        padding = None
        if num_tiled_clients == 1:
            if desktop['padding']['left'] == 0:
                hpad_size = int(desktop['root']['rectangle']['width']
                                * hpad_scale)
                vpad_size = int(desktop['root']['rectangle']['height']
                                * vpad_scale)
                padding = {'top_padding':    vpad_size,
                           'bottom_padding': vpad_size,
                           'left_padding':   hpad_size,
                           'right_padding':  hpad_size}
        else:
            padding = {'top_padding':    0,
                       'bottom_padding': 0,
                       'left_padding':   0,
                       'right_padding':  0}
        if padding:
            bspwm_set_padding(desktop['id'], padding)


def get_all_desktops(bspwm_state):
    '''Returns a flat list of all bspwm desktops'''
    return sum((mon['desktops'] for mon in bspwm_state['monitors']), [])


def bspwm_set_padding(desktop_id, padding_dict):
    '''Set the padding parameters of the given desktop_id'''
    for pad_str, pad_val in padding_dict.items():
        bspwm.bspc('config',
                   '-d', str(desktop_id),
                   pad_str, str(pad_val))


def find_keys(var, target_key):
    '''Recursively get the values of all instances of the target key'''
    # http://stackoverflow.com/q/9807634
    if hasattr(var, 'items'):
        for key, val in var.items():
            if key == target_key:
                yield val
            if isinstance(val, dict):
                yield from find_keys(val, target_key)
            elif isinstance(val, list):
                for list_val in val:
                    yield from find_keys(list_val, target_key)


if __name__ == '__main__':
    for _ in bspwm.subscribe('node_manage', 'node_unmanage', 'node_transfer'):
        auto_pad(vpad_scale=0.05, hpad_scale=0.2)
