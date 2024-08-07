#!/bin/bash
set -e

MAX_RETRIES=30
RETRY_INTERVAL=20

for i in $(seq 1 $MAX_RETRIES); do
    KEYCLOAK_URL=$(oc get route keycloak -n keycloak-system -o jsonpath='{.status.ingress[0].host}' 2>/dev/null || echo "")
    if [[ -n "$KEYCLOAK_URL" && "$KEYCLOAK_URL" == *"keycloak-keycloak-system"* ]]; then
        OIDC_ISSUER_URL="https://${KEYCLOAK_URL}/auth/realms/trusted-artifact-signer"
        echo "Keycloak URL is available: $OIDC_ISSUER_URL"
        echo "OIDC_ISSUER_URL=${OIDC_ISSUER_URL}" >> $GITHUB_ENV
        exit 0
    else
        echo "Waiting for Keycloak URL to be available... (Attempt $i/$MAX_RETRIES)"
        sleep $RETRY_INTERVAL
    fi
done

echo "Timeout waiting for Keycloak URL to be available."
exit 1