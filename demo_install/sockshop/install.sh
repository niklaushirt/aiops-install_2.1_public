


oc create ns sockshop
oc adm policy add-scc-to-user privileged -n sockshop -z default
oc create clusterrolebinding default-sockshop-admin --clusterrole=cluster-admin --serviceaccount=sockshop:default



kubectl apply -n sockshop -f dep.yaml











kubectl apply -n sockshop -f sockshop-gateway.yaml
oc create serviceaccount noi-service-account -n $WAIOPS_EVENT_MGR_NAMESPACE || true
oc adm policy add-scc-to-user privileged system:serviceaccount:namespace:noi-service-account || true
oc create clusterrolebinding sockshop-admin --clusterrole=cluster-admin --serviceaccount=sockshop:sockshop
oc create clusterrolebinding default-admin --clusterrole=cluster-admin --serviceaccount=sockshop:default

