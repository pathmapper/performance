#!/bin/bash

# ./run.sh test_plan.jmx serverinfos

START=$(date +%s)
TIMESTAMP=$(date +%Y%m%dT%H%M%S)
TEST_PLAN=$1
TEST_PLAN_NAME="${TEST_PLAN%.*}"
SERVER_INFOS=$2
WORKING_DIRECTORY=`pwd`
JMETER_DIRECTORY=/home/user/dev/jmeter/apache-jmeter-5.6.3/bin

echo TIMESTAMP: $TIMESTAMP
echo TEST_PLAN: $TEST_PLAN
echo SERVER_INFOS: $SERVER_INFOS
echo WORKING_DIRECTORY: $WORKING_DIRECTORY
echo JMETER_DIRECTORY: $JMETER_DIRECTORY

RESULT_DIRECTORY=$WORKING_DIRECTORY/"$TEST_PLAN_NAME"_"$TIMESTAMP"_"$SERVER_INFOS"
OUTPUT_FILENAME=$RESULT_DIRECTORY/"$TEST_PLAN_NAME"_"$TIMESTAMP"_"$SERVER_INFOS"

mkdir -p "$RESULT_DIRECTORY"/report

iperf3 -c 188.34.205.104 -> $RESULT_DIRECTORY/bandwidth_upload_before_test.txt
iperf3 -c 188.34.205.104 -R -> $RESULT_DIRECTORY/bandwidth_download_before_test.txt

$JMETER_DIRECTORY/jmeter -Jjmeter.reportgenerator.overall_granularity=10000 -n -t $TEST_PLAN -j $OUTPUT_FILENAME.log -l $OUTPUT_FILENAME.jtl -e -o $RESULT_DIRECTORY/report

iperf3 -c 188.34.205.104 -> $RESULT_DIRECTORY/bandwidth_upload_after_test.txt
iperf3 -c 188.34.205.104 -R -> $RESULT_DIRECTORY/bandwidth_download_after_test.txt

END=$(date +%s)
EXECUTION_TIME=$((END- START))

HOURS=$((EXECUTION_TIME / 3600))
MINUTES=$(( (EXECUTION_TIME % 3600) / 60 ))
SECONDS=$((EXECUTION_TIME % 60))

echo "Execution time: $HOURS hours, $MINUTES minutes, and $SECONDS seconds"
