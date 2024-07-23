#!/bin/bash

export VERSION=0.0.1
export IMG_TAG_BASE=docker.io/kallepan/rq-operator
export IMG=$IMG_TAG_BASE:$VERSION
CATALOG_IMG_BASE=docker.io/kallepan/homelab

# Build the manager binary
cd rq-operator

# Generate manifests e.g. CRD, RBAC etc.
make generate manifests

# Build the docker image
make docker-build docker-push

# Build the bundle
BUNDLE_IMG=${IMG_TAG_BASE}-bundle:$VERSION
make bundle bundle-build bundle-push BUNDLE_IMG=$BUNDLE_IMG

# Build the catalog
CATALOG_IMG=${CATALOG_IMG_BASE}-catalog:$VERSION
make catalog-build catalog-push BUNDLE_IMGS=$BUNDLE_IMG CATALOG_IMG=$CATALOG_IMG

# operator-sdk run bundle $BUNDLE_IMG 