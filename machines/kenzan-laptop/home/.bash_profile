source ~/.bashrc

export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
export PATH="$PATH:/opt/terraform/bin"
export PATH="$PATH:/opt/istio-1.4.2/bin"
export JAVA_HOME='/Library/Java/JavaVirtualMachines/jdk1.8.0_202.jdk/Contents/Home'

# Re-enable Google Cloud when needed
# The next line updates PATH for the Google Cloud SDK.
# if [ -f '/opt/google-cloud-sdk/path.bash.inc' ]; then source '/opt/google-cloud-sdk/path.bash.inc'; fi
# The next line enables shell command completion for gcloud.
# if [ -f '/opt/google-cloud-sdk/completion.bash.inc' ]; then source '/opt/google-cloud-sdk/completion.bash.inc'; fi

export NODE_ENV=development

export PATH="/usr/local/opt/yq@3/bin:$PATH"

# Charter AWS-IAM Authenticator
export SSO_USER='P2820029'
export PATH="/opt/code-gitlab/sspp/platforms/sspp-infrastructure/cmd_line/:$PATH"
# python managed by pyenv, `pyenv global 3.9.2`
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi


