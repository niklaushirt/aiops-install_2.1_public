kubectl create ns sock-shop

oc adm policy add-scc-to-user privileged -n sock-shop -z default
oc create clusterrolebinding default-sock-shop-admin --clusterrole=cluster-admin --serviceaccount=sock-shop:default



kubectl apply -n sock-shop -f ./demo/sockshop/sockshop-complete.yaml



Get Humio output

"kubernetes.namespace_name" = sock-shop 
| "kubernetes.pod_name" = /carts|catalogue|front-end|order/i |  "kubernetes.pod_name" != /carts-db|catalogue-db/i | stripAnsiCodes(@rawstring)
| "@rawstring" != / 500 /i


"kubernetes.namespace_name" = sock-shop 
| "kubernetes.pod_name" = /carts|front-end/i |  "kubernetes.pod_name" != /carts-db|catalogue-db/i | stripAnsiCodes(@rawstring)
| "@rawstring" != / 500 /i



apiVersion: extensions/v1
kind: Deployment
metadata:
  name: sock-shop-load-test
  namespace: default
  labels:
    name: sock-shop-load-test
  namespace: loadtest
spec:
  replicas: 2
  template:
    metadata:
      labels:
        name: sock-shop-load-test
    spec:
      containers:
      - name: load-test
        image: weaveworksdemos/load-test:0.1.1
        command: ["/bin/sh"]
        args: ["-c", "while true; do locust --host http://front-end.sock-shop.svc.cluster.local -f /config/locustfile.py --clients 5 --hatch-rate 5 --num-request 100 --no-web; done"]
      nodeSelector:
        beta.kubernetes.io/os: linux