#!/bin/bash
set -e

MAX_RETRIES=30
RETRY_INTERVAL=10

NAMESPACE="trusted-artifact-signer"

echo "Waiting for namespace $NAMESPACE to be available..."

for i in $(seq 1 $MAX_RETRIES); do
    if oc get namespace "$NAMESPACE" > /dev/null 2>&1; then
        echo "Namespace $NAMESPACE is now available."
        exit 0
    else
        echo "Waiting for $NAMESPACE namespace to be available... (Attempt $i/$MAX_RETRIES)"
        sleep $RETRY_INTERVAL
    fi
done

echo "Timeout waiting for $NAMESPACE namespace to be available."
exit 1