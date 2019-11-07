#!/bin/bash
set -uex

if [[ $1 == "jar" ]]; then
  # build hadoop jar package
  # before check maven.compiler.source=1.7
  echo "run clean and package."
  mvn clean package
  mv target/zj-mvn-demo.jar /tmp/hadoop_test
fi

if [[ $1 == "check" ]]; then
  echo "run checkstyle."
  mvn checkstyle:checkstyle
fi

if [[ $1 == "cober" ]]; then
  echo "run cobertura code coverage."
  mvn clean cobertura:check # invoke custom goal "check"
fi

if [[ $1 == "jacoco" ]]; then
  echo "run jacoco code coverage."
  # mvn help:describe -Dplugin=org.jacoco:jacoco-maven-plugin -Ddetail
  mvn clean org.jacoco:jacoco-maven-plugin:prepare-agent test -Dmaven.test.failure.ignore=true
fi

if [[ $1 == "checkall" ]]; then
  echo "run checkstyle and code coverage."
  mvn clean checkstyle:checkstyle \
  org.jacoco:jacoco-maven-plugin:prepare-agent test -Dmaven.test.failure.ignore=true
fi

if [[ $1 == "site" ]]; then
  echo "run project info report site."
  mvn clean site:site
fi

if [[ $1 == "sonar" ]]; then
  echo "run junit, checkstyle and code coverage, and push project data to sonarqube."
  mvn clean checkstyle:checkstyle \
  org.jacoco:jacoco-maven-plugin:prepare-agent package -Dmaven.test.failure.ignore=true \
  sonar:sonar -Dsonar.host.url=http://localhost:9000
fi

echo "Java project ci DONE."

set +uex