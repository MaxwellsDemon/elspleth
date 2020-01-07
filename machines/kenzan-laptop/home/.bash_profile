source ~/.bashrc

export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
export PATH="$PATH:/opt/terraform/bin"
export PATH="$PATH:/opt/istio-1.4.2/bin"

# Re-enable Google Cloud when needed
# The next line updates PATH for the Google Cloud SDK.
# if [ -f '/opt/google-cloud-sdk/path.bash.inc' ]; then source '/opt/google-cloud-sdk/path.bash.inc'; fi
# The next line enables shell command completion for gcloud.
# if [ -f '/opt/google-cloud-sdk/completion.bash.inc' ]; then source '/opt/google-cloud-sdk/completion.bash.inc'; fi

export NODE_ENV=development

