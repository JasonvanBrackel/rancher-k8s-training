# Training Guide

## Deploy K3s

```bash
k3sup install --ip=13.90.136.15 --user=jason --k3s-version=v1.17.0+k3s.1
```

## Kubernetes

### Pod

``` bash
kubectl apply -f pod.yaml
kubectl logs myapp-pod
kubectl get po -w
kubectl delete po myapp-pod
```

### Deployment

- we can launch random stuff, but this isn't repeatable

``` bash
kubectl create deploy nginx --image=nginx:1.16-alpine
kubectl get deploy
kubectl get po
kubectl delete deploy/nginx
```

- launch again using kustomize templates

```
kubectl create deploy nginx --image=nginx:1.16-alpine --dry-run -o yaml > deployment/base/deployment.yaml
kubectl apply -k deployment/base
kubectl get deploy
kubectl get po
```

- describe pod, look at the image
- scale deployment manually

``` bash
kubectl scale deploy/nginx --replicas=3
kubectl rollout status deploy/nginx
kubectl get deploy
kubectl get po
```

- upgrade with bad image

``` bash
kubectl set image deploy/nginx nginx=nginx:1.17-alpne --record
kubectl rollout status deploy/nginx
kubectl get po
kubectl rollout undo deploy/nginx
```

- redo upgrade from manifest

``` bash
kustomize build deployment/base
```

- edit base to change image and then apply

```bash
kubectl apply -k deployment/base
```

- how can we use this for different environments?

```bash
kustomize build deployment/overlay/staging
kustomize build deployment/overlay/production

kubectl apply -k deployment/overlay/staging
kubectl apply -k deployment/overlay/production
kubectl get deploy
kubectl get pods
```

### Services

- show services listening as NodePort
- go look at them

``` bash
curl -I training-a:<port>
```

### Ingress

- show `deployment/overlay/ingress/single/ingress.yaml`

``` bash
kubectl apply -k deployment/overlay/ingress/single
kubectl get ingress
```

- visit <https://13.90.136.15>
- what about multiple apps?

``` bash
kustomize build deployment/overlay/ingress/fanout
kubectl apply -k deployment/overlay/ingress/fanout 
```

- visit <https://13.90.136.15> (fail)
- visit <https://training.cl.monach.us/nginx> (works)
- deploy rancher-demo application

```bash
kustomize build rancher-demo/base
kubectl apply -k rancher-demo/base
```

- visit <https://13.90.136.15/>

## Rancher

### Server Deploy

```
docker run -d --restart=unless-stopped -p 80:80 -p 443:443 -v /opt/rancher:/var/lib/rancher rancher/rancher:v2.3.4
```

### Node Deploy

- Show how we would deploy an RKE cluster
- Import the `training-a` k3s cluster

### Rancher Server Walkthrough

- Clusters
- Authentication & Security
- Storage
- Projects
- Namespaces
- Catalogs
- CLI/API/Kubectl

### Application Deployment

- show workloads on running cluster
- edit them / delete them
- redeploy `monachus/rancher-demo` as a workload
    - expose port 8080
- put an Ingress in front of it
    - use `13.90.136.15`
- scale it

## Rancher Application Catalog

- use the Hadoop example