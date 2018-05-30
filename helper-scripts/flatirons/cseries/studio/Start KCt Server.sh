#!/bin/bash

echo "============================================"
echo "Starting KCt Tomcat."
echo "-Minimize the secondary console window that pops up. Closing it stops Tomcat."
echo "-After Tomcat is fully launched this main console will disappear and the browser will launch with KCt."
echo "-KCt is accessible with a browser bookmark while the secondary console is still running."
echo "============================================"

cd /c/code/branch-CSeries/Docato/bin

# ./docato-ant.sh startup-tomcat > /dev/null 2>&1


CATALINA_HOME='/c/corena/CORENA_KCT/apache-tomcat-7.0.79'
export CATALINA_HOME
"${CATALINA_HOME}/bin/startup.sh"

# "/c/Program Files (x86)/Google/Chrome/Application/chrome.exe" "http://localhost:8080/docato-composer/" &

"/c/Program Files/Internet Explorer/iexplore.exe" "http://localhost:8080/docato-composer/" &
