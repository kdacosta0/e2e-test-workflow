#!/bin/bash

# Delete the Subscriptions
echo "Deleting Subscriptions..."
oc delete namespace keycloak-system
oc delete subscription rhtas-operator -n openshift-operators

# Delete the OperatorGroup
echo "Deleting OperatorGroup..."
oc delete operatorgroup keycloak-system-trusted-artifact-signer -n keycloak-system

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