#!/usr/bin/env bash

# TODO: ignore errors for now:
# set -e

JNC_TARGET_DIR=target/generated-sources/jnc/src/gen

if [[ -f ${JNC_TARGET_DIR}/.uptodate ]]
then
    exit 0
fi


PYANG_PLUGINDIR=src/main/python

PYANG_FLAGS="--strict --max-line-length=70 --lint --lint-modulename-prefix=bbf --lint-namespace-prefix=urn:bbf:yang: --verbose --path=src/main/yang --jnc-ignore-errors"

BBF_YANG_FILES=`find src/main/yang/bbf/standard -name "*.yang"`
IETF_YANG_FILES=`find src/main/yang/ietf -name "*.yang"`


for f in ${BBF_YANG_FILES}
do
    echo ""
    echo pyang --plugindir ${PWD}/${PYANG_PLUGINDIR} -f jnc ${PYANG_FLAGS} ${f} --jnc-output=${JNC_TARGET_DIR}
    pyang --plugindir ${PWD}/${PYANG_PLUGINDIR} -f jnc ${PYANG_FLAGS} ${f} --jnc-output=${JNC_TARGET_DIR}
done

touch ${JNC_TARGET_DIR}/.uptodate

# TODO: these contain bugs, so deleting them for now:
find ${JNC_TARGET_DIR} -name package-info.java | xargs rm -f
