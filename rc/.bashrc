# Bash prompts working directory
# https://www.cyberciti.biz/tips/howto-linux-unix-bash-shell-setup-prompt.html
# https://www.cyberciti.biz/faq/bash-shell-change-the-color-of-my-shell-prompt-under-linux-or-unix/
# Fix long line wrapping by wrapping color markers with '\[' and '\]':
# http://www.tldp.org/HOWTO/Bash-Prompt-HOWTO/nonprintingchars.html
PS1='\[\e[0;32m\]\t \w \$\[\e[m\] '

# All the Vi navigation magic, in Bash CLI!
set -o vi

# Directories
_home="/Users/curtisf"
_notes="${_home}/Documents/notes"
_code="/code"

# Places
alias code="cd ${_code}"
alias down='cd ~/Downloads'
alias training='cd ~/Documents/projects/training'

# Reload bashrc
alias bashrc='vim ~/.bashrc; source ~/.bashrc'

# Bash
alias l='ls -laG'

# Git
alias status='git status'

# Maven
alias mci='mvn clean install'
alias mcis='mvn clean install -DskipTests'
alias mciss='mvn clean install -Dmaven.test.skip=true -DskipTests'
alias mcd='mvn clean deploy'

# Early days at Kenzan
alias accounts="vi '${_notes}/accounts.txt'"
alias todo="vi '${_notes}/todo.txt'"

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

# Vim
alias vimrc='vim ~/.vimrc'

# Added by MVN installation
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# docker auto-complete
if [ -f $(brew --prefix)/etc/bash_completion ]; then
. $(brew --prefix)/etc/bash_completion
fi

# --- Below here likely automatic ---

