# Improve interactive prompts by configuring readline. This is done by
# registering a custom hook as sys.__interactivehook__.
#
# If the readline module can be imported, the hook will:
#   1. Set the Tab key as completion key.
#   2. Initialize readline (e.g. from .inputrc).
#   3. Register a history file, using:
#       - $XDG_DATA_HOME/python/history if XDG_DATA_HOME iset
#       - .python_history otherwise.
def configure_readline():
    import atexit
    import os

    try:
        import readline
        import rlcompleter
    except ImportError:
        return

    # Reading the initialization (config) file may not be enough to set a
    # completion key, so we set one first and then read the file.
    readline_doc = getattr(readline, '__doc__', '')
    if readline_doc is not None and 'libedit' in readline_doc:
        readline.parse_and_bind('bind ^I rl_complete')
    else:
        readline.parse_and_bind('tab: complete')

    try:
        readline.read_init_file()
    except OSError:
        # An OSError here could have many causes, but the most likely one
        # is that there's no .inputrc file (or .editrc file in the case of
        # Mac OS X + libedit) in the expected location.  In that case, we
        # want to ignore the exception.
        pass

    if readline.get_current_history_length() == 0:
        # If no history was loaded, default to .python_history.
        # The guard is necessary to avoid doubling history size at
        # each interpreter exit when readline was already configured
        # through a PYTHONSTARTUP hook, see:
        # http://bugs.python.org/issue5845#msg198636

        history = os.path.join(os.path.expanduser('~'), '.python_history')
        if 'XDG_DATA_HOME' in os.environ:
            history = os.path.join(os.environ['XDG_DATA_HOME'], 'python', 'history')

        try:
            readline.read_history_file(history)
        except OSError:
            pass

        def write_history():
            try:
                history_dir = os.path.dirname(history)
                if not os.path.isdir(history_dir):
                    os.makedirs(history_dir)

                readline.write_history_file(history)
            except (FileNotFoundError, PermissionError, OSError):
                # history file does not exist or is not writable
                # https://bugs.python.org/issue19891
                pass

        atexit.register(write_history)

import sys
sys.__interactivehook__ = configure_readline
del sys, configure_readline  # we don't want any of this in globals()
