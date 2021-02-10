

http://172.21.85.234:8080/api/v1/repositories/aiops/query

c7KU1nD5b7L48GX6dcja0lmNUrATqSJKmKq3RVKChDk3

kubernetes.namespace_name="kubetoy"


{
    "codec": "humio",
    "message_field": "@rawstring",
    "log_entity_types": "kubernetes.namespace_name,kubernetes.container_hash,kubernetes.host,kubernetes.container_name,kubernetes.pod_name",
    "instance_id_field": "kubernetes.container_name",
    "rolling_time": 10,
    "timestamp_field": "@timestamp"
}




