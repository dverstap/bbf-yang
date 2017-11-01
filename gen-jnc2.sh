#!/usr/bin/env bash

set -e

PYANG_PLUGINDIR=src/main/python

PYANG_FLAGS="--strict --max-line-length=70 --lint --lint-modulename-prefix=bbf --lint-namespace-prefix=urn:bbf:yang: --verbose --path=src/main/yang --jnc-ignore-errors"

BBF_YANG_FILES=`find src/main/yang/bbf/standard -name "*.yang"`
IETF_YANG_FILES=`find src/main/yang/ietf -name "*.yang"`

JNC_TARGET_DIR=target/generated-sources/jnc/src/gen

MODULE_NAME="bbf-fiber"
MODULE_FILE=`find src/main/yang/bbf/ -name "${MODULE_NAME}.yang"`
SUB_MODULE_FILES=`find src/main/yang/bbf/ -name "*.yang" | xargs grep "belongs-to" | grep ${MODULE_NAME}  | cut -d: -f1`

for f in ${BBF_YANG_FILES}
do
    echo ""
    pyang --plugindir ${PWD}/${PYANG_PLUGINDIR} -f jnc ${PYANG_FLAGS} ${MODULE_FILE} ${SUB_MODULE_FILES} --jnc-output=${JNC_TARGET_DIR}
done
