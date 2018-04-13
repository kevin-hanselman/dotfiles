import re
from IPython.core.magic import register_line_magic

__OBJECT_REGEX = re.compile(r'[\w\.]+')


@register_line_magic
def h(line):
    '''Line magic shortcut for viewing the documentation for an object'''
    # Help harden against code injection attacks by only "eval"-ing a string
    # that looks like a non-executing object (e.g. no parentheses for calling
    # a function).
    match = re.match(__OBJECT_REGEX, line)
    if match:
        return help(eval(match[0]))
    else:
        print(f'help() line magic: Could not find object in {line!r}')


# From https://ipython.readthedocs.io/en/stable/config/custommagics.html:
# In an interactive session, we need to delete [local functions] to avoid
# name conflicts for automagic to work on line magics.
del h
