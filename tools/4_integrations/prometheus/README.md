https://w3.ibm.com/w3publisher/tdsm-blogs/blog/74fcf0f0-5fe7-11eb-a75f-c399c7ec86f2




kubectl apply -n noi -f ./tools/4_integrations/prometheus/noi-integration.yaml

oc adm policy add-scc-to-user privileged system:serviceaccount:noi:netcool-integrations-operator



oc adm policy add-scc-to-user privileged system:serviceaccount:noi:example-prometheusprobe-ibm-netcool-probe-sa


kind: NetworkPolicy
apiVersion: networking.k8s.io/v1
metadata:
  name: noi-integration
  namespace: noi
spec:
  podSelector:
    matchLabels:
      release: noi
  ingress:
    - from:
        - namespaceSelector: {}
        - podSelector: {}
  policyTypes:
    - Ingress

oc exec -it alertmanager-main-0 -n openshift-monitoring /bin/bash
amtool alert add ratings instance=ratings-v1 severity=critical --annotation=summary='Alert Name: Bookinfo had some small simulated problem' --annotation=runbook='http://runbook.biz' --alertmanager.url=http://localhost:9093


oc exec -it alertmanager-main-0 -n openshift-monitoring -c alertmanager -- amtool alert add ratings instance=ratings-v1 severity=critical --annotation=summary='Alert Name: Bookinfo had some small simulated problem' --annotation=runbook='http://runbook.biz' --alertmanager.url=http://localhost:9093

