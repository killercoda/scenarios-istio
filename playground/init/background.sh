#!/bin/bash

# wait fo k8s ready
while [ ! -f /root/.kube/config ]
do
  sleep 1
done
while ! kubectl get nodes | grep -w "Ready"; do
  echo "WAIT FOR NODES READY"
  sleep 1
done
touch /ks/.k8sfinished


# allow pods to run on controlplane
kubectl taint nodes controlplane node-role.kubernetes.io/master:NoSchedule-

# mark init finished
touch /ks/.initfinished
