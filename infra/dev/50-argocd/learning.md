## ArgoCD Port Forward  
```bash
kubectl port-forward \
  -n argocd \
  svc/argocd-server \
  8090:80 \
  --address 0.0.0.0 \
  > /tmp/argocd-port-forward.log 2>&1 &

nohup kubectl port-forward \
  -n argocd \
  svc/argocd-server \
  8090:80 \
  --address 0.0.0.0 \
  > /tmp/argocd-port-forward.log 2>&1 &
```

## Initial Admin Password  
```bash
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d && echo
```

## ArgoCD cli installation  
```bash
VERSION=$(curl -L -s https://api.github.com/repos/argoproj/argo-cd/releases/latest | grep '"tag_name":' | cut -d '"' -f 4)

curl -L -o argocd-linux-amd64 \
  "https://github.com/argoproj/argo-cd/releases/download/${VERSION}/argocd-linux-amd64"

sudo install -m 755 argocd-linux-amd64 /usr/local/bin/argocd

argocd version --client

rm -f argocd-linux-amd64
```
## ArgoCD Login
```bash
argocd login --port-forward --port-forward-namespace argocd --username admin --password fA28t1mIHpNg27D8 --plaintext
```

```bash
export ARGOCD_OPTS="--port-forward --port-forward-namespace argocd --plaintext"
echo 'export ARGOCD_OPTS="--port-forward --port-forward-namespace argocd --plaintext"' >> ~/.bashrc
source ~/.bashrc

argocd app list
argocd cluster list

argocd context
```

