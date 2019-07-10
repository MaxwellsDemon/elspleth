#!/bin/bash
set -e

kube='kubectl get pods -o wide --sort-by=.spec.nodeName'
echo "[Results are sorted by node name]"

namespaces='cnet|smb|specmob|specmobdev|specmobdevpi|cnetpi|canary|uidt|idcndb|pinxt|unifyshared|msa|pinxt-dev|pinxt-int|pinxt-stable|cobrowse|uid-dla|uid-mfa|uid-smbhv'

greps=()
for arg in $@ ; do
  if echo "${arg}" | grep -qP "${namespaces}" ; then
    ns="-n ${arg}"
  else
    greps+=("${arg}")
  fi
done

if [ ${#greps[@]} -eq 0 ] ; then
  ${kube} ${ns}
else
  ${kube} ${ns} | grep -iP "$(echo "${greps[@]}" | sed "s/ /.*/g")"
fi

