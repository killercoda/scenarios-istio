Istio Ambient mode has been installed like described [here](https://istio.io/latest/docs/ambient/getting-started/).

Check the installed version:

```plain
istioctl version
```{{exec}}

<br>

### Install the Kubernetes Gateway API CRDs

The Kubernetes Gateway API CRDs do not come installed by default on most Kubernetes clusters, so make sure they are installed before using the Gateway API:

```plain
$ kubectl get crd gateways.gateway.networking.k8s.io &> /dev/null || \
  { kubectl apply -f https://github.com/kubernetes-sigs/gateway-api/releases/download/v1.2.0/standard-install.yaml; }
```{{exec}}

### Deploy Bookinfo sample application

As part of this guide, you’ll deploy the [Bookinfo](https://istio.io/latest/docs/examples/bookinfo/) application and expose the `productpage` service using an ingress gateway.

```plain
kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.24/samples/bookinfo/platform/kube/bookinfo.yaml
kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.24/samples/bookinfo/platform/kube/bookinfo-versions.yaml
```{{exec}}

To verify that the application is running, check the status of the pods:

```plain
kubectl get pods
```{{exec}}

### Deploy and configure the ingress gateway

We will use the Kubernetes Gateway API to deploy a gateway called bookinfo-gateway:

```plain
kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.24/samples/bookinfo/gateway-api/bookinfo-gateway.yaml
```{{exec}}

By default, Istio creates a LoadBalancer service for a gateway. As you will access this gateway by a tunnel, you don’t need a load balancer. Change the service type to ClusterIP by annotating the gateway:

```plain
kubectl annotate gateway bookinfo-gateway networking.istio.io/service-type=ClusterIP --namespace=default
```{{exec}}

To check the status of the gateway, run:

```plain
kubectl get gateway
```{{exec}}

### Access the application

will connect to the Bookinfo productpage service through the gateway you just provisioned. To access the gateway, we need to use the kubectl port-forward command:

```plain
kubectl port-forward --address 0.0.0.0  svc/bookinfo-gateway-istio 1234:80
```{{exec}}

And then [ACCESS]({{TRAFFIC_HOST1_1234}}/productpage) Istio <small>(or [select the port here]({{TRAFFIC_SELECTOR}}))</small>.


### Install samples
There are samples to install in `/root/istio-1.24.1/samples`.
