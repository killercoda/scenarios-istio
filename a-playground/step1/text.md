
Istio has been installed like described here:

https://istio.io/latest/docs/setup/getting-started

Check the installed version:

```plain
istioctl version
```{{exec}}

You could for example deploy a sample application now:

https://istio.io/latest/docs/setup/getting-started/#bookinfo

See examples:

```plain
cd /root/istio-1.13.2/samples
ls -lh
```{{exec}}

Install example bookinfo:

```plain
kubectl apply -f /root/istio-1.13.2/samples/bookinfo/platform/kube/bookinfo.yaml
```{{exec}}
