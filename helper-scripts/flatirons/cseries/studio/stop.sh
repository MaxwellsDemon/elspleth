#!/bin/bash

stop_file="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"/stop

touch "${stop_file}"
