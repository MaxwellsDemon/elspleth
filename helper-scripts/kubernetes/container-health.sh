#!/bin/bash

echo "Pods afflicted with OOMKilled termination"
kubectl get pods -o jsonpath='{.items[?(@.status.containerStatuses[*].lastState.terminated.reason=="OOMKilled")].metadata.name}'
echo
# Put more analysis here
echo

