
Create Bastion Pod

```bash
kubectl apply -n default -f ./tools/6_bastion/create-bastion.yaml
```

Create Automation

```bash
oc login --token=$token --server=$ocp_url
kubectl scale deployment --replicas=1 -n bookinfo ratings-v1
```

```yaml
target: bastion-host-service.default.svc
user:   root
$token		
$ocp_url		
```


