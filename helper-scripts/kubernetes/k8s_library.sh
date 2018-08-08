#!/bin/bash

function get_current_namespace() {
    kubectl config view -o 'jsonpath={.contexts[?(@.name=="'$(kubectl config current-context)'")].context.namespace}'
}

function search_for_pod() {
		local pod_name=$1
		shift
    kubectl get $@ pods 2> /dev/null | grep "${pod_name}" | sed -E 's/ +/ /g'
}

function get_pod_info() {
	# Deal with lack of permissions for all ns
	pod_info=$(search_for_pod $1 --all-namespaces)
	if [ "${pod_info}" ]; then
	    namespace=$(echo "${pod_info}" | cut -f1 -d' ')
	    pod_name=$(echo "${pod_info}" | cut -f2 -d' ')
	else
	    namespace=$(get_current_namespace)
	    pod_info=$(search_for_pod $1 -n "${namespace}")
	    pod_name=$(echo "${pod_info}" | cut -f1 -d' ')
	fi
	echo "pod: ${pod_name}"
	echo "namespace: ${namespace}"
}

