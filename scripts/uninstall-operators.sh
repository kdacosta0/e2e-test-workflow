#!/bin/bash

# Delete the Subscriptions
NAMESPACE="keycloak-system"

echo "Attempting to delete namespace $NAMESPACE..."
oc delete namespace $NAMESPACE &

# Function to check namespace status
check_namespace() {
    for i in {1..30}; do
        if oc get namespace $NAMESPACE -o json 2>/dev/null | jq -r '.status.phase' | grep -q "Terminating"; then
            echo "Namespace is still terminating. Removing finalizers..."
            oc patch namespace $NAMESPACE -p '{"metadata":{"finalizers":[]}}' --type=merge
            sleep 5
        else
            echo "Namespace $NAMESPACE has been deleted."
            return 0
        fi
    done
    echo "Namespace $NAMESPACE is still not deleted after multiple attempts. Manual intervention may be required."
    return 1
}

# Run the check function in the background
check_namespace &

# Wait for all background jobs to finish
wait

echo "Deleting RHTAS Operator"
oc delete subscription rhtas-operator -n openshift-operators

# Delete the CSV (ClusterServiceVersion)
echo "Deleting ClusterServiceVersions..."
# For RHSSO Operator
RHSSO_CSV=$(oc get csv -n keycloak-system | grep rhsso-operator | awk '{print $1}')
if [ ! -z "$RHSSO_CSV" ]; then
    oc delete csv $RHSSO_CSV -n keycloak-system
else
    echo "No CSV found for RHSSO Operator"
fi

# For RHTAS Operator
RHTAS_CSV=$(oc get csv -n openshift-operators | grep rhtas-operator | awk '{print $1}')
if [ ! -z "$RHTAS_CSV" ]; then
    oc delete csv $RHTAS_CSV -n openshift-operators
else
    echo "No CSV found for RHTAS Operator"
fi

echo "Uninstallation process completed. Please verify that all resources have been removed."