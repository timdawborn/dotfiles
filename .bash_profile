#!/bin/bash

# If not running interactively, don't do anything.
if [ -z "${PS1}" ]; then
  return
fi

# Usage: pathremove /path/to/bin [PATH]
# e.g. to remove ~/bin from $PATH: pathremove ~/bin PATH
function pathremove {
  local IFS=':'
  local NEWPATH
  local DIR
  local PATHVARIABLE=${2:-PATH}
  for DIR in ${!PATHVARIABLE} ; do
    if [[ "${DIR}" != "${1}" ]] ; then
      NEWPATH="${NEWPATH:+${NEWPATH}:}${DIR}"
    fi
  done
  export ${PATHVARIABLE}="${NEWPATH}"
}


# Usage: pathprepend /path/to/bin [PATH]
# e.g. to prepend ~/bin to $PATH: pathprepend ~/bin PATH
function pathprepend {
  pathremove "${1}" "${2}"
  [ -d "${1}" ] || return
  local PATHVARIABLE="${2:-PATH}"
  export ${PATHVARIABLE}="${1}${!PATHVARIABLE:+:${!PATHVARIABLE}}"
}


# Usage: pathappend /path/to/bin [PATH]
# e.g. to append ~/bin to $PATH: pathappend ~/bin PATH
function pathappend {
  pathremove "${1}" "${2}"
  [ -d "${1}" ] || return
  local PATHVARIABLE=${2:-PATH}
  export $PATHVARIABLE="${!PATHVARIABLE:+${!PATHVARIABLE}:}${1}"
}


# =============================================================================
# =============================================================================
# Add additional paths to PATH.
for p in /usr/local/bin /usr/local/sbin /usr/local/share/npm/bin ${HOME}/bin /usr/local/texlive/2012/bin/x86_64-darwin ${HOME}/.rvm/bin; do
  [ -r ${p} ] && pathprepend ${p} PATH
done

# Function to execute to construct the value of PS1.
function prompt_command {
  local here="${PWD}"
  local ve=""
  local host_colour="1;33m"
  [[ "$(uname)" == "Darwin" ]] && host_colour="1;34m"
  [[ "${PWD:0:${#HOME}}" == "${HOME}" ]] && here="~${PWD:${#HOME}}"
  [ ! -z "${VIRTUAL_ENV}" ] && ve="($(basename ${VIRTUAL_ENV}))"
  PS1="${ve}\[\033[1;30m\]\t\[\033[0m\] \[\033[${host_colour}\]\u@\h\[\033[0m\] \[\033[1;35m\]\W\[\033[0m\]\$ "
}
PROMPT_COMMAND=prompt_command

# OS specific settings.
case "$(uname)" in
Darwin)
  alias ls='ls -pG'
  alias top='top -ocpu -Otime'
  export JAVA_HOME="/System/Library/Frameworks/JavaVM.framework/Versions/CurrentJDK/Home"
  export LSCOLORS="exFxcxdxbxegedabagacad"
  export ARCHFLAGS="-arch x86_64"
  ;;
*)
  alias ls='ls -p --color'
  mkdir -p /tmp/tim
  ;;
esac

# Aliases.
alias egrep='egrep --color'
alias grep='grep --color'
alias l='ll'
alias less='less -R'
alias ll='ls -lahF'

# Environment veriables.
export EDITOR='vim'
export HISTCONTROL='ignoredups'
export PAGER='less'
export PYTHONSTARTUP="${HOME}/.pythonrc.py"
export TEXINPUTS=".:${HOME}/repos/tex//:"

# Bash completion.
[ -r /etc/bash_completion ] && source /etc/bash_completion
$(which brew > /dev/null) && [ -r $(brew --prefix)/etc/bash_completion ] && source $(brew --prefix)/etc/bash_completion

# Load RVM bash functions.
[ -s ${HOME}/.rvm/scripts/rvm ] && source ${HOME}/.rvm/scripts/rvm
