
Istio has been installed like described here:

https://istio.io/latest/docs/setup/getting-started

Check the installed version:

```plain
istioctl version
```{{exec}}

Next we install the [helloworld example](https://github.com/istio/istio/tree/master/samples/helloworld):

```plain
kubectl apply -f /root/istio-1.13.3/samples/helloworld/helloworld.yaml
kubectl apply -f /root/istio-1.13.3/samples/helloworld/helloworld-gateway.yaml
kubectl wait deploy/helloworld-v1 --for condition=available --timeout=1h
kubectl wait deploy/helloworld-v2 --for condition=available --timeout=1h
```{{exec}}

Now we port-forward to the Istio ingressgateway service:

```plain
kubectl port-forward -n istio-system --address 0.0.0.0 service/istio-ingressgateway 1234:80
```{{exec}}

Finally [ACCESS]({{TRAFFIC_HOST1_1234}}/hello) the helloworld app through Istio:


There are also more examples to try in `/root/istio-1.13.3/samples`.
