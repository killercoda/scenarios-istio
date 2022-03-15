#!/bin/bash

# init scenario
rm $0
bash /ks/k8s.sh
mkdir -p /opt/ks
cat <<EOT > /root/.vimrc
set expandtab
set tabstop=2
set shiftwidth=2
EOT

# scenario specific
kubectl taint nodes controlplane node-role.kubernetes.io/master:NoSchedule-

# mark init finished
touch /ks/.initfinished
