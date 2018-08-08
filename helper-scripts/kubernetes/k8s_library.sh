#!/bin/bash

function get_current_namespace() {
    kubectl config view -o 'jsonpath={.contexts[?(@.name=="'$(kubectl config current-context)'")].context.namespace}'
}

