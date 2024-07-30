#!/bin/bash

# Delete the Subscriptions
NAMESPACE="keycloak-system"

echo "Attempting to delete namespace $NAMESPACE..."
oc delete namespace $NAMESPACE

echo "Deleting RHTAS Operator"
oc delete subscription rhtas-operator -n openshift-operators

# Delete the CSV (ClusterServiceVersion)
echo "Deleting ClusterServiceVersions..."

# For RHTAS Operator
RHTAS_CSV=$(oc get csv -n openshift-operators | grep rhtas-operator | awk '{print $1}')
if [ ! -z "$RHTAS_CSV" ]; then
    oc delete csv $RHTAS_CSV -n openshift-operators
else
    echo "No CSV found for RHTAS Operator"
fi

echo "Uninstallation process completed. Please verify that all resources have been removed."