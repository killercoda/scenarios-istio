Now in this step we will secure and visualize the Application

### Add Bookinfo to the Mesh

Enable all pods in the `default` namespace to be part of an ambient mesh by labeling the namespace:

```plain
kubectl label namespace default istio.io/dataplane-mode=ambient
```{{exec}}

### Visualize the Application and Metrics

Using Istio’s dashboard, Kiali, and the Prometheus metrics engine, you can visualize the Bookinfo application. Deploy them both:

```plain
kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.24/samples/addons/prometheus.yaml
kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.24/samples/addons/kiali.yaml
```{{exec}}

### Patch Kiali Service to Use Port 80

For demo purposes, patch the Kiali service to use port 80:

```plain
kubectl patch svc kiali -n istio-system --type='json' -p='[{"op": "remove", "path": "/spec/ports/0"}]'
kubectl patch svc kiali -n istio-system --type='json' -p='[{"op": "add", "path": "/spec/ports/-", "value": {"appProtocol": "http", "name": "http", "port": 80, "protocol": "TCP", "targetPort": 20001}}]'
```{{exec}}

### Access the Kiali Dashboard

Run the following command to access the Kiali dashboard:

```plain
kubectl port-forward svc/kiali --address 0.0.0.0 -n istio-system 3456:80
```{{exec}}

###  Generate Traffic for Visualization

Open a new command tab and send some traffic to the Bookinfo application to generate the traffic graph in Kiali:

```plain
for i in $(seq 1 100); do curl -sSI -o /dev/null http://localhost:3456/productpage; done
```{{exec}}


### Access kiali

will connect to the kiali UI.


Click here to [ACCESS]({{TRAFFIC_HOST1_3456}}) Kiali UI <small>(or [select the port here]({{TRAFFIC_SELECTOR}}))</small>.

Next, click on the Traffic Graph and select “Default” from the “Select Namespaces” drop-down. You should see the Bookinfo application.
