#!/bin/sh
echo "Put cleartext password in file 'secret'"
docker login --username elspleth --password-stdin < secret
: > secret
echo "Cleared secret file"

