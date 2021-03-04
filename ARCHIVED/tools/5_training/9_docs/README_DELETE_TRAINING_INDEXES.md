# Delete Trained Log Model


## Delete Indices

```bash
oc project zen
oc exec -it $(oc get po |grep model-train-console|awk '{print$1}') bash
```

```bash
export application_name=bookinfo
export appgroupid=zjecaqq2
export appid=nir5ix68
export version=1


# DELETE LOG MODEL INDICES
curl -u $ES_USERNAME:$ES_PASSWORD -XGET https://$ES_ENDPOINT/_cat/indices  --insecure | grep $appgroupid-$appid-$version
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/$appgroupid-$appid-$version-embedding_pca_fe         
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/$appgroupid-$appid-$version-anomaly_group_id         
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/$appgroupid-$appid-$version-templates                
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/$appgroupid-$appid-$version-applications             
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/$appgroupid-$appid-$version-pca_fe                   
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/$appgroupid-$appid-$version-training_count_vectors   
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/$appgroupid-$appid-$version-pca_model                
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/$appgroupid-$appid-$version-embedding_pca_model      
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/$appgroupid-$appid-log_models_latest

```



## Get all indices

```bash
curl -u $ES_USERNAME:$ES_PASSWORD -XGET https://$ES_ENDPOINT/_cat/indices  --insecure  | awk '{print $3;}'
```









