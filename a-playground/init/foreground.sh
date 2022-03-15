FILE=/ks/wait-init.sh; while ! test -f ${FILE}; do clear; sleep 0.1; done; bash ${FILE}
curl -L https://istio.io/downloadIstio | ISTIO_VERSION=1.13.2 TARGET_ARCH=x86_64 sh -
echo 'export PATH=/root/istio-1.13.2/bin:$PATH' >> .bashrc
export PATH=/root/istio-1.13.2/bin:$PATH
/root/istio-1.13.2/bin/istioctl install --set profile=demo -y