#!/usr/bin/env python
'''Look for bspwm desktops with only one node
and increase left and right padding'''
import subprocess
import bspwm


def main():
    sub = bspwm.subscribe(['node_manage', 'node_unmanage', 'node_transfer'])
    for _ in sub:
        auto_pad()


def auto_pad():
    bspwm_state = bspwm.get_state()
    focused_desktop_ids = [mon['focusedDesktopId']
                           for mon in bspwm_state['monitors']]
    focused_desktops = [desktop for desktop in get_all_desktops(bspwm_state)
                        if desktop['id'] in focused_desktop_ids]

    for desktop in focused_desktops:
        num_nodes = len(list(find_keys(desktop, 'className')))
        if num_nodes == 1:
            if desktop['padding']['left'] == 0:
                horiz_pad = desktop['root']['rectangle']['width'] // 5
                vert_pad = desktop['root']['rectangle']['height'] // 10
                bspwm_set_padding(desktop['id'],
                                  {'top_padding': vert_pad,
                                   'bottom_padding': vert_pad,
                                   'left_padding': horiz_pad,
                                   'right_padding': horiz_pad})
        else:
            bspwm_set_padding(desktop['id'],
                              {'top_padding':    0,
                               'bottom_padding': 0,
                               'left_padding':   0,
                               'right_padding':  0})


def get_all_desktops(bspwm_state):
    '''Returns a flat list of all bspwm desktops'''
    return sum((mon['desktops'] for mon in bspwm_state['monitors']), [])


def bspwm_set_padding(desktop_id, padding_dict):
    '''Set the left and right padding of the given desktop_id to pad_pixels'''
    for pad_str, pad_val in padding_dict.items():
        subprocess.run(['bspc', 'config',
                        '-d', str(desktop_id),
                        pad_str, str(pad_val)])


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
    main()
