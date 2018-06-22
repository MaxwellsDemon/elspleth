# Bash prompts working directory
# https://www.cyberciti.biz/tips/howto-linux-unix-bash-shell-setup-prompt.html
# https://www.cyberciti.biz/faq/bash-shell-change-the-color-of-my-shell-prompt-under-linux-or-unix/
# Fix long line wrapping by wrapping color markers with '\[' and '\]':
# http://www.tldp.org/HOWTO/Bash-Prompt-HOWTO/nonprintingchars.html
PS1='\[\e[0;32m\]\t \w \$\[\e[m\] '

# All the Vi navigation magic, in Bash CLI!
set -o vi 

# Places
alias code='cd "${code}"'
alias down='cd ~/Downloads'
alias helper='cd "${code}"/elspleth/helper-scripts'
alias tmp='mkdir -p ~/tmp; cd ~/tmp'

# Reload bashrc
alias bashrc='vi ~/.bashrc; source ~/.bashrc'
alias bashrclocal='vi ~/.bashrc_local; source ~/.bashrc_local'
alias bashrcvariables='vi ~/.bashrc_local_variables; source ~/.bashrc_local_variables'

# Vim
alias vimrc='vim ~/.vimrc'

# Navigation
alias l='ls -lah --color=auto --group-directories-first'
alias cls='clear'
alias ce='cd'
alias f='find . -iname' # The perl support allows for look-ahead and shorthand classes: "foo(?!\w)"
alias g='grep --recursive --ignore-case --binary-files=without-match --color --perl-regexp'
alias gr='g --exclude-dir=target'

# Git
alias status='git status'
alias s='status'
alias statu='status'
alias stauts='status'
alias staut='status'
alias checkout='git checkout'
alias list='git config --list'
alias gadd='git add .;git status'
alias gall='git add --all .;git status'
alias gd='git diff'
alias gds='git diff --staged'
alias clean='git checkout .;git clean -d -x'
alias fetch='git fetch --prune; echo REMOTE:; git branch --remotes; echo LOCAL:; git branch; echo STATUS:; git status'
alias list='git config --list'
alias master='git checkout master'
alias dev='git checkout develop'
alias agit='"${code}"/elspleth/helper-scripts/git/generic_all_git.sh'
alias qgit='"${code}"/elspleth/helper-scripts/git/qgit.sh'
alias ship='"${code}"/elspleth/helper-scripts/git/ship.sh'

# Maven
alias maven='mvn'
alias mci='mvn clean install'
alias mcis='mvn clean install -DskipTests'
alias mciss='mvn clean install -Dmaven.test.skip=true -DskipTests'
alias mcd='mvn clean deploy'
alias amvn='"${code}"/elspleth/helper-scripts/maven/all_mvn.sh'

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

# Holistic
alias morning='bash "${code}"/elspleth/helper-scripts/holistic/morning.sh'

function compare() {
	if [ $# -ne 2 ]; then echo 'usage: compare old new' ; fi
	if cmp --silent $1 $2 ; then
		echo "Byte equivalent"
	else
		echo "Files differ"
	fi
}

# Settings specific to this machine
# 	Assumes .bashrc_local set these variables:
#	$code
source ~/.bashrc_local

