#!/bin/bash
set -e

friend='turtle'

story=$(
cat << EOF
the fox
jumped
over the ${friend}
EOF
)

echo "${story}"
