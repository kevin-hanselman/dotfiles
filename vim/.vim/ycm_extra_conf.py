import os
from glob import iglob


THIS_SCRIPTS_DIRECTORY = os.path.dirname(os.path.abspath(__file__))


def get_all_include_paths():
    orig_dir = os.getcwd()
    os.chdir(THIS_SCRIPTS_DIRECTORY)
    try:
        return list(set(f'-I{os.path.dirname(header)}'
                        for header in iglob('**/*.h*', recursive=True)))
    finally:
        os.chdir(orig_dir)


FLAGS = [
    '-Wall',
    '-Wextra',
    '-Werror',
    '-x',
    'c++',
    '--std=c++11'
] + get_all_include_paths()


# YCM's API call
def FlagsForFile(filename, **kwargs):
    return {
        'flags': FLAGS,
        'include_paths_relative_to_dir': THIS_SCRIPTS_DIRECTORY
    }


if __name__ == '__main__':
    print(FLAGS)
