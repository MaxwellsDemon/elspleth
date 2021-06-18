#!/usr/local/bin/bash

KUBE_NAMESPACE=cnet

# List deployment names
kubectl -n "${KUBE_NAMESPACE}" get deployments -o=custom-columns=name:.metadata.name --no-headers

