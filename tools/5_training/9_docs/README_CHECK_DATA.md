# ----------------------------------------------------------------------------------------------------------------------------------------------------------
## Data Check
# ----------------------------------------------------------------------------------------------------------------------------------------------------------



## Check Number of log lines per container

```bash
cat ./tools/5_training/2_logs/trainingdata/raw/log-bookinfo.json|jq '.["kubernetes.container_name"]' | sort | uniq -c
```

## Delete istio-proxy entries

```bash
grep -v 'kubernetes.container_name":"details' ./tools/5_training/2_logs/trainingdata/raw/log-bookinfo.json > final.json
```




cat log-robotshop.json|jq '.["kubernetes.container_name"]' | sort | uniq -c
grep -v 'kubernetes.container_name":"cart' log-robotshop.json > nocart.json
grep -v 'kubernetes.container_name":"payment' nocart.json > nopay.json
grep -v 'kubernetes.container_name":"ratings' nopay.json > norat.json
grep -v 'kubernetes.container_name":"redis' norat.json > nored.json
grep -v 'kubernetes.container_name":"shipping' nored.json > nosip.json
grep -v 'kubernetes.container_name":"web' nosip.json > noweb.json
cat noweb.json|jq '.["kubernetes.container_name"]' | sort | uniq -c\n
mv noweb.json log-robotshop.json
rm log-robotshop.json.gz
gzip log-robotshop.json
rm nocart.json
rm nopay.json
rm norat.json
rm nored.json
rm nosip.json
rm noweb.json
ls