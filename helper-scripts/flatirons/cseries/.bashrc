# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# Usage: v <alias>
# Opens <path> in vi of simplistic aliases of the form <command> <path> 
v() {
	tp=$(type $1)
	if [ $? -eq 0 ] ; then
		# The sed commands strip a leading space-separated column, if any.
		file=$(echo "$tp" | sed -e 's/^\w*\ *//' | grep -oP '(?<=is aliased to .).+(?=.)' | sed -e 's/^\w*\ *//')
		if [ -f "${file}" ] ; then
			vi "${file}"
		else
			echo "No file called: ${file}"
		fi
	fi
}

# Open this bashrc and apply changes
alias bashrc='vi ~/.bashrc; source ~/.bashrc'

# QUICK LAUNCH SOMETHING
alias builderdeploy='/c/code/git-projects/helper-scripts/cseries/deploy_pp_builder_war.sh'
alias crdmdeploy='/c/code/git-projects/helper-scripts/cseries/deploy_crdm_war.sh'
alias d='scp tsxadmin@10.3.1.18:/home/apps/corena/CURTIS_BUILDER/tomcat/logs/catalina.out ~/Downloads/; note ~/Downloads/catalina.out &'
alias ppdeploy='/c/code/git-projects/helper-scripts/cseries/build_pinpoint.sh'

# Git shortcuts
alias status='clear; git status'
alias branch='git branch'
alias checkout='git checkout'
alias gall='git add --all .'
alias fetch='git fetch --prune; echo REMOTE:; git branch --remotes; echo LOCAL:; git branch; echo STATUS:; git status'
alias list='git config --list'
alias master='git checkout master'
alias dev='git checkout develop'
alias k='(gitk &> /dev/null &)'
alias gd='git diff'
alias gds='git diff --staged'
alias agit='/c/code/git-projects/helper-scripts/git/generic_all_git.sh'
alias qgit='/c/code/git-projects/helper-scripts/git/qgit.sh'
alias amvn='/c/code/git-projects/helper-scripts/maven/all_mvn.sh'
alias findreal='/c/code/git-projects/helper-scripts/files/findreal.sh'
alias allgit='agit'
alias allmvn='amvn'

# Other helpers
alias unnestzips='bash /c/code/git-projects/helper-scripts/files/unnest_zips.sh'
alias dss='bash /c/code/git-projects/helper-scripts/cseries/deploy_studio_plugin_stylesheet.sh'
alias deploystudiostylesheet='dss'


# Common Git misspellings
alias statsu='status'
alias statu='status'
alias staus='status'

# Maven shortcuts
alias pom='vi pom.xml'
alias mci='mvn clean install'
alias mcis='mvn clean install -Dmaven.test.skip=true'
alias mcd='mvn clean deploy'
alias mcds='mvn clean deploy -Dmaven.test.skip=true'

# Application launchers
# Note the parentheses are used to silence job control creation/termination printouts
alias e='(/c/Windows/explorer.exe . &> /dev/null &)'
alias note='/c/Program\ Files\ \(x86\)/Notepad++/notepad++.exe'
alias oxygen='(/c/Program\ Files/Oxygen\ XML\ Developer\ 17/oxygenDeveloper17.1.exe &> /dev/null &)'

# Common bash helpers and misspellings
alias l='ls -lah --color --group-directories-first'
alias cls='clear'
alias ce='cd'
alias f='find . -iname'
# The perl support allows for look-ahead and shorthand classes: "foo(?!\w)"
alias g='grep --recursive --ignore-case --binary-files=without-match --color --perl-regexp'
alias gr='g --exclude-dir=target'

# Common places
alias down='cd ~/Downloads'
alias code='cd /c/code/git-projects'
alias base='cd /c/code/git-projects/data-manager-builder-base'
alias helper='cd /c/code/git-projects/helper-scripts'

# Deployment sandboxes
alias orgdeploy='cd "/c/Users/Developer/Desktop/sandboxes/deploy sandboxes/s1000d-package-organizer-deploy"'

# Project-specific
alias project='cd /c/code/branch-CSeries/serna/plugins-5.0/s1000d41BCS'
alias studio='/c/code/handy-scripts/loop_studio/loop_studio.sh'
alias docato='cd /c/corena/CORENA_KCT/apache-tomcat-7.0.79/conf/Docato/bin'
alias stylesheets='cd /c/code/git-projects/stylesheets'
alias org='cd /c/code/git-projects/s1000d-package-organizer'
alias plugin='cd /c/code/git-projects/knowledge-center-studio-plugin/s1000d41'
alias pluginui='cd /c/code/git-projects/knowledge-center-studio-plugin/s1000d41/issue41_impl/actions/gui/ui'
alias style41='cd /c/code/git-projects/stylesheets/S1000D/XWB'

# SSH
dev='tsxadmin@10.3.1.18'
