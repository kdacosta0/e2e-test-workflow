#!/bin/bash
set -e

MAX_RETRIES=30
RETRY_INTERVAL=20

for i in $(seq 1 $MAX_RETRIES); do
    REKOR_URL=$(oc get rekor -o jsonpath='{.items[0].status.url}' -n trusted-artifact-signer 2>/dev/null || echo "")
    if [[ -n "$REKOR_URL" && "$REKOR_URL" == *"rekor-server-trusted-artifact-signer"* ]]; then
        echo "Rekor URL is available: $REKOR_URL"
        exit 0
    else
        echo "Waiting for Rekor URL to be available... (Attempt $i/$MAX_RETRIES)"
        sleep $RETRY_INTERVAL
    fi
done

echo "Timeout waiting for Rekor URL to be available."
exit 1