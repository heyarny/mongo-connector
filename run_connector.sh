#!/bin/bash

echo "Starting mongo-connector: ${MAIN} -> ${TARGET} with Arguments: ${ARGS}"

mongo-connector --doc-manager elastic2_doc_manager --main ${MAIN} --target-url ${TARGET} ${ARGS}
