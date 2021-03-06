# ~/.bashrc: executed by bash(2) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

#autojump.sh support
[[ -s /team/yizhang/bin/etc/profile.d/autojump.sh ]] && . /team/yizhang/bin/etc/profile.d/autojump.sh
export GIT_EDITOR=vim
export TERM=xterm
alias decode='java -cp ~/tools/ DecodeJitLog'
alias omr="pushd .; cd ../omr/compiler"
export PATH=~/kca/tr.kca/build/linux_x86/:$PATH
export PATH=/team/yizhang/bin:$PATH
export PATH=/team/yizhang/tools/sdk/bin/:$PATH
export PATH=/team/yizhang/tools/rtc/jazz/scmtools/eclipse/:$PATH
export PATH=/team/yizhang/bin/git/bin/:$PATH
export PATH=/team/yizhang/tools/autojump_v21.1.2/bin/:$PATH
export PATH=/team/yizhang/srccode/srcr14/tr.tools/rastools/:$PATH

eval `dircolors ~/.dir_colors`
alias ls="ls --color=auto"
# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

if [ "$HOSTNAME" == "yokel" ]; then
   return
fi

if [ "$HOSTNAME" == "arezzo" ]; then
   return
fi
# history setting  {{{
# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth
shopt -s histappend # append to the history file, don't overwrite it
shopt -s histverify # !X expands out first

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTFILE="$HOME/.bash_history"
HISTSIZE=100000
HISTFILESIZE=200000

# }}}

# misc {{{

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] \
    && echo terminal || echo error)" "$(history | tail -n1 | \
    sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
# }}}

# aliases {{{

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.


# }}}

# functions {{{
alias sb='ssh bowlcut'
__truncPwd() {
    pwd | sed "s:^$HOME:~:" | awk -F/ '{print (NF<=3)?$0:$(NF - 1)"/"$NF}'
}

source() {
    builtin source ${@:-"${HOME}/.bashrc"}
}

# }}}

# Add git branch if its present to PS1
parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
 }
# prompt {{{
__prompt_command() {
    # set the error code
    local PS1_ERRNO=" "$?
    local PS1_TAIL=""

    if [ ${PS1_ERRNO} -eq 0 ]; then
        local PS1_ERRNO=""
        local LINE_COLOR='\[\033[00m\]'
        local PS1_TAIL+='\[\033[01;35m\]'
    else
        local LINE_COLOR='\[\033[01;31m\]'
        local PS1_TAIL+='\[\033[01;31m\]'
    fi
    local PS1_TAIL+='\$ \[\033[00m\]'

    # initialise all the required variables
    local PS1_HOST=$(echo -n $HOSTNAME | cut -d'.' -f1)
    [ "$SSH_CLIENT" ] && local PS1_HAS_SSH='(ssh)'

    #TODO: truncate directory if required
    local PS1_CWD=$(pwd | sed "s:^$HOME:~:")

    # print the username and hostname
    local PS1_TOP=${LINE_COLOR}'┌─┤ \[\033[00;32m\]'${USER}
    local PS1_TOP+=${LINE_COLOR}'@\[\033[00;34m\]'${PS1_HOST}
    local PS1_TOP+='\[\033[0;1m\]'${PS1_HAS_SSH}${LINE_COLOR}'$(parse_git_branch)├'
    PS1_GIT='$(parse_git_branch)'

    # fill the line until the end
    local PS1_TOP_LEN=$((${#USER}+${#PS1_HOST} + ${#PS1_CWD} + \
                        ${#PS1_HAS_SSH} + ${#PS1_ERRNO} + ${#PS1_GIT} + 15-7))
    local PS1_FILL_SIZE=$((${COLUMNS} - ${PS1_TOP_LEN}))
    [ ${PS1_FILL_SIZE} -gt 0 ] || PS1_FILL_SIZE=1
    local PS1_TOP+=${LINE_COLOR}
    while ((PS1_FILL_SIZE)); do
        local PS1_TOP+='─'
        ((PS1_FILL_SIZE=PS1_FILL_SIZE - 1))
    done

    # print the working directory
    local PS1_TOP+="\[┤\]"${PS1_GIT_COLOR}${PS0_GIT}
    local PS1_TOP+='\[\033[00m\]'${PS1_CWD}' '${LINE_COLOR}'├──┤'${PS1_ERRNO}
    local PS1_TOP+='\[\033[00m\]'

    #PS1="${PS1_TOP}\n${LINE_COLOR}└─ ${PS1_TAIL}"
    PS1="${PS1_TOP}\n${LINE_COLOR}\[└─\] ${PS1_TAIL}"
    #PS1="${PS1_TOP}\n${LINE_COLOR} ${PS1_TAIL}"
    history -a
    history -n
}

PROMPT_COMMAND=__prompt_command

# }}}

for file in ".aliases" ".functions"; do
    [ -f "$HOME/$file" ] && source "$HOME/$file"
done
