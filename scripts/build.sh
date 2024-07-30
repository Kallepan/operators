#!/bin/bash

# exit on error
set -e

VERSION=0.0.1
IMG_TAG_BASE=docker.io/kallepan/rq-operator
CATALOG_IMG_BASE=docker.io/kallepan/homelab
RQ_OPERATOR_BUNDLE_TAG=0.0.1

# Build the manager binary
cd rq-operator

# Generate manifests e.g. CRD, RBAC etc.
# make generate manifests

# Build the docker image
IMG=$IMG_TAG_BASE:$VERSION
make docker-build docker-push IMG=$IMG

# Build the bundle
BUNDLE_IMG=${IMG_TAG_BASE}-bundle:$VERSION
make bundle IMG=$BUNDLE_IMG VERSION=$VERSION
make bundle-build bundle-push BUNDLE_IMG=$BUNDLE_IMG

# Build the catalog
cd ../catalog

CATALOG_IMG=${CATALOG_IMG_BASE}-catalog:$VERSION
sed -i s/RQ_OPERATOR_BUNDLE_TAG/$RQ_OPERATOR_BUNDLE_TAG/g operator-template.yaml
opm alpha render-template semver -o yaml < operator-template.yaml > homelab-catalog/catalog.yaml
docker build --platform linux/amd64 -f homelab-catalog.Dockerfile -t $CATALOG_IMG .
docker push $CATALOG_IMG

# operator-sdk run bundle $BUNDLE_IMG 