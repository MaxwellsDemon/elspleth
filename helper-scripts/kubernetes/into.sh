#!/bin/bash
set -e

usage() {
  echo "Usage: $0 <pod name>"
  echo "Usage: $0 <substrings in order> ... [any arg: a namespace starts with a dash] <any arg: cardinal number is selected pod replica>"
}

if [ $# -eq 1 ]; then
  pod="$1"
elif [ $# -eq 0 ]; then
  usage
  exit 1
fi

kube='kubectl get pods -o wide --sort-by=.spec.nodeName'

position='1'
greps=()
for arg in $@ ; do
  if echo "${arg}" | grep -qP "^-.+$" ; then            # Case: namespace
    ns="${arg#-}"
  elif echo "${arg}" | grep -qP "^[1-9][0-9]*$" ; then  # Case: is a number for pod selection
    position="${arg}"
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

if [ -z "${pod}" ]; then
  all_output="$(${kube} ${ns})"
  pods="$(echo "${all_output}" | tail -n +2 | grep -iP "$(echo "${greps[@]}" | sed "s/ /.*/g")" | cut -f1 -d' ')"
  pod_count="$(echo "${pods}" | wc -l)"
  echo "pod count: ${pod_count}"
  pod="$(echo "${pods}" | sed "${position}"'q;d')"
  echo "pod:       ${pod}"
fi
set -x
kubectl ${ns} exec -it ${pod} bash
