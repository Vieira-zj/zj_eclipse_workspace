#!/bin/bash
set -ue

target_jar="target/zj-jmeter-app.jar"

function create_jar() {
  echo "run clean and package."
  mvn clean package -Dmaven.test.skip=true
  cp ${target_jar} /tmp
}

if [[ $1 == "jar" ]]; then
  create_jar
fi

if [[ $1 == "exec" ]]; then
  java -cp ${target_jar} zhengjin.jmeter.app.JmeterApp
fi


cls_path="${target_jar}:${HOME}/Workspaces/mvn_repository/junit/junit/4.12/junit-4.12.jar"
test_class="zhengjin.jmeter.junitsampler.JunitSampler01"
test_method="test02PostMethod"

echo "run main test for class:"
echo "java -cp ${cls_path} org.junit.runner.JUnitCore ${test_class}"
if [[ $1 == "testc" ]]; then
  create_jar
  java -cp ${cls_path} org.junit.runner.JUnitCore ${test_class} 
fi

echo "run main test for specified method:"
echo "java -cp ${cls_path} zhengjin.jmeter.app.SingleJUnitTestRunner ${test_class}#${test_method}"
if [[ $1 == "testm" ]]; then
  create_jar
  java -cp ${cls_path} zhengjin.jmeter.app.SingleJUnitTestRunner ${test_class}#${test_method}
fi


if [[ $1 == "test" ]]; then
  echo "run junit test:"
  #mvn clean -Dtest=HttpClientTest test
  #mvn clean -Dtest=HttpClientTest#test01HttpClientGet test
  mvn clean -Dtest=AppTest test
fi


if [[ $1 == "copy" ]]; then
  jmeter_lib="/usr/local/Cellar/jmeter/5.0/libexec/lib"
  echo "copy jar to jmeter lib (${jmeter_lib}):"
  cp ${target_jar} ${jmeter_lib}/ext
  cp ${target_jar} ${jmeter_lib}/junit

  fast_json_jar="${HOME}/Workspaces/mvn_repository/com/alibaba/fastjson/1.2.62/fastjson-1.2.62.jar"
  cp ${fast_json_jar} ${jmeter_lib}/ext

  data_file="src/main/resources/data.json"
  jmeter_run_dir="${HOME}/Downloads/tmp_files/jmeter_tmp"
  if [[ -f "$(pwd)/${data_file}" ]]; then
    cp ${data_file} ${jmeter_run_dir} 
  fi
fi


echo "Jmeter app build and run DONE."

set +ue
