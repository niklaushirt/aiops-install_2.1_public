
## Indices

```bash

export appgroupid=3mavyiwf
export appid=gltjtbrk


curl -u $ES_USERNAME:$ES_PASSWORD -XGET https://$ES_ENDPOINT/_cat/indices  --insecure 


curl -u $ES_USERNAME:$ES_PASSWORD -XGET https://$ES_ENDPOINT/_cat/indices  --insecure | grep $appgroupid-$appid | awk '{print $3;}'


curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/$appgroupid-$appid-1-embedding_pca_model
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/$appgroupid-$appid-1-anomaly_group_id
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/$appgroupid-$appid-1-training_count_vectors
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/$appgroupid-$appid-1-pca_fe
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/$appgroupid-$appid-event_models_latest
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/$appgroupid-$appid-1-pca_model
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/$appgroupid-$appid-pagerduty_mapping_models_latest
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/$appgroupid-$appid-20210212-logtrain
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/$appgroupid-$appid-incident_models_latest
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/$appgroupid-$appid-1-applications
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/$appgroupid-$appid-1-embedding_pca_fe
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/$appgroupid-$appid-1-templates
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/normalized-incidents-$appgroupid-$appid



curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XGET https://$ES_ENDPOINT/$appgroupid-$appid-1-embedding_pca_model

```


oc get pods -n zeno | grep "Terminating" | awk '{print $1}' | xargs oc delete pod -n zeno  --force --grace-period=0

oc get pods -n noioper | grep "Terminating" | awk '{print $1}' | xargs oc delete pod -n noioper --force --grace-period=0





curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/3mavyiwf-gltjtbrk-1-training_count_vectors
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/3mavyiwf-gltjtbrk-1-pca_model
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/3mavyiwf-gltjtbrk-2-applications
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/3mavyiwf-gltjtbrk-2-embedding_pca_fe
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/3mavyiwf-gltjtbrk-2-training_count_vectors
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/3mavyiwf-gltjtbrk-1-embedding_pca_fe
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/3mavyiwf-gltjtbrk-2-pca_model
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/3mavyiwf-gltjtbrk-20210215-logtrain
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/3mavyiwf-gltjtbrk-1-templates
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/3mavyiwf-gltjtbrk-pagerduty_mapping_models_latest
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/3mavyiwf-gltjtbrk-1-pca_fe
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/3mavyiwf-gltjtbrk-2-pca_fe
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/3mavyiwf-gltjtbrk-1-applications
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/3mavyiwf-gltjtbrk-2-templates
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/3mavyiwf-gltjtbrk-1-embedding_pca_model
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/3mavyiwf-gltjtbrk-incident_models_latest
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/3mavyiwf-gltjtbrk-event_models_latest
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/3mavyiwf-gltjtbrk-2-embedding_pca_model
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/normalized-incidents-3mavyiwf-gltjtbrk
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/3mavyiwf-gltjtbrk-1-anomaly_group_id

curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/3mavyiwf-gltjtbrk-20210215-logtrain



curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/3mavyiwf-gltjtbrk-1-anomaly_group_id