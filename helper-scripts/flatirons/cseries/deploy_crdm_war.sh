#!/bin/bash

set -e

crdm_home='/c/code/git-projects/common-record-data-manager'
long_war_name='Services-99.99-SNAPSHOT.war'
short_war_name='Services'

if [ ! -d "${crdm_home}" ]
then
	echo "Bad CRDM home Git project: ${crdm_home}"
	exit 1
fi

if [ ! -d "${CATALINA_HOME}" ]
then
	echo "Set CATALINA_HOME environment variable"
	exit 1
fi

cd "${crdm_home}"

mvn clean install -Pdevelopment -DskipTests


echo "Stopping tomcat"

set +e
sc STOP Tomcat7
if [ $? -eq 0 ]
then
	echo "Waiting to shut down"
	sleep 4
fi
set -e



echo "Cleanup"
rm -rf "${CATALINA_HOME}/webapps/${short_war_name}"
rm -rf "${CATALINA_HOME}/webapps/${short_war_name}.war"
rm -rf "${CATALINA_HOME}/work/Catalina/localhost"
rm -rf "${CATALINA_HOME}/logs/"*

cp "${crdm_home}/server/rest/target/${long_war_name}" "${CATALINA_HOME}/webapps/${short_war_name}.war"

echo "Starting Tomcat"

set +e
sc START Tomcat7
set -e

sleep 5
echo "Waiting a few seconds for Tomcat to start"
