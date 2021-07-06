# All the Vi navigation magic, in Bash CLI!
set -o vi 

# Source "code" variable
if [ -f ~/.bashrc_local_variables ]; then
  source ~/.bashrc_local_variables
else
  echo 'Please create file ~/.bashrc_local_variables'
fi

if [ -f ~/.bashrc_local_temporaries ]; then
  source ~/.bashrc_local_temporaries
fi

pom_namespace='http://maven.apache.org/POM/4.0.0'

# History scrolling is aware of partially typed command for filtering
bind '"\e[A":history-search-backward'
bind '"\e[B":history-search-forward'

# Places
alias code='cd "${code}"'
alias down='cd ~/Downloads'
alias desk='cd ~/Desktop'
alias helper='cd "${code}"/elspleth/helper-scripts'
alias learning='cd "${code}"/elspleth/helper-scripts/learning'
alias tmp='mkdir -p ~/tmp; cd ~/tmp'
alias elspleth='cd "${code}"/elspleth'
alias m2='cd "${HOME}"/.m2'
alias secrets='cd "${HOME}"/secrets'

# rc files
alias bashrc='vi ~/.bashrc; source ~/.bashrc'
alias bashrclocal='vi ~/.bashrc_local; source ~/.bashrc'
alias bashrcvariables='vi ~/.bashrc_local_variables; source ~/.bashrc'
alias bashrctemp='vi ~/.bashrc_local_temporaries; source ~/.bashrc'
alias vimrc='vi ~/.vimrc'
alias known='vi ~/.ssh/known_hosts'

# Basics
alias l='rm -f .DS_Store; ls -lah --color=auto --group-directories-first'
alias L='l'
alias cls='clear'
alias c='clear'
alias ce='cd'
# alias f='find -E . -iname' # The perl support allows for look-ahead and shorthand classes: "foo(?!\w)"
alias f='"${code}"/elspleth/helper-scripts/files/findreal.sh'
alias Grep='grep'
_grep_exclusions='--exclude-dir=target --exclude-dir=.git --exclude-dir=.svn --exclude-dir=.idea --exclude-dir=node_modules --exclude-dir=coverage --exclude-dir=.nyc_output'
# Cannot use --exclude="*.iml
alias g="grep --recursive --ignore-case --binary-files=without-match --color --perl-regexp ${_grep_exclusions}"
alias gf="grep --recursive --ignore-case --binary-files=without-match --color --fixed-strings ${_grep_exclusions}" # 'f' for fixed-string
alias cast='git add .; git commit -m "Intermediate commit for testing"; push'
alias lab='vi .gitlab-ci.yml'
alias pom='vi pom.xml'
alias vilab='lab'

# Basic typos
alias xit='exit'
alias exiit='exit'
alias EXIT='exit'
alias exi='exit'
alias ci='vi'
alias vii='vi'
alias gti='git'
alias gi='git'
alias vm='mv'
alias vo='vi'

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
alias add='git add .'
alias gall='git add --all .'
alias gd='git diff'
alias gds='git diff --staged'
alias restore='git restore --staged'
alias fetch='git fetch --prune --all --tags --prune-tags -f; echo REMOTE:; git branch --remotes; echo LOCAL:; git branch; echo STATUS:; git status'
alias list='git config --list'
alias master='git checkout master'
alias dev='git checkout develop'
alias develop='git checkout develop'
alias slowgit='"${code}"/elspleth/helper-scripts/git/slow-git.sh'
alias fastgit='"${code}"/elspleth/helper-scripts/git/fast-git.sh'
alias staggeredgit='"${code}"/elspleth/helper-scripts/git/staggered-git.sh'
alias pushto='"${code}"/elspleth/helper-scripts/git/pushto.sh'
alias squash='"${code}"/elspleth/helper-scripts/git/squash.sh'
alias clean_remote_branches_safer='"${code}"/elspleth/helper-scripts/git/cleanup-remote-branches.sh'
alias push='git push --set-upstream origin $(git rev-parse --abbrev-ref HEAD)'
alias deletebranch='"${code}"/elspleth/helper-scripts/git/delete-branch.sh'
alias summary='git shortlog --summary --numbered --email'
alias foreach_repo='"${code}"/elspleth/helper-scripts/git/foreach-repo.sh'

snapshot_me() {
  local version="$(xmlstarlet sel -N a="${pom_namespace}" -t -v '/a:project/a:version' pom.xml)"
  local minor="$(echo "${version}" | sed -E 's,[0-9]+\.([0-9]+)\.[0-9]+.*,\1,g')"
  ((minor++)) || true
  local new_version="$(echo "${version}" | sed -E 's,([0-9]+\.)[0-9]+(\.[0-9]+).*,\1'"${minor}"'.0-SNAPSHOT,g')"
  xmlstarlet ed --ps --inplace -N a="${pom_namespace}" -u '/a:project/a:version' -v "${new_version}" pom.xml
  git diff
  echo
  echo "Latest tag: $(git tag --list --sort=-version:refname | head -n1)"
  echo "Good?"
  read
  git add pom.xml
  git commit -m "Opening ${new_version}"
  git push
}

copy_pom_id() {
  local pom_path="./pom.xml"
  local pom_id="$(print_pom_id "${pom_path}")"
  echo "${pom_id}"
  echo -n "${pom_id}" | copy_string
}

print_pom_id() {
  local pom_path="${1:-pom.xml}"
  xmlstarlet sel -N a="${pom_namespace}" -t -m '/a:project' \
    --if 'a:groupId' -v 'concat(a:groupId, ":", a:artifactId)' \
    --else -v 'concat(a:parent/a:groupId, ":", a:artifactId)' \
    --break -n \
    "${pom_path}"
}

print_pom_paths() {
  local directory="$1"
  find -E "${directory}" \
      -name .git -type d -prune -o \
      -name .svn -type d -prune -o \
      -name .idea -type d -prune -o \
      -name target -type d -prune -o \
      -name node_modules -type d -prune -o \
      -name pom.xml -print
}

print_pom_ids() {
  mapfile -t pom_paths < <(print_pom_paths .)
  local pom_path
  for pom_path in "${pom_paths[@]}"; do
    if [ -f "${pom_path}" ]; then
      print_pom_id "${pom_path}"
    fi
  done
}

print_direct_deps() {
  local pom_path="${1:-pom.xml}"
  local deps
  mapfile -t deps < <(xmlstarlet sel -N a="${pom_namespace}" -t -m '//a:dependency' -v 'concat(a:groupId,":",a:artifactId," ")' "${pom_path}"  | sed -E 's/ /\n/g')
  echo "===DIRECT DEPENDENCIES==="
  printf '%s\n' "${deps[@]}"
  echo
  echo "===MENTIONS CHARTER RESOURCES==="
  printf '%s\n' "${deps[@]}" | grep -Po '.*(charter|spectrum|aesd).*' || true
}

alias lines='sed "s/ /\n/g"'

function has() {
  echo *"$1"* | sed "s/ /\n/g"
}
alias with='has'
alias of='has'

function gitp() {
  git "p$1"
}

function newbranch() {
  git checkout -b "$1" && push
}

function newpipelinebranch() {
  git checkout -b "$1" && \
  yq w -i .gitlab-ci.yml --style=single include.ref "$1" && \
  cast
}

function initialcommit() {
  touch .gitignore && \
  git add .gitignore && \
  git commit -m 'initial commit' && \
  git push --set-upstream origin master
}

# Maven
_mvn_opts='-Dmaven.artifact.threads=20'
alias maven="mvn ${_mvn_opts}"
alias mct="mvn ${_mvn_opts} clean test"
alias mcv="mvn ${_mvn_opts} clean verify"
alias mcp="mvn ${_mvn_opts} clean package"
alias mcps="mvn ${_mvn_opts} clean package -DskipTests"
alias mcpss="mvn ${_mvn_opts} clean package -Dmaven.test.skip=true -DskipTests"
alias mci="mvn ${_mvn_opts} clean install"
alias mcis="mvn ${_mvn_opts} clean install -DskipTests"
alias mciss="mvn ${_mvn_opts} clean install -Dmaven.test.skip=true -DskipTests"
alias mcd="mvn ${_mvn_opts} clean deploy"
alias mcds="mvn ${_mvn_opts} clean deploy -DskipTests"
alias mcdss="mvn ${_mvn_opts} clean deploy -Dmaven.test.skip=true -DskipTests"
alias shallowmvn='"${code}"/elspleth/helper-scripts/maven/shallowmvn.sh'
alias deepmvn='"${code}"/elspleth/helper-scripts/maven/deepmvn.sh'
alias tree='mvn org.apache.maven.plugins:maven-dependency-plugin:3.1.2:tree'
alias before='tree > ~/Downloads/before'
alias after='tree > ~/Downloads/after'
alias treelist='mvn org.apache.maven.plugins:maven-dependency-plugin:3.1.2:list'
alias list_repositories='mvn org.apache.maven.plugins:maven-dependency-plugin:3.1.2:list-repositories'

function deptree() {
  mvn dependency:tree > ${1:-tree}
}

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
alias imagebuild='docker build -t foo:bar .'
alias dinto='docker run --rm -it --entrypoint /bin/bash'

function imagerun() {
  if [ $# -eq 0 ]; then
    docker run --rm -it foo:bar bash
  else
    docker run --rm -it foo:bar "$@"
  fi
}

# Holistic
alias morning='bash "${code}"/elspleth/helper-scripts/holistic/morning.sh'

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

function sibling() {
  local s="$(pwd)$1"
  if [ -d "${s}" ]; then
    cd "${s}"
  else
    cd "../$1"
  fi
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
alias ..c='.. && clear'

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

if [ -f ~/.bashrc_kube ]; then
  source ~/.bashrc_kube
fi

function newscript() {
  local name='foo.sh'
  if [ $# -eq 1 ]; then local name="$1"; fi
  if [ -f "${name}" ]; then echo 'already exists'; return 1; fi
  cat <<'FIN' >> "${name}"
#!/usr/local/bin/bash
set -eo pipefail

usage() {
cat <<- EOF
usage: $(basename $0)
EOF
exit 1
}

if [ $# -ne 0 ]; then
  usage
fi
FIN
  chmod u+x "${name}"
  vi "${name}"
  cat "${name}"
}

replace_text() {
  if [ $# -ne 2 ]; then echo 'usage: <directory root> <sed pattern>'; echo 'Recursively updates files'; return 1; fi
  local directory_root="$1"
  shift
  if sed --version > /dev/null 2>&1 ; then
    # GNU sed
    find "${directory_root}" \
      -name .git -type d -prune -o \
      -name .svn -type d -prune -o \
      -name .idea -type d -prune -o \
      -name target -type d -prune -o \
      -name node_modules -type d -prune -o \
      -type f \
      -exec sed -E -i "$@" {} +
  else
    # BSD (mac) sed
    find "${directory_root}" \
      -name .git -type d -prune -o \
      -name .svn -type d -prune -o \
      -name .idea -type d -prune -o \
      -name target -type d -prune -o \
      -name node_modules -type d -prune -o \
      -type f \
      -exec sed -E -i '' "$@" {} +
  fi
}

emoji_tiles() {
  if [ $# -ne 1 ]; then echo "usage: ${FUNCNAME[0]} <prefix>"; return 1; fi
  local start=0
  local cols=5
  for cell in $(seq $start $(($start + 15 - 1))); do
    echo -n ":$1$(printf %02g $cell):"
    local new_row=$(( ($cell + 1) % $cols ))
    if [ $new_row -eq $start ]; then echo; fi
  done
}

# Kubernetes
alias k='kubectl'
alias x='kubectx'
alias pods='bash "${code}/elspleth/helper-scripts/kubernetes/pods.sh"'
alias into='bash "${code}/elspleth/helper-scripts/kubernetes/into.sh"'

function kp() {
  if [ $# -eq 0 ]; then
    kubectl get pods
  else
    kubectl get pods | grep "$@"
  fi
}

function sadpods() {
  kubectl get pods | grep -P '^(((?!Running).)+|.+(\d+)/(?!\3)\d.+)$'
}

bounce() {
  if [ $# -ne 1 ]; then echo "usage: ${FUNCNAME[0]} <k8s deployment>"; return 1; fi
  kubectl rollout restart deployment "$1"
}

replicas1() {
  if [ $# -ne 1 ]; then echo "usage: ${FUNCNAME[0]} <k8s deployment>"; return 1; fi
  kubectl patch deployment "$1" -p '{"spec":{"replicas": 1 }}'
}

imgver() {
  if [ $# -ne 1 ]; then echo "usage: ${FUNCNAME[0]} <k8s deployment>"; return 1; fi
  kubectl describe pods -l app="$1" | grep Image: | tr -s ' ' | sed -E 's/Image: +//g' | sort | uniq
}

format_pom() {
  xmlstarlet fo --indent-spaces 4 pom.xml > pom.xml.tmp
  mv pom.xml.tmp pom.xml
}

copy_script_dir() {
  local cmd='script_dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)'
  echo "${cmd}"
  echo "${cmd}" | copy_string
}

copy_pom_namespace() {
  echo "${pom_namespace}"
  echo -n "${pom_namespace}" | copy_string
}

copy_string() {
  pbcopy
}

place() {
  local place_file="$HOME/.place"
  if [ -n "$1" ]; then
    if [ ! -d "$1" ]; then
      echo "Not a directory [$1]"
      return 1
    fi
    realpath "$1" > "${place_file}"
  fi
  if [ -f "${place_file}" ]; then
    local place="$(cat "${place_file}")"
    if [ ! -d "${place}" ]; then
      echo "File [${place_file}] saved location is not a directory [${place}]. Maybe location was removed."
      return 2
    fi
    cd "$(cat "${place_file}")"
  else
    echo "Usage: ${FUNCNAME[0]} [<directory>]"
    echo
    echo "A solution for short lived development cycles. Loads useful aliases, e.g. to run build commands"
    echo
    echo "Saves absolute directory path in file [${place_file}]"
    echo
    echo "Changes directory to the saved location"
    echo "Then sources file [sourceable-aliases.sh] if present"
  fi
  if [ ! -f sourceable-aliases.sh ]; then
    touch sourceable-aliases.sh
    echo "alias aliases='vi sourceable-aliases.sh; source sourceable-aliases.sh'" >> sourceable-aliases.sh
    echo "alias a='aliases'" >> sourceable-aliases.sh
    echo >> sourceable-aliases.sh
    echo "alias run='./main.sh'" >> sourceable-aliases.sh
    echo "alias r='run'" >> sourceable-aliases.sh
    echo >> sourceable-aliases.sh
    echo "alias edit='vi main.sh'" >> sourceable-aliases.sh
    echo "alias e='edit'" >> sourceable-aliases.sh
    echo "Created starter sourceable-aliases.sh"
  fi
  source sourceable-aliases.sh
  echo "sourced sourceable-aliases.sh"
}

# Alter PS1 AFTER the local script, since some /etc/bashrc check if PS1 is set

# Bash prompts working directory
# https://www.cyberciti.biz/tips/howto-linux-unix-bash-shell-setup-prompt.html
# https://www.cyberciti.biz/faq/bash-shell-change-the-color-of-my-shell-prompt-under-linux-or-unix/
# Fix long line wrapping by wrapping color markers with '\[' and '\]':
# http://www.tldp.org/HOWTO/Bash-Prompt-HOWTO/nonprintingchars.html

if [ -f ~/.bashrc_env_name ]; then
  _ps1_fragment="\e[0;92m[$(cat ~/.bashrc_env_name)] "
fi
PS1="\n${_ps1_fragment}"'\e[0;32m\t $? \u \w\n\$\[\e[m\] '
unset _ps1_fragment

source "/Users/curtisf/.rover/env"
