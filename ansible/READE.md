To deploy cluster:
1. Run `ansible-playbook -i master-hosts.yaml kubeadm-master.yaml -e first_run=true -e fetch_config=true`
2. Run `ansible-playbook -i nodes-hosts.yaml kubeadm-nodes.yaml -e first_run=true`
3. Do CNI stuff
4. Run `ansible-playbook -i nodes-hosts.yaml kubeadm-join-cluster.yaml -e ip="<>" -e token="<>" -e hash="<>"` based on output from #1
5. Run `kubectl apply -f https://github.com/flannel-io/flannel/releases/latest/download/kube-flannel.yml`

Nice to haves
```
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
```