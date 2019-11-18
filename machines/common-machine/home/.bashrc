# All the Vi navigation magic, in Bash CLI!
set -o vi 

# Source "code" variable
if [ -f ~/.bashrc_local_variables ]; then
  source ~/.bashrc_local_variables
else
  echo 'Please create file ~/.bashrc_local_variables'
fi

# History scrolling is aware of partially typed command for filtering
bind '"\e[A":history-search-backward'
bind '"\e[B":history-search-forward'

# Places
alias code='cd "${code}"'
alias down='cd ~/Downloads'
alias desk='cd ~/Desktop'
alias helper='cd "${code}"/elspleth/helper-scripts'
alias tmp='mkdir -p ~/tmp; cd ~/tmp'
alias elspleth='cd "${code}"/elspleth'

# rc files
alias bashrc='vi ~/.bashrc; source ~/.bashrc'
alias bashrclocal='vi ~/.bashrc_local; source ~/.bashrc'
alias bashrcvariables='vi ~/.bashrc_local_variables; source ~/.bashrc'
alias vimrc='vim ~/.vimrc'

# Basics
alias l='rm -f .DS_Store; ls -lah --color=auto --group-directories-first'
alias L='l'
alias cls='clear'
alias c='clear'
alias ce='cd'
alias f='find -E . -iname' # The perl support allows for look-ahead and shorthand classes: "foo(?!\w)"
alias fr='"${code}"/elspleth/helper-scripts/files/findreal.sh'
alias Grep='grep'
alias g='grep --recursive --ignore-case --binary-files=without-match --color --perl-regexp'
alias gr='g --exclude-dir=target --exclude-dir=.git --exclude-dir=.svn --exclude-dir=.idea --exclude-dir=node_modules --exclude-dir=coverage'
alias grm='g --exclude-dir=target --exclude-dir=.git --exclude-dir=.svn --exclude-dir=.idea --exclude-dir=node_modules --exclude-dir=test'
alias cast='git add .; git commit -m "Intermediate commit for testing"; git push'

# Basic typos
alias xit='exit'
alias EXIT='exit'
alias exi='exit'
alias ci='vi'

# Git
alias status='rm -f .DS_Store; git status'
alias s='status'
alias S='s'
alias statu='status'
alias stauts='status'
alias staut='status'
alias branch='git branch'
alias b='git branch'
alias br='git branch'
alias cb='git rev-parse --abbrev-ref HEAD'
alias list='git config --list'
alias gall='git add --all .'
alias gd='git diff'
alias gds='git diff --staged'
alias fetch='git fetch --prune; echo REMOTE:; git branch --remotes; echo LOCAL:; git branch; echo STATUS:; git status'
alias list='git config --list'
alias master='git checkout master'
alias dev='git checkout develop'
alias develop='git checkout develop'
alias slowgit='"${code}"/elspleth/helper-scripts/git/slow-git.sh'
alias fastgit='"${code}"/elspleth/helper-scripts/git/fast-git.sh'
alias pushto='"${code}"/elspleth/helper-scripts/git/pushto.sh'
alias squash='"${code}"/elspleth/helper-scripts/git/squash.sh'
alias clean_remote_branches_safer='"${code}"/elspleth/helper-scripts/git/cleanup-remote-branches.sh'
alias push='git push --set-upstream origin $(git rev-parse --abbrev-ref HEAD)'
alias deletebranch='"${code}"/elspleth/helper-scripts/git/delete-branch.sh'

alias lines='sed "s/ /\n/g"'

function of() {
  echo *"$1"* | sed "s/ /\n/g"
}

function gitp() {
  git "p$1"
}

function newbranch() {
  git checkout -b "$1" && push
}

function gitk() {
  (/usr/local/bin/gitk $@ &)
}

# Maven
alias maven='mvn'
alias mcv='mvn clean verify'
alias mcp='mvn clean package'
alias mcps='mvn clean package -DskipTests'
alias mcpss='mvn clean package -Dmaven.test.skip=true -DskipTests'
alias mci='mvn clean install'
alias mcis='mvn clean install -DskipTests'
alias mciss='mvn clean install -Dmaven.test.skip=true -DskipTests'
alias mcd='mvn clean deploy'
alias mcds='mvn clean deploy -DskipTests'
alias mcdss='mvn clean deploy -Dmaven.test.skip=true -DskipTests'
alias shallowmvn='"${code}"/elspleth/helper-scripts/maven/shallowmvn.sh'
alias deepmvn='"${code}"/elspleth/helper-scripts/maven/deepmvn.sh'
alias tree='mvn dependency:tree > tree && vi tree'

# Google Cloud
alias instances='gcloud compute instances'
alias gssh='gcloud compute ssh'

# Docker
alias doc='docker'
alias dockre='docker'
alias dock='docker'
alias doker='docker'
alias dl='docker container ls -a'
alias dex='docker exec -it'
alias start_swagger='docker run --rm -d -p 80:8080 swaggerapi/swagger-editor'

# Kubernetes
alias k='kubectl'
alias pods='bash "${code}/elspleth/helper-scripts/kubernetes/pods.sh"'

# Holistic
alias morning='bash "${code}"/elspleth/helper-scripts/holistic/morning.sh'

# `v` repeats the most recent vi command
# `v 3` repeats the third most recent unique vi command, etc.
function v() {
  vi $(history | grep -oP ' vi[ ].+' | uniq | tail -${1:-1} | head -n 1 | sed -E 's/vi (.+)/\1/g')
}

function compare() {
  if [ $# -ne 2 ]; then echo 'usage: compare <file a> <file b>'; return 1; fi
  if cmp --silent "$1" "$2" ; then
    echo "Byte equivalent"
  else
    echo "Files differ"
  fi
}

function _colorman() {
  env \
    LESS_TERMCAP_mb=$(printf "\e[1;35m") \
    LESS_TERMCAP_md=$(printf "\e[1;34m") \
    LESS_TERMCAP_me=$(printf "\e[0m") \
    LESS_TERMCAP_se=$(printf "\e[0m") \
    LESS_TERMCAP_so=$(printf "\e[7;40m") \
    LESS_TERMCAP_ue=$(printf "\e[0m") \
    LESS_TERMCAP_us=$(printf "\e[1;33m") \
      "$@"
}
function man() { _colorman man "$@"; }

function repeat() {
  if [ $# -ne 2 ]; then echo 'usage: repeat <string> <count>'; return 1; fi
  for ((i=1; i <= $2; i++)); do
    echo -n "$1"
  done
}

# Echos number of directories needed to be popped until current directory name grep-matches $1 substring
function _locate_ancestor() {
  IFS='/' read -ra _components <<< $(pwd)
  for ((i = ${#_components[@]} - 1, c = 0; i >= 1; i--, c++))
  do
    if echo "${_components[$i]}" | grep "$1" > /dev/null
    then
      echo $c
      return 0
    fi
  done
  echo 0
  >&2 echo "$1 not found in ancestor name"
}

function ..() {
  if [ $# -gt 1 ]; then 
    echo 'usage: .. <a number: number of directories to pop>'
    echo '          or'
    echo 'usage: .. <otherwise: pops directories until ancestor name contains substring>'
    return 1; fi
  if [ $# -eq 0 ]; then 
    cd ..
  else
    case $1 in
      ''|*[!0-9]*) local pops=$(_locate_ancestor $1) ;;
      *)           local pops=$1 ;;
    esac
    if [ $pops -gt 0 ]; then
      cd $(repeat '../' $pops)
    fi
  fi
}

# arg 1: a number that's the position of the branch in the list to checkout
function checkout() {
  if [ $# -eq 1 ]; then
    choice="$1"
  else
    git branch | cat -n
    read -p '> ' choice
  fi
  if [ "${choice}" ]; then
    local branch="$(git branch | sed "${choice}q;d" | sed 's/^[* ]*//g')"
    git checkout "${branch}"
  fi
}
alias ch='checkout'

# Settings specific to this machine
#   Assumes .bashrc_local set these variables:
#  $code
if [ -f ~/.bashrc_local ]; then
  source ~/.bashrc_local
else
  echo 'Please create file ~/.bashrc_local'
fi

function newscript() {
  local name='foo.sh'
  if [ $# -eq 1 ]; then local name="$1"; fi
  echo '#!/bin/bash' >> "${name}"
  echo 'set -e' >> "${name}"
  chmod u+x "${name}"
  vi "${name}"
  cat "${name}"
}

replace_text() {
  if [ $# -ne 2 ]; then echo 'usage: <slashy sed target pattern> <slashy sed replace>'; echo 'Recursively updates files'; return 1; fi
  if sed --version > /dev/null 2>&1 ; then
    # GNU sed
    find . \
      -name .git -type d -prune -o \
      -name .svn -type d -prune -o \
      -name .idea -type d -prune -o \
      -name target -type d -prune -o \
      -name node_modules -type d -prune -o \
      -type f \
      -exec sed -E -i -e "s/$1/$2/g" {} +
  else
    # BSD (mac) sed
    find . \
      -name .git -type d -prune -o \
      -name .svn -type d -prune -o \
      -name .idea -type d -prune -o \
      -name target -type d -prune -o \
      -name node_modules -type d -prune -o \
      -type f \
      -exec sed -E -i '' -e "s/$1/$2/g" {} +
  fi
}

# Alter PS1 AFTER the local script, since some /etc/bashrc check if PS1 is set

# Bash prompts working directory
# https://www.cyberciti.biz/tips/howto-linux-unix-bash-shell-setup-prompt.html
# https://www.cyberciti.biz/faq/bash-shell-change-the-color-of-my-shell-prompt-under-linux-or-unix/
# Fix long line wrapping by wrapping color markers with '\[' and '\]':
# http://www.tldp.org/HOWTO/Bash-Prompt-HOWTO/nonprintingchars.html
PS1='\n\[\e[0;32m\]\t $? \u \w\n\$\[\e[m\] '
# PS1='\[\e[0;32m\]\t $? $([ $? == 0 ] && echo ✅ || echo "⚠️ ") \w \$\[\e[m\] '
