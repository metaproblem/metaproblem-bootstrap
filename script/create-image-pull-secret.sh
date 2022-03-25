#!/usr/bin/env bash

encoded=`echo $CONTAINER_REPO_CREDS | base64`

cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Secret
metadata:
  name: registry-credentials
  namespace: default
data:
  .dockerconfigjson: $CONTAINER_REGISTRY_CREDS
type: kubernetes.io/dockerconfigjson
EOF
