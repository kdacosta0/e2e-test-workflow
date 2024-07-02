#!/bin/bash
set -e

MAX_RETRIES=30
RETRY_INTERVAL=10

for i in $(seq 1 $MAX_RETRIES); do
    if oc get pods -n keycloak-system | grep -E 'Running|Completed'; then
        echo "Keycloak system pods are running."
        exit 0
    else
        echo "Waiting for Keycloak system pods to be running... (Attempt $i/$MAX_RETRIES)"
        sleep $RETRY_INTERVAL
    fi
done

echo "Timeout waiting for Keycloak system pods to be running."
exit 1