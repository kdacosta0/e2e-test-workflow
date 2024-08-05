#!/bin/bash
set -e

MAX_RETRIES=30
RETRY_INTERVAL=10

echo "Waiting for InstallPlan to be created..."

for i in $(seq 1 $MAX_RETRIES); do
    INSTALL_PLAN=$(oc get installplan -n openshift-operators -o json | jq -r '.items[] | select(.spec.clusterServiceVersionNames[0] | startswith("rhtas-operator.v")) | .metadata.name' | tail -n1)
    
    if [ -n "$INSTALL_PLAN" ]; then
        echo "InstallPlan found: $INSTALL_PLAN"
        echo "Approving InstallPlan: $INSTALL_PLAN"
        oc patch installplan $INSTALL_PLAN -n openshift-operators --type merge --patch '{"spec":{"approved":true}}'
        
        echo "Waiting for rhtas-operator to be ready..."
        for j in $(seq 1 $MAX_RETRIES); do
            if oc get csv -n openshift-operators | grep 'rhtas-operator' | grep 'Succeeded'; then
                echo "rhtas-operator is ready."
                exit 0
            else
                echo "Waiting for rhtas-operator to be ready... (Attempt $j/$MAX_RETRIES)"
                sleep $RETRY_INTERVAL
            fi
        done
        
        echo "Timeout waiting for rhtas-operator to be ready."
        exit 1
    fi
    
    echo "Attempt $i/$MAX_RETRIES: No suitable InstallPlan found yet. Waiting $RETRY_INTERVAL seconds..."
    sleep $RETRY_INTERVAL
done

echo "No suitable InstallPlan found after $((MAX_RETRIES * RETRY_INTERVAL)) seconds. Exiting."
exit 1