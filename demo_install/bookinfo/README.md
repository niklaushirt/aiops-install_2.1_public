oc create ns bookinfo


oc apply -n bookinfo -f ./demo/bookinfo/bookinfo.yaml
oc apply -n bookinfo -f ./demo/bookinfo/bookinfo-gateway.yaml
oc apply -n bookinfo -f ./demo/bookinfo/destination-rule-all.yaml
oc apply -n bookinfo -f ./demo/bookinfo/virtual-service-reviews-100-v2.yaml



"kubernetes.namespace_name" = bookinfo 
| stripAnsiCodes(@rawstring)
| "@rawstring" != /error/i
| "kubernetes.pod_name" = /ratings||reviews-v2/i