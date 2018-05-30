#!/bin/bash

# Expects a Tomcat with "conf/" backed up as "conf.pristine"

set -e

kc_home='/c/code/git-projects/knowledge-center'
CATALINA_HOME='/c/corena/CORENA_KCT/apache-tomcat-7.0.79'
conf="${CATALINA_HOME}/conf"
pristine="${CATALINA_HOME}/conf.pristine"
maven_settings_file=$(realpath ~/.m2/settings_kct.xml)

source_war_name='kc-package-99.99-SNAPSHOT.war'
target_war_name_base='docato-composer'

long_jar_name='kc-config-99.99-SNAPSHOT.jar'
short_jar_name='kc_config.jar'

if [ ! -d "${kc_home}" ]
then
	echo "Bad Knowledge Center home Git project: ${kc_home}"
	exit 1
fi

if [ ! -d "${CATALINA_HOME}" ]
then
	echo "Set CATALINA_HOME environment variable to a Tomcat directory"
	exit 1
fi

if [ ! -d "${pristine}" ]
then
	echo "Expecting a backup of Tomcat's conf/ directory as ${pristine}"
	exit 2
fi

if [ ! -f "${maven_settings_file}" ]
then
	echo "Expecting a Flatirons Maven Nexus settings file at ${maven_settings_file}"
	exit 2
fi

# Exit when "jar" command dependency is missing
hash jar 2>/dev/null || { echo >&2 "I require a JDK but it's not installed (a command called 'jar' is not on the path).  Aborting."; exit 1; }

#			Done verifying setup

# ---------------------------------------------------------------------

time (
echo "Stopping tomcat"
"${CATALINA_HOME}/bin/shutdown.sh"
if [ $? -eq 0 ]
then
	echo "Waiting a few seconds..."
	sleep 3
fi

echo "Tomcat cleanup"
rm -rf "${CATALINA_HOME}/webapps/${target_war_name_base}"
rm -rf "${CATALINA_HOME}/webapps/${target_war_name_base}.war"
rm -rf "${CATALINA_HOME}/work/Catalina/localhost"
rm -rf "${CATALINA_HOME}/logs/"*

echo "Maven build"
cd "${kc_home}"
# The Maven settings file is essentially the normal OCS nexus AFAIK
mvn clean install -Pxrebel -s "${maven_settings_file}" -DskipITs -DskipTests -Dmaven.wagon.http.ssl.insecure=true -Dmaven.wagon.http.ssl.allowall=true

# The jar command seems to overwrite files, which is a good thing.  Technically it's more correct to delete and restore the config directory.
echo "Deleting Tomcat conf/"
rm -rf "${conf}"
cp -r "${pristine}" "${conf}"

# The cd is for jar command context, just in case.
cd "${conf}"
echo "Copying config jar"
cp "${kc_home}/config/target/${long_jar_name}" "./${short_jar_name}"
echo "Extracting config jar"
jar xf "./${short_jar_name}"
chmod 775 "${conf}/Docato/bin/docato-ant.sh"
chmod 775 "${conf}/Docato/apache-ant/bin/ant"

cd "${conf}/Docato/bin"
bash "./docato-ant.sh" create-federation

cp "${kc_home}/AMDS-CMS/package/target/${source_war_name}" "${CATALINA_HOME}/webapps/${target_war_name_base}.war"

echo "Starting Tomcat"
"${CATALINA_HOME}/bin/startup.sh"

./docato-ant.sh -f ../../amds/AMDS-CMS/project/build.xml recreate-project -Ds1000d.issue=4.1

#Follow up work, manually
#Chain of steps
# KC up but dropdown not populated

# TODO learn these import targets
# /c/corena/CORENA_KCT/apache-tomcat-7.0.79/conf/amds/AMDS-CMS/project/build.xml

#Worth investigating to early on setup CRDM URL
# conf/Docato/data/properties/properties_persistence.xml


# Sigh
# Targets recreate-project followed by load-data results in data duplication found by BREX rules



)
