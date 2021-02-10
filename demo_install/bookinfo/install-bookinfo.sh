

oc create ns bookinfo


apiVersion: maistra.io/v1
kind: ServiceMeshMemberRoll
metadata:
  namespace: istio-system
  name: default
spec:
  members:
    - bookinfo


oc apply -n bookinfo -f ./demo/bookinfo/bookinfo.yaml
oc apply -n bookinfo -f ./demo/bookinfo/bookinfo-gateway.yaml
oc apply -n bookinfo -f ./demo/bookinfo/destination-rule-all.yaml
oc apply -n bookinfo -f ./demo/bookinfo/virtual-service-reviews-100-v2.yaml


oc scale --replicas=0  deployment ratings-v1 -n bookinfo
oc scale --replicas=1  deployment ratings-v1 -n bookinfo


      env:
        - name: LOG_DIR
          value: /tmp/logs





oc scale --replicas=0  deployment reviwes-v2 -n bookinfo

oc scale --replicas=1  deployment reviwes-v2 -n bookinfo





oc apply -n bookinfo -f ./demo/bookinfo/virtual-service-reviews-50-v2.yaml

{
  "repository": "{repo_name}",
  "timestamp": "{alert_triggered_timestamp}",
  "alert": {
    "name": "{alert_name}",
    "description": "{alert_description}",
    "query": {
      "queryString": "{query_string} ",
      "end": "{query_time_end}",
      "start": "{query_time_start}"
    },
    "notifierID": "{alert_notifier_id}",
    "id": "{alert_id}"
  },
  "warnings": "{warnings}",
  "events": {events},
  "numberOfEvents": {event_count}
}




{
  "repository": "{repo_name}",
  "timestamp": "{triggered_timestamp}",
  "alert": {
    "name": "{name}",
    "description": "{description}",
    "query": {
      "queryString": "{query_string} ",
      "end": "{query_time_end}",
      "start": "{query_time_start}"
    },
    "notifierID": "{action_id}",
    "id": "{id}"
  },
  "warnings": "{warnings}",
  "events": {events},
  "numberOfEvents": {event_count}
  }


@rawstring = /error/i



{
  "mapping": {
    "codec": "humio",
    "rolling_time": 10,
    "instance_id_field": "kubernetes.namespace_name",
    "log_entity_types": "kubernetes.namespace_name,kubernetes.container_hash,kubernetes.host,kubernetes.container_name,kubernetes.pod_name",
    "message_field": "@rawstring",
    "timestamp_field": "@timestamp"
  }
}

{
    "codec": "humio",
    "mapping": {
        "codec": "humio",
        "message_field": "@rawstring",
        "log_entity_types": "kubernetes.namespace_name,kubernetes.container_hash,kubernetes.host,kubernetes.container_name,kubernetes.pod_name",
        "instance_id_field": "kubernetes.namespace_name",
        "rolling_time": 10,
        "timestamp_field": "@timestamp"
    }
}



