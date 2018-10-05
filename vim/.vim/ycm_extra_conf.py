'''
A generic YouCompleteMe config file that automatically generates include flags
when imported. The include flags can ignore any files in a .gitignore.
'''
import os
from glob import iglob, glob
from contextlib import contextmanager


@contextmanager
def working_directory(new_dir):
    '''Changes directory for the duration of the context then changes back'''
    orig_dir = os.getcwd()
    try:
        os.chdir(new_dir)
        yield
    finally:
        os.chdir(orig_dir)


def read_gitignore(base_dir):
    '''Returns a list of all files matched by patterns in a .gitignore'''
    with working_directory(base_dir):
        if not os.path.isfile('./.gitignore'):
            return set()
        with open('./.gitignore') as file:
            lists_of_files = (glob(line.strip()) for line in file.readlines()
                              if not line.strip().startswith('#'))
            return set(sum(lists_of_files, []))


def get_all_header_files(base_dir):
    '''Returns a set of all header files found below base_dir'''
    with working_directory(base_dir):
        return set(iglob('**/*.h*', recursive=True))


def get_include_flags(base_dir, use_gitignore=True):
    '''Generate a list of "-I" include flags'''
    header_files = get_all_header_files(base_dir)

    if use_gitignore:
        ignored_files = read_gitignore(base_dir)
    else:
        ignored_files = set()

    return list(set(f'-I{os.path.dirname(header)}'
                    for header in header_files - ignored_files))


THIS_SCRIPTS_DIRECTORY = os.path.dirname(os.path.abspath(__file__))
FLAGS = [
    '-Wall',
    '-Wextra',
    # '-Werror',
    '-x',
    'c++',
    '--std=c++11'
] + get_include_flags(THIS_SCRIPTS_DIRECTORY, use_gitignore=True)


# YCM's API call
def FlagsForFile(filename, **kwargs):
    return {
        'flags': FLAGS,
        'include_paths_relative_to_dir': THIS_SCRIPTS_DIRECTORY
    }


if __name__ == '__main__':
    # For quick debugging
    for flag in FLAGS:
        print(flag)
