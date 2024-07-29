#!/bin/bash

# Delete the Subscriptions
echo "Deleting Subscriptions..."
oc delete subscription rhsso-operator -n keycloak-system
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

# Remove finalizers from CRDs
echo "Removing finalizers from CRDs..."
for crd in $(oc get crd | grep -E 'keycloak.org|rhtas.redhat.com' | awk '{print $1}'); do
    echo "Removing finalizer from CRD: $crd"
    oc patch crd $crd -p '{"metadata":{"finalizers":[]}}' --type=merge
done

# Delete any remaining Custom Resource Definitions (CRDs)
echo "Deleting Custom Resource Definitions..."
for crd in $(oc get crd | grep -E 'keycloak.org|rhtas.redhat.com' | awk '{print $1}'); do
    echo "Deleting CRD: $crd"
    oc delete crd $crd
done

# Clean up any remaining resources
echo "Cleaning up remaining resources..."
oc delete all -l app=rhsso -n keycloak-system
oc delete all -l app=rhtas -n openshift-operators

echo "Uninstallation process completed. Please verify that all resources have been removed."