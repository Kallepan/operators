#!/bin/bash

# exit on error
set -e

### VARIABLES ###
VERSION=0.0.1
IMG_TAG_BASE=docker.io/kallepan/homelab
RQ_OPERATOR_BUNDLE_TAG=0.0.1

### OPERATOR ###
# Build the manager binary
cd homelab-operator

# Test the operator
make test

# Generate manifests e.g. CRD, RBAC etc.
make generate manifests

# Build the operator image
OPERATOR_IMG=$IMG_TAG_BASE-operator:$VERSION
make docker-build docker-push IMG=$OPERATOR_IMG

### BUNDLE ###
BUNDLE_IMG=${IMG_TAG_BASE}-bundle:$VERSION
make bundle IMG=$BUNDLE_IMG VERSION=$VERSION
make bundle-build bundle-push BUNDLE_IMG=$BUNDLE_IMG

### CATALOG ###
cd ../catalog

# Generate the catalog
CATALOG_IMG=${IMG_TAG_BASE}-catalog:$VERSION
cp operator-template.yaml operator.yaml
sed -i s/RQ_OPERATOR_BUNDLE_TAG/$RQ_OPERATOR_BUNDLE_TAG/g operator.yaml
opm alpha render-template semver -o yaml < operator.yaml > homelab-catalog/catalog.yaml

# Build the catalog image
docker build --platform linux/amd64 -f homelab-catalog.Dockerfile -t $CATALOG_IMG .
docker push $CATALOG_IMG
