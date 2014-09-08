import atexit
import os
import readline
import rlcompleter

default_completer = rlcompleter.Completer(locals())

histfile = os.path.expanduser('~/.pyhistory')
histsize = 1000


def my_completer(text, state):
  if text.strip() == '' and state == 0:
    return text + '\t'
  else:
    return default_completer.complete(text, state)


def save_history(histfile=histfile, histsize=histsize):
  import readline
  readline.set_history_length(histsize)
  readline.write_history_file(histfile)


readline.set_completer(my_completer)
if 'libedit' in readline.__doc__:
  readline.parse_and_bind('bind ^I rl_complete')
else:
  readline.parse_and_bind('tab: complete')

if os.path.exists(histfile):
  readline.read_history_file(histfile)

atexit.register(save_history)

del rlcompleter, readline, atexit
