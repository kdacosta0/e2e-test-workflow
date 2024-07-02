#!/bin/bash
set -e

MAX_RETRIES=30
RETRY_INTERVAL=10

for i in $(seq 1 $MAX_RETRIES); do
    if oc get csv -n openshift-operators | grep 'rhtas-operator' | grep 'Succeeded'; then
        echo "rhtas-operator is ready."
        exit 0
    else
        echo "Waiting for rhtas-operator to be ready... (Attempt $i/$MAX_RETRIES)"
        sleep $RETRY_INTERVAL
    fi
done

echo "Timeout waiting for rhtas-operator to be ready."
exit 1