


Strimzi Operator

    listeners:
      external:
        type: route



oc get KafkaTopic --all-namespaces

oc exec -it $(oc get po |grep kafka-cat|awk '{print$1}') bash

oc get secret token -n zen --template={{.data.password}} | base64 --decode
# oc -n zen create route passthrough strimzi-cluster-kafka-bootstrap --service=strimzi-cluster-kafka-bootstrap --port=tcp-clientstls --insecure-policy=None
oc get routes -n zen strimzi-cluster-kafka-bootstrap -o=jsonpath='{.status.ingress[0].host}{"\n"}'




kafkacat -v -X security.protocol=SSL -X ssl.ca.location=/root/certs2/ca.crt -X sasl.mechanisms=SCRAM-SHA-512 -X sasl.username=token -X sasl.password=CJ70n0qpDXdv -b strimzi-cluster-kafka-bootstrap-zen.tec-cp4aiops-21-3c14aa1ff2da1901bfc7ad8b495c85d9-0000.eu-de.containers.appdomain.cloud:443 -C -t alerts-noi-jjndsrlx-zunhhxsr
