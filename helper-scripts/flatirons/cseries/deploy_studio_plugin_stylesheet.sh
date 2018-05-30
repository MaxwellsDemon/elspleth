#!/bin/bash

set -e

src_style="/c/code/git-projects/stylesheets/S1000D/XWB"
plugin='/c/code/git-projects/knowledge-center-studio-plugin'

cd "${src_style}"
mvn clean install



#	SLOW WAY

# cd '/c/code/git-projects/knowledge-center-studio-plugin'
# mvn clean install

#	FAST WAY

style="${plugin}/s1000d41/stylesheet"
rm -rf "${style}"
mkdir "${style}"
cd "${style}"

echo
echo "Unzipping stylesheets"
unzip "${src_style}/target/"*-99.99-SNAPSHOT.zip > /dev/null


