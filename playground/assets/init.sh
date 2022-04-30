#!/bin/bash

# init scenario
rm $0

# reduce k8s components resource requests
sed -i 's/cpu: .*$/cpu: 10m/g' /etc/kubernetes/manifests/kube-apiserver.yaml
sed -i 's/cpu: .*$/cpu: 10m/g' /etc/kubernetes/manifests/kube-controller-manager.yaml
sed -i 's/cpu: .*$/cpu: 10m/g' /etc/kubernetes/manifests/etcd.yaml
sed -i 's/cpu: .*$/cpu: 10m/g' /etc/kubernetes/manifests/kube-scheduler.yaml
crictl rm --force $(crictl ps -a -q --name "kube-apiserver|kube-scheduler|kube-controller|etcd")


# wait fo k8s ready
bash /ks/k8s.sh

# allow pods to run on controlplane
kubectl taint nodes controlplane node-role.kubernetes.io/master:NoSchedule-

# reduce more resources requests
while ! kubectl -n kube-system get deploy coredns; do sleep 1; done
kubectl -n kube-system patch deploy coredns --patch '{"spec": {"template": {"spec": {"containers": [{"name": "coredns", "resources": {"requests":{"cpu": "10m", "memory": "10Mi"}  }  }] }}}}'

# mark init finished
touch /ks/.initfinished
