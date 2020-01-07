#!/bin/bash
set -e

kube='kubectl get pods -o wide --sort-by=.spec.nodeName'
echo "Usage: $0 <substrings in order> ... [any arg: a namespace starts with a dash]"

greps=()
for arg in $@ ; do
  if echo "${arg}" | grep -qP "^-.+$" ; then
    ns="${arg#-}"
  else
    greps+=("${arg}")
  fi
done
if [ "${ns}" ] ; then
  echo "namespace: ${ns}"
  ns="-n ${ns}"
else
  echo "namespace: [default]"
fi

echo "[Results are sorted by node name]"
if [ ${#greps[@]} -eq 0 ] ; then
  ${kube} ${ns}
else
  all_output="$(${kube} ${ns})"
  echo
  echo "${all_output}" | head -n1
  echo "${all_output}" | tail -n +2 | grep -iP "$(echo "${greps[@]}" | sed "s/ /.*/g")"
fi

