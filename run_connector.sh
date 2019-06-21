#!/bin/bash

echo "Waiting for ${TARGET} ..."

# wait until elasticsearch is online
attempt_counter=0
max_attempts=10
until $(curl -XGET --output /dev/null --silent --head --fail ${TARGET}); do

		# stop trying if max attempts was reached
    if [ ${attempt_counter} -eq ${max_attempts} ];then
      echo "Max attempts reached"
      exit 1
    fi
    
    # increase counter
    attempt_counter=$(($attempt_counter+1))
    sleep 5
done

# run additional script, if requested
if [ ! -z "${RUN_SCRIPT}" ]; then
    echo "Running script (${RUN_SCRIPT})"
    ${RUN_SCRIPT}
fi

echo "Starting mongo-connector: ${MAIN} -> ${TARGET} with Arguments: ${ARGS}"

mongo-connector --doc-manager elastic2_doc_manager --main ${MAIN} --target-url ${TARGET} ${ARGS}
