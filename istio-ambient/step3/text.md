In this section we will enforce authorization policies in our mesh

### Enforce authorization policies

After adding the application to the ambient mesh, we can secure application access using `Layer 4` and `Layer 7` authorization policies.

This feature lets you control access to and from a service based on the client workload identities that are automatically issued to all workloads in the mesh.

### Enforce Layer 4 authorization policy

Let’s create an authorization policy that restricts which services can communicate with the productpage service. 

The policy is applied to pods with the `app: productpage` label, and it allows calls only from the the service account `cluster.local/ns/default/sa/bookinfo-gateway-istio`. This is the service account that is used by the **Bookinfo gateway** we deployed in the previous step.

First, make sure to port-forward the Bookinfo productpage service:

```plain
kubectl port-forward --address 0.0.0.0  svc/bookinfo-gateway-istio 1234:80
```{{exec}}

Then, create the authorization policy:

```plain
kubectl apply -f - <<EOF
apiVersion: security.istio.io/v1
kind: AuthorizationPolicy
metadata:
  name: productpage-viewer
  namespace: default
spec:
  selector:
    matchLabels:
      app: productpage
  action: ALLOW
  rules:
  - from:
    - source:
        principals:
        - cluster.local/ns/default/sa/bookinfo-gateway-istio
EOF
```{{exec}}


If you open the Bookinfo application in your browser [here]({{TRAFFIC_HOST1_1234}}/productpage), you will see the product page, just as before. However, if you try to access the productpage service from a different service account, you should see an error.


Let’s try accessing Bookinfo application from a different client in the cluster:

```plain
kubectl apply -f https://raw.githubusercontent.com/istio/istio/refs/heads/master/samples/curl/curl.yaml
```{{exec}}

Since the curl pod is using a different service account, it will not have access the productpage service:

```plain
kubectl exec deploy/curl -- curl -s "http://productpage:9080/productpage"
```{{exec}}

You should see below error:

```plain
command terminated with exit code 56
```

### Enforce Layer 7 authorization policy

To enforce Layer 7 policies, you first need a `waypoint proxy` for the namespace. This proxy will handle all Layer 7 traffic entering the namespace.

```plain
istioctl waypoint apply --enroll-namespace --wait
```{{exec}}

You can view the waypoint proxy and make sure it has the `Programmed=True` status:

```plain
kubectl get gtw waypoint
```{{exec}}

Adding a `L7 authorization policy` will explicitly allow the `curl` service to send GET requests to the productpage service, but perform no other operations:

```plain
kubectl delete authorizationpolicies.security.istio.io productpage-viewer
kubectl apply -f - <<EOF
apiVersion: security.istio.io/v1
kind: AuthorizationPolicy
metadata:
  name: productpage-viewer
  namespace: default
spec:
  targetRefs:
  - kind: Service
    group: ""
    name: productpage
  action: ALLOW
  rules:
  - from:
    - source:
        principals:
        - cluster.local/ns/default/sa/curl
    to:
    - operation:
        methods: ["GET"]
EOF
```{{exec}}

Confirm the new waypoint proxy is enforcing the updated authorization policy:

This fails with an RBAC error because you're not using a GET operation:

```plain
kubectl exec deploy/curl -- curl -s "http://productpage:9080/productpage" -X DELETE
```{{exec}}

You should get:

```plain
RBAC: access denied
```

This works as you're explicitly allowing GET requests from the curl pod

```plain
kubectl exec deploy/curl -- curl -s http://productpage:9080/productpage | grep -o "<title>.*</title>"
```{{exec}}