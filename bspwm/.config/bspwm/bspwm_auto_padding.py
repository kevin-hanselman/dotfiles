#!/usr/bin/env python
"""Increase padding on bspwm desktops with only one node (a.k.a. window)."""
import sys
from time import time

import bspwm


def auto_pad(*, vpad_scale, hpad_scale):
    """Auto-pad bspwm desktops with only one node.

    Parameters:
        (h/v)pad_scale: size of padding as a fraction of screen width/height
    """
    focused_desktop = _get_focused_monitor_desktop(bspwm.get_state())

    num_clients = _count_tiled_clients_recursive(focused_desktop["root"])

    if num_clients == 1:
        hpad_size = int(focused_desktop["root"]["rectangle"]["width"] * hpad_scale)
        vpad_size = int(focused_desktop["root"]["rectangle"]["height"] * vpad_scale)
        padding = {
            "top_padding": vpad_size,
            "bottom_padding": vpad_size,
            "left_padding": hpad_size,
            "right_padding": hpad_size,
        }
    else:
        padding = {
            "top_padding": 0,
            "bottom_padding": 0,
            "left_padding": 0,
            "right_padding": 0,
        }

    _set_desktop_padding(focused_desktop["id"], padding)


def _count_tiled_clients_recursive(node):
    if node is None:
        return 0

    num_tiled_clients = 0
    if node["client"] and node["client"]["state"] == "tiled":
        num_tiled_clients = 1

    return (
        num_tiled_clients
        + _count_tiled_clients_recursive(node["firstChild"])
        + _count_tiled_clients_recursive(node["secondChild"])
    )


def _get_focused_monitor_desktop(state):
    focused_monitor = None
    for monitor in state["monitors"]:
        if monitor["id"] == state["focusedMonitorId"]:
            focused_monitor = monitor
            break
    for desktop in focused_monitor["desktops"]:
        if desktop["id"] == focused_monitor["focusedDesktopId"]:
            return desktop


def _set_desktop_padding(desktop_id, padding_dict):
    for pad_str, pad_val in padding_dict.items():
        bspwm.bspc("config", "-d", str(desktop_id), pad_str, str(pad_val))


if __name__ == "__main__":
    for _ in bspwm.subscribe("node_add", "node_remove", "node_transfer"):
        start = time()
        auto_pad(vpad_scale=0.05, hpad_scale=0.2)
        print(f"Elapsed time: {time() - start:.5g}")
        sys.stdout.flush()
