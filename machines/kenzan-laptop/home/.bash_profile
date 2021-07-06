source ~/.bashrc

# I know you were looking for java home, so here
# JAVA_HOME=$(/usr/libexec/java_home -v 1.8)
export JAVA_HOME='/Library/Java/JavaVirtualMachines/jdk1.8.0_202.jdk/Contents/Home'

export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
export PATH="$PATH:/opt/terraform/bin"
export PATH="$PATH:/opt/istio-1.4.2/bin"
export PATH="/usr/local/opt/node@12/bin:$PATH"
export PATH="$PATH:/root/.rover/bin" \
export APOLLO_TELEMETRY_DISABLED=1

export NODE_ENV=development

export PATH="/usr/local/opt/yq@3/bin:$PATH"


# Charter AWS-IAM Authenticator
export SSO_USER='P2820029'
export PATH="/opt/code-gitlab/sspp/platforms/sspp-infrastructure/cmd_line/:$PATH"
# export SSO_ROLE_PRECEDENCE='chartersso-AP-PDM-AWS-SSPPBE-Admin,chartersso-AP-PDM-AWS-SSPPBE-User'
# python managed by pyenv, `pyenv global 3.9.2`
if command -v pyenv 1>/dev/null 2>&1; then
  export PYENV_ROOT="$HOME/.pyenv"
  export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init --path)"
fi

source "/Users/curtisf/.rover/env"

export PATH="$PATH:/opt/code-gitlab/sspp/portals-backend/release-automation"

