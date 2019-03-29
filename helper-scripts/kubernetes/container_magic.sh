#!/bin/bash
set -e

usage() {
	echo "usage: $(basename $0) <shell | ls | logs> <namespace> <pod substring> [<fuzzy container name>]"
	echo
	echo "    shell                   Fuzzy container name defaults to pod substring"
	echo "    logs                    Fuzzy container name defaults to all containers"
	echo "    ls                      Fuzzy container name defaults to all containers"
	echo
	echo "    <fuzzy container name>  A match when either the fuzzy name or container name is a substring of the other."
	exit_clean 1
}

subcmd="$1"
namespace="$2"
pod_substring="$3"
fuzzy_container_name="$4"
ns="-n ${namespace}"
pod_info=pod_and_container_info.tmp
pod_and_container_pairs=pod_and_container_pairs.tmp


ctrl_c() {
	cleanup
}

cleanup() {
	rm -f "${pod_info}"
	rm -f "${pod_and_container_pairs}"
}

exit_clean() {
	cleanup
	exit $1
}

for_each_pod() {
	for pod in $(matching_pods) ; do
		"$@" "${pod}"
	done
}

# GREAT
#
# k get pods -n cnet -o jsonpath="{range .items[0:2]}[{.metadata.name}, {.spec.containers[*].name}] {end}"
#
# [account-bhn-data-manager-588d5dc574-qp7qz, account-bhn-data-manager config-sidecar] [account-chtr-data-manager-6b8f644f58-fhv8k, account-chtr-data-manager config-sidecar]

matching_pods_and_their_containers() {
	kubectl get pods $ns -o jsonpath="{range .items[*]}[{.metadata.name}, {.spec.containers[*].name}] {end}" | \
		grep -oE "\[\S*${pod_substring}\S*,[^]]*\]"
}

for_each_pod_and_containers() {
	while IFS="" read -r line || [ -n "$line" ]
	do
		local pod="$(echo "${line}" | grep -oP '(?<=\[)\S+(?=,)')"
		local containers="$(echo "${line}" | grep -oP '(?<=, ).*(?=\])')"
		local containers="$(filter_containers ${containers})"
		"$@" "${pod}" ${containers}
	done < "${pod_info}"
}

filter_containers() {
	if [ "${fuzzy_container_name}" ] ; then
		for container in "$@" ; do
			if echo "${container}" | grep --quiet "${fuzzy_container_name}" ; then
				echo "${container}"
			elif echo "${fuzzy_container_name}" | grep --quiet "${container}" ; then
				echo "${container}"
			fi
		done
	else
		echo "$@"
	fi
}

list_pod_and_containers() {
	local pod="$1"
	shift
	echo "Pod: ${pod}"
	for container in "$@" ; do
		echo "Container: ${container}"
	done
	echo
}

exec_container() {
	local pod="$1"
	local container="$2"
	k8scmd="kubectl exec $ns -it ${pod} -c ${container} -- /bin/bash"
}

log_containers() {
	local pod="$1"
	shift
	for container in "$@" ; do
		local logfile="${pod}.${container}.log"
		echo "Writing: ${logfile}"
		kubectl logs $ns "${pod}" -c "${container}" > "${logfile}"
	done
	echo
}

per_pod_container_pair() {
	local pod="$1"
	shift
	for container in "$@" ; do
		echo "${pod} ${container}"
	done
}

assert_one_pod_and_container_pair() {
	local line_count=$(cat "${pod_and_container_pairs}" | wc -l)
	if [ $line_count -ne 1 ] ; then
		warn "Did not find exactly one container"
		for_each_pod_and_containers list_pod_and_containers
		exit_clean 1
	fi
}

parameter_defaults() {
	case "$subcmd" in
	ls|list)
		;;
	exec|shell)
		fuzzy_container_name="${fuzzy_container_name:-$pod_substring}"
		;;
	log|logs)
		;;
	esac
}

process_parameters() {
	case "$subcmd" in
	ls|list)
		for_each_pod_and_containers list_pod_and_containers
		;;
	exec|shell)
		assert_one_pod_and_container_pair
		for_each_pod_and_containers list_pod_and_containers
		for_each_pod_and_containers exec_container
		# Hack for TTY to work
		$k8scmd
		;;
	log|logs)
		for_each_pod_and_containers log_containers
		;;
	*)
		echo "Unknown subcommand: ${subcmd}" 1>&2
		exit_clean 4
		;;
	esac
}

warn() {
	echo
	echo -e "\x1B[31m$@\x1B[0m"
	echo
}

# ---------------------


if [ $# -lt 3 -o $# -gt 4 ] ; then
	usage
fi

trap ctrl_c INT
parameter_defaults
matching_pods_and_their_containers > "${pod_info}"
for_each_pod_and_containers per_pod_container_pair > "${pod_and_container_pairs}"
process_parameters
cleanup

