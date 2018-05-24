# Bash prompts working directory
# https://www.cyberciti.biz/tips/howto-linux-unix-bash-shell-setup-prompt.html
# https://www.cyberciti.biz/faq/bash-shell-change-the-color-of-my-shell-prompt-under-linux-or-unix/
# Fix long line wrapping by wrapping color markers with '\[' and '\]':
# http://www.tldp.org/HOWTO/Bash-Prompt-HOWTO/nonprintingchars.html
PS1='\[\e[0;32m\]\t \w \$\[\e[m\] '

# All the Vi navigation magic, in Bash CLI!
set -o vi 
# Places
alias code='cd "${_code}"'
alias down='cd ~/Downloads'

# Reload bashrc
alias bashrc='vi ~/.bashrc; source ~/.bashrc'

# Vim
alias vimrc='vim ~/.vimrc'

# Bash builtin
alias l='ls -laG'

# Git
alias status='git status'
alias list='git config --list'
alias gall='git add --all .'
alias gd='git diff'
alias gds='git diff --staged'
alias clean='git checkout .;git clean -d -x'

# Maven
alias mci='mvn clean install'
alias mcis='mvn clean install -DskipTests'
alias mciss='mvn clean install -Dmaven.test.skip=true -DskipTests'
alias mcd='mvn clean deploy'

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

# Settings specific to this machine
source ~/.bashrc_local
# ^^^ assumes .bashrc_local set these variables:
#	$_code

