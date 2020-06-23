# MetalLB
MetalLB is a load-balancer implementation for baremetal [Kubernetes](https://kubernetes.io) clusters, using standard routing protocols.
This quick guide will set you up a metallb as external load balancer on local kubernetes cluster by following steps and eventually getting everything to run smoothly.

## Option 1: MetalLB with Manifests,
### For installation of load balancer(Metallb) to allow nodes to communicate with the external world, apply the manifest:
```bash
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.3/manifests/namespace.yaml
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.3/manifests/metallb.yaml
# On first install only
kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)"
```
#### Now, Configures MetalLB in Layer 2 mode 
Create a config file named `metallb-config.yaml` to give a range of ip address the load balancer can assign. Make sure those IPs can't be assigned by your DHCP server.

`Source https://metallb.universe.tf/configuration/`  

Finally, apply the load balancer config.

```bash
kubectl apply -f metallb-config.yaml
```

## Option 2: MetalLB with Helm,  
### you simply need to run the following command `helm install` ... with:
 ```bash
 helm install metallb stable/metallb --namespace kube-system \
  --set configInline.address-pools[0].name=default \
  --set configInline.address-pools[0].protocol=layer2 \
  --set configInline.address-pools[0].addresses[0]=192.168.0.240-192.168.0.250
```
All done, after a few seconds you should observe the MetalLB components deployed for an application.

Check out [MetalLB's website](https://metallb.universe.tf) for additional information.
