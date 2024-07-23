#!/bin/bash

### Install the Operator SDK ###
# Adapted from https://sdk.operatorframework.io/docs/installation/
export ARCH=$(case $(uname -m) in x86_64) echo -n amd64 ;; aarch64) echo -n arm64 ;; *) echo -n $(uname -m) ;; esac)
export OS=$(uname | awk '{print tolower($0)}')

# Install the Operator SDK
export OPERATOR_SDK_DL_URL=https://github.com/operator-framework/operator-sdk/releases/download/v1.35.0
curl -LO ${OPERATOR_SDK_DL_URL}/operator-sdk_${OS}_${ARCH}
chmod +x operator-sdk_${OS}_${ARCH} && sudo mv operator-sdk_${OS}_${ARCH} /usr/local/bin/operator-sdk

# Install the Operator Registry
export OPERATOR_REGISTRY_DL_URL=https://github.com/operator-framework/operator-registry/releases/download/v1.45.0
curl -LO ${OPERATOR_REGISTRY_DL_URL}/${OS}-${ARCH}-opm
chmod +x ${OS}-${ARCH}-opm && sudo mv ${OS}-${ARCH}-opm /usr/local/bin/opm