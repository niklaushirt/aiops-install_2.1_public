# Watson AIOps Demo Environment Installation 


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
## AI and Event Manager Base Install
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

### Adapt 01_config-modules.sh

**Select Storage Class**

Make sure it's the default class

### 

```bash
./10_install_aiops.sh -t <PULL_SECRET_TOKEN>
```




# Post Install



------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
## Istio 
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

```bash
oc create ns istio-system
```

Install:

- Elasticsearch Operator
- RedHat Jaeger Operator
- Kiali Operator
- Service Mesh Operator

- Create CR Service Mesh in istio-system (!)
- Create CR ServiceMeshMemberRoll in istio-system for bookinfo (!)


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
## Demo Apps
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

### Install Bookinfo

```bash
oc create ns bookinfo

oc apply -n bookinfo -f ./demo_install/bookinfo/bookinfo.yaml
oc apply -n bookinfo -f ./demo_install/bookinfo/bookinfo-gateway.yaml
oc apply -n bookinfo -f ./demo_install/bookinfo/destination-rule-all.yaml
oc apply -n bookinfo -f ./demo_install/bookinfo/virtual-service-reviews-100-v2.yaml

```



#### Install Bookinfo genereate load

```bash
oc apply -n default -f ./demo_install/bookinfo/bookinfo-create-load.yaml
```

#### Create Log Inject for Demo

In AI Manager on the App:
Create Ops Integration --> Apache Kafka --> Next --> Logs / Humio and use the mapping:

```yaml
{
    "rolling_time": 10,
    "instance_id_field": "kubernetes.container_name",
    "log_entity_types": "kubernetes.namespace_name,kubernetes.container_hash,kubernetes.host,kubernetes.container_name,kubernetes.pod_name",
    "message_field": "@rawstring",
    "timestamp_field": "@timestamp"
}
```
Adapt the file ./demo/bookinfo/demo.sh with the given Topic

### Install Kubetoy

```bash
kubectl create ns kubetoy
kubectl apply -n kubetoy -f ./demo_install/kubetoy/kubetoy_all_in_one.yaml

```



### Install SockShop 

```bash
kubectl create ns sock-shop

oc adm policy add-scc-to-user privileged -n sock-shop -z default
oc create clusterrolebinding default-sock-shop-admin --clusterrole=cluster-admin --serviceaccount=sock-shop:default

kubectl apply -n sock-shop -f ./demo_install/sockshop/sockshop-complete.yaml

kubectl apply -n default -f ./demo_install/sockshop/sockshop-create-load.yaml

```


### Install RoboShop (not yet working)

```bash
kubectl create ns robot-shop
helm install robot-shop --namespace robot-shop ./demo_install/robot-shop/helm

kubectl apply -n robot-shop -f ./demo_install/robot-shop/istio/gateway.yaml

oc create clusterrolebinding robot-admin --clusterrole=cluster-admin --serviceaccount=robot-shop:default
```



------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
## HUMIO
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

### Install HUMIO

```bash
helm repo add humio https://humio.github.io/humio-helm-charts
helm repo update

oc create ns humio-logging

helm install humio-instance humio/humio-helm-charts \
  --namespace humio-logging \
  --values ./tools/4_integrations/humio/humio-install.yaml


oc adm policy add-scc-to-user privileged -n humio-logging -z humio-instance
oc adm policy add-scc-to-user privileged -n humio-logging -z default



kubectl apply -n humio-logging -f ./tools/4_integrations/humio/humio-route.yaml

# username: "developer"

# password
kubectl get secret developer-user-password -n humio-logging -o=template --template={{.data.password}} | base64 -D
kubectl get service humio-instance-humio--core-http -n humio-logging -o go-template --template='http://{{(index .status.loadBalancer.ingress 0 ).ip}}:8080'
kubectl get service humio-instance-humio-core-es -n humio-logging -o go-template --template='{{(index .status.loadBalancer.ingress 0 ).ip}}'

kubectl get service humio-instance-humio-core-es -n humio-logging
```
#### Change developer password

Modify Secret developer-user-password

```yaml
kind: Secret
apiVersion: v1
metadata:
  name: developer-user-password
  namespace: humio-logging
data:
  password: UDRzc3cwcmQh
type: Opaque
```


### Configure Humio

* Create Repository `aiops`
* Get Ingest token



### Humio Fluentbit

```bash
export INGEST_TOKEN=ZsXyuLJrdKnZFqtLaTldvqsNhRYCmhFikLLQ9mBM1tDQ (put your token)

```

#### Install DaemonSet

```bash
oc adm policy add-scc-to-user privileged -n humio-logging -z humio-fluentbit-fluentbit-read


helm install humio-fluentbit humio/humio-helm-charts \
  --namespace humio-logging \
  --set humio-fluentbit.token=$INGEST_TOKEN \
  --values ./tools/4_integrations/humio/humio-agent.yaml
```


#### Modify DaemonSet

In the container part (same level as name)

```yaml
        securityContext:
          privileged: true
```

You can do this by executing:
```bash
kubectl patch DaemonSet humio-fluentbit-fluentbit -n humio-logging -p '{"spec": {"template": {"spec": {"containers": [{"name": "humio-fluentbit","image": "fluent/fluent-bit:1.4.2","securityContext": {"privileged": true}}]}}}}' --type=merge
```


### Configure Humio Alerts


#### Create Notifier 

**In Event Manager (NOI):**

* Administration --> Integration with other Systems
* Incoming --> New Integration
* Humio
* Get Webhook URL

**In Humio:**

* Alerts --> Notifiers 
* New Notifier with URL and Skip Cert Validation


#### BookinfoProblem

```yaml
"kubernetes.namespace_name" = bookinfo
| @rawstring = /unable to contact http:\/\/ratings:9080\/ratings got status of 503/i

Last 5s

resource.name=\"ratings\" severity=Major resource.hostname=ratings type.eventType=\"bookinfo\"
```

#### BookinfoRatingsDown

```yaml
"kubernetes.namespace_name" = bookinfo
| @rawstring = /unable to contact http:\/\/ratings:9080\/ratings got status of 503/i

Last 5s

resource.name=\"ratings\" severity=Critical resource.hostname=ratings-v1 type.eventType=\"bookinfo\"
```


#### BookinfoReviewsProblem

```yaml
"kubernetes.namespace_name" = bookinfo
| @rawstring = /unable to contact http:\/\/ratings:9080\/ratings got status of 503/i

Last 5s

resource.name=\"reviews\" severity=Major resource.hostname=reviews-v2 type.eventType=\"bookinfo\"
```

#### KubetoyLivenessProbe

```yaml
"kubernetes.namespace_name" = kubetoy | @rawstring = /I'm not feeling all that well./i


Last 20s

resource.name=\"kubetoy-deployment\" severity=Critical resource.hostname=kubetoy-deployment type.eventType=\"kubetoy\"
```

#### KubetoyAvailabilityProblem

```yaml
"kubernetes.namespace_name" = kubetoy | @rawstring = /I'm not feeling all that well./i

Last 20s

resource.name=\"kubetoy-deployment\" severity=Major resource.hostname=kubetoy-service type.eventType=\"kubetoy\"
```



#### KubetoyCrash

```yaml
"kubernetes.namespace_name" = kubetoy | @rawstring = /app.js:187/i

Last 5 min

resource.name=\"kubetoy-deployment\" severity=Critical resource.hostname=kubetoy-service type.eventType=\"kubetoy\"
```



#### KubetoyGeneralError

```yaml
"kubernetes.namespace_name" = kubetoy | @rawstring = /error/i


Last 2s

resource.name=\"kubetoy-deployment\" severity=Critical resource.hostname=kubetoy-deployment type.eventType=\"kubetoy\"
```




#### SockShopAvailability

```yaml
"kubernetes.namespace_name" = sockshop | @rawstring = /app.js:187/i

Last 5 min

resource.name=\"sockshop\" severity=Critical resource.hostname=sockshop type.eventType=\"sockshop\"
```



#### SockShopCatalogError

```yaml
"kubernetes.namespace_name" = sockshop | @rawstring = /error/i


Last 2s

resource.name=\"sockshop\" severity=Critical resource.hostname=sockshop type.eventType=\"sockshop\"
```

> You can test by creating a Notifier with https://webhook.site/





------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
## Configure Event Manager / ASM Topology
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

### Create User that can see Topology

* Log-in to Noi --> Netcool WebGUI --> Top Right click on cog --> WebSphere Administrative Console
* Users and Groups
* Manage Groups --> Create Group "admin" 
* Manage Users  --> Create User "demo" --> add to group admin
* In Netcool WebGUI --> Top Right click on cog --> Group Roles --> Give all rights

### Create K8s Observers

For each DemoApp (bookinfo, kubetoy, sock-shop) create observer:

* Administration --> Topology Management --> ObserverJobs Configure --> Add new Job / Kubernetes"
* Terminated Pods: true
* Correlate: true
* Namespace: <The one for the app>
* Time interval: Once

### Create Match Tokens Rules

```bash
export TOPO_PWD=<from ./80_get_logins.sh>

curl -X "POST" "https://demo-noi-topology.noi.apps.ocp45.tec.uk.ibm.com/1.0/merge/rules" \
     -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' \
     -H 'Content-Type: application/json; charset=utf-8' \
     -H 'Cookie: 4537c95a03ec20cc9f6b6f42e89f1813=c0be3a94130da5df0c9ac3301f4cc803; 3a1a35fb207ba3c538d4e2b63ac68863=de912e600edcedf26b7b3ce9b7e71f40; 4bbb996250454381873de3d013af38e1=532530c6bdd7ac721f8684a66eff61b6' \
     -u 'demo-noi-topology-noi-user:$TOPO_PWD' \
     --insecure \
     -d $'{
  "tokens": [
    "name"
  ],
  "entityTypes": [
    "deployment",
    "service"
  ],
  "providers": [
    "*"
  ],
  "observers": [
    "*"
  ],
  "ruleType": "matchTokensRule",
  "name": "kubetoy-match-name",
  "ruleStatus": "enabled"
}'
```

### Create grouping Policy

* NetCool Web Gui --> Insights --> Scope Based Grouping
* Create Policy
* On `Alert Group`




### Create Bastion Server
kubectl apply -n default -f ./tools/6_bastion/create-bastion.yaml

Adapt SSL Certificate in Bastion Host Deployment. Get it from Administration --> Integration with other Systems --> Automation Type --> Script

### Create Automation

Automation -->Runbooks --> Automations --> New Automation

Bookinfo

```bash
oc login --token=$token --server=$ocp_url
kubectl scale deployment --replicas=1 -n bookinfo ratings-v1
```

Sockshop

```bash
oc login --token=$token --server=$ocp_url
oc scale --replicas=1  deployment catalogue -n sock-shop
```

Use these default values

```yaml
target: bastion-host-service.default.svc
user:   root
$token	 : Token from your login (ACCESS_DETAILS_XXX.md)	
$ocp_url : URL from your login (ACCESS_DETAILS_XXX.md, something like https://c102-e.eu-de.containers.cloud.ibm.com:32236)		
```


### Create Runbooks

**Kubetoy Liveness Probe**

-------
Check if the Pod is still running
kubectl get pods -n NAMESPACE PODNAME 
If the return value is empty proceed with the next steps.

-------
Get the name of the Pod
kubectl get pods -n NAMESPACE | grep <your-pod-name>

-------
Check the logs
kubectl logs -n NAMESPACE kubetoy-deployment-<your-pod-id>

-------
Restart the pod if needed
kubectl delete pod -n NAMESPACE <your-pod-id>



**Bookinfo Reviews-Ratings**

Automated

**Sockshop Catalogue**

Automated




-------
### Add Runbook Triggers

Create new trigger for

* Kubetoy
* Bookinfo
* Sockshop

based on Alert Group



### Modify Look

#### Resource types

**deploy**:

```bash
Border Color Function: return '#ebb134';

Background Color Function: return '#e3eeff';
```

**pod**

```bash
Background Color Function: return '#e3eeff';
```

**service**

```bash
Background Color Function: return '#e3eeff';
```

#### Relationship types

**exposes**

```bash
Line Color Function: return '#80eb34';
Line Width Function: return '1.5px';
```

**managers**

```bash
Line Color Function: return '#ebb134';
Line Width Function: return '1.5px';
```



------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
## Install Event Manager Gateway
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

### Create Strimzi route

Add Listener to Strimzi Operator CR in Namespace zen: Modify CR

```yaml
    listeners:
      external:
        type: route
```

You can do this with this command:

```bash
kubectl patch Kafka strimzi-cluster -n zen -p '{"spec": {"kafka": {"listeners": {"external": {"type": "route"}}}}}' --type=merge
```




### Copy secret strimzi-cluster-cluster-ca-cert

Copy secret strimzi-cluster-cluster-ca-cert - from  zen to noi

```bash
kubectl get secret strimzi-cluster-cluster-ca-cert -n zen -oyaml
```



### Get info

```bash
oc get secret token -n zen --template={{.data.password}} | base64 --decode

oc get routes -n zen strimzi-cluster-kafka-bootstrap -o=jsonpath='{.status.ingress[0].host}{"\n"}'

oc get kafkatopic -n zen | grep windows
```

### Modify Template 

```bash
cp ./tools/3_integrationgateway/nikh-bookinfo-demo-noi-aimgr-gateway-config-template.yaml ./tools/3_integrationgateway/nikh-bookinfo-demo-noi-aimgr-gateway-config-template_XXXX.yaml
cp ./tools/3_integrationgateway/nikh-kubetoy-demo-noi-aimgr-gateway-config-template.yaml ./tools/3_integrationgateway/nikh-kubetoy-demo-noi-aimgr-gateway-config-template_XXXX.yaml
cp ./tools/3_integrationgateway/nikh-sockshop-demo-noi-aimgr-gateway-config-template.yaml ./tools/3_integrationgateway/nikh-sockshop-demo-noi-aimgr-gateway-config-template_XXXX.yaml

```

Replace TODO tags starting line 325



### Apply Manifest

```bash
kubectl apply -n noi -f ./tools/3_integrationgateway/nikh-bookinfo-demo-noi-aimgr-gateway-config-template_XXXX.yaml
kubectl apply -n noi -f ./tools/3_integrationgateway/nikh-bookinfo-demo-noi-aimgr-gateway.yaml

kubectl apply -n noi -f ./tools/3_integrationgateway/nikh-kubetoy-demo-noi-aimgr-gateway-config-template_XXXX.yaml
kubectl apply -n noi -f ./tools/3_integrationgateway/nikh-kubetoy-demo-noi-aimgr-gateway.yaml

kubectl apply -n noi -f ./tools/3_integrationgateway/nikh-sockshop-demo-noi-aimgr-gateway-config-template_XXXX.yaml
kubectl apply -n noi -f ./tools/3_integrationgateway/nikh-sockshop-demo-noi-aimgr-gateway.yaml

```





------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
## Create ASM Integration
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------






### Create the Operations integration for the AppGroup.


#### Get certificate

Get the certificate:

```bash
oc get secret demo-noi-topology-topology-cert -n noi -o yaml | grep tls.crt | awk '{print $2}' | base64 -d
```

#### Input values

* Get Username from `./80_get__logins.sh`  (Usually something like demo-noi-topology-topology)
* Get Password from `./80_get_logins.sh`>

* Topology URL : https://demo-noi-topology-topology.noi.svc:8080
* Layout URL : https://demo-noi-topology-layout.noi.svc:7084
* Merge Service URL : https://demo-noi-topology-merge.noi.svc:7082
* Search URL : https://demo-noi-topology-search.noi.svc:7080
* UI URL : https://netcool.demo-noi.apps.ocp45.tec.uk.ibm.com. (adapt this to your NOI URL)
* UI API URL : https://demo-noi-topology-ui-api.noi.svc:3080



### Use external Route (ROKS)

If you want to use external route you have to create new routes with only one subdomain, as the certificates are not working if you don't change this.


#### Create Route

This is only needed if you don't use the internal Service routes
```bash
oc get route -n noi | grep topology-topology | awk '{print $2}'
```

Use the part after `demo-noi-topology.noi.` to adapt the `<CHANGE_URL>` tokens ./tools/4_integrations/ASM/routes.yaml


```bash
kubectl apply -n noi -f ./tools/4_integrations/ASM/routes.yaml
```

Then browse to the new asm-topology Route and add `/swagger`

to check if the Route is working.

#### Get certificate

From the Swagger URL above get the Certificate

Usually something like this:

```yaml
-----BEGIN CERTIFICATE-----
MIIF.....1vyTbt
-----END CERTIFICATE-----
-----BEGIN CERTIFICATE-----
MIIF.....Hwg==
-----END CERTIFICATE-----
-----BEGIN CERTIFICATE-----
MII.....eGCc=
-----END CERTIFICATE-----
```

**For ROKS** just put the URL from the new route and check "Use topology ..."


Get the certificate from secret demo-noi-topology-topology-cert

### Check ASM connection

```bash
oc exec $(oc get pod -n zen |grep topology | awk '{print $1}') -n zen bash -it

curl -X GET -k "https://localhost:8443/ready?send_additional_info=true" -H "accept: application/json"
```

Should respond with this:

```json
{"ready":"ok","asm_connections":{"initialized_from_remote":true,"default_connector":null,"connectors":{"ubtjc0h2":{"healthy":true,"last_response":{"topology_service":{"service":"IBM Topology","health":[{"responsetimeunit":"ms","serviceinput":"ping health node","serviceoutput":"node pinged ok","responsetime":3,"status":0}]},"search_service":{"service":"IBM Search Service","health":[{"responseTime":906210,"statusMessage":"Success","responseTimeUnit":"ms","status":0}]},"merge_service":{"service":"IBM Topology","health":[{"responsetimeunit":"ms","serviceinput":"ping health node","serviceoutput":"node pinged ok","responsetime":2,"status":0}]},"layout_service":{"service":"IBM Topology","health":[{"responsetimeunit":"ms","serviceinput":"ping health node","serviceoutput":"node pinged ok","responsetime":3,"status":0}]},"ui_api_service":{"service":"ASM UI API","status":"RUNNING"}}}}},"kafka_connection":"Consumer connected"}
```






------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
## Some Housekeeping
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

### Make Flink Console accessible

If not done in the script 

```bash
oc create route passthrough job-manager -n zen --service=demo-ai-manager-ibm-flink-job-manager --port=8000
```


### Refresh ingress certificates (otherwise Slack will not validate link)

```bash
oc get secrets -n openshift-ingress | grep tls | grep -v router-metrics-certs-default | awk '{print $1}' | xargs oc get secret -n openshift-ingress -o yaml > tmpcert.yaml
cat tmpcert.yaml | grep " tls.crt" | awk '{print $2}' |base64 -d > cert.crt
cat tmpcert.yaml | grep " tls.key" | awk '{print $2}' |base64 -d > cert.key
ibm_nginx_pod=$(oc get pods -l component=ibm-nginx -o jsonpath='{ .items[0].metadata.name }')
oc exec ${ibm_nginx_pod} -- mkdir -p "/user-home/_global_/customer-certs"
oc cp cert.crt ${ibm_nginx_pod}:/user-home/_global_/customer-certs/
oc cp cert.key ${ibm_nginx_pod}:/user-home/_global_/customer-certs/
for i in `oc get pods -l component=ibm-nginx -o jsonpath='{ .items[*].metadata.name }' `; do oc exec ${i} -- /scripts/reload.sh; done
rm tmpcert.yaml cert.crt cert.key
```


### Adapt ROKS S3 Training

```bash
oc project zen 
oc exec $(oc get pods -l app.kubernetes.io/component=model-train-console -o jsonpath='{ .items[*].metadata.name }') -- sed -i 's/type: mount_cos/type: s3_datastore/g' /home/zeno/train/manifests/s3fs-pvc/event_group.yaml
oc exec $(oc get pods -l app.kubernetes.io/component=model-train-console -o jsonpath='{ .items[*].metadata.name }') -- sed -i 's/type: mount_cos/type: s3_datastore/g' /home/zeno/train/manifests/s3fs-pvc/event_group_eval.yaml
oc exec $(oc get pods -l app.kubernetes.io/component=model-train-console -o jsonpath='{ .items[*].metadata.name }') -- sed -i 's/type: mount_cos/type: s3_datastore/g' /home/zeno/train/manifests/s3fs-pvc/event_ingest.yaml
oc exec $(oc get pods -l app.kubernetes.io/component=model-train-console -o jsonpath='{ .items[*].metadata.name }') -- sed -i 's/type: mount_cos/type: s3_datastore/g' /home/zeno/train/manifests/s3fs-pvc/log_anomaly.yaml
oc exec $(oc get pods -l app.kubernetes.io/component=model-train-console -o jsonpath='{ .items[*].metadata.name }') -- sed -i 's/type: mount_cos/type: s3_datastore/g' /home/zeno/train/manifests/s3fs-pvc/log_anomaly_eval.yaml
oc exec $(oc get pods -l app.kubernetes.io/component=model-train-console -o jsonpath='{ .items[*].metadata.name }') -- sed -i 's/type: mount_cos/type: s3_datastore/g' /home/zeno/train/manifests/s3fs-pvc/log_ingest.yaml
oc exec $(oc get pods -l app.kubernetes.io/component=model-train-console -o jsonpath='{ .items[*].metadata.name }') -- sed -i 's/type: mount_cos/type: s3_datastore/g' /home/zeno/train/manifests/s3fs-pvc/log_ingest_eval.yaml

```








------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
## Train the Models
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

1. Train Events --> ./tools/5_training/1_events/README_EVENT.md
1. Train Logs --> ./tools/5_training/2_logs/README_LOG.md
1. Train Events --> ./tools/5_training/3_incidents/README_EVENT.md

### Check if data is flowing

Get the kafkacat Certificate

```bash
mv ca.crt ca.crt.old
oc extract secret/strimzi-cluster-cluster-ca-cert -n zen --keys=ca.crt

oc get kafkatopic -n zen


export sasl_password=$(oc get secret token -n zen --template={{.data.password}} | base64 --decode)
export BROKER=$(oc get routes strimzi-cluster-kafka-bootstrap -n zen -o=jsonpath='{.status.ingress[0].host}{"\n"}'):443

kafkacat -v -X security.protocol=SSL -X ssl.ca.location=./ca.crt -X sasl.mechanisms=SCRAM-SHA-512 -X sasl.username=token -X sasl.password=$sasl_password -b $BROKER -o beginning -C -t derived-stories 
```



------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
## Humio Connection from AI Manager (Ops Integration)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

### Create Ops Integration on Bookinfo App

#### URL

Get the Humio URL

Add `/api/v1/repositories/aiops/query`



#### Accounts Token

Get it from Humio --> Owl in the top right corner --> Your Account --> API Token

#### Filter
kubernetes.namespace_name="bookinfo"

#### Mapping

```yaml
{
    "rolling_time": 10,
    "instance_id_field": "kubernetes.container_name",
    "log_entity_types": "kubernetes.namespace_name,kubernetes.container_hash,kubernetes.host,kubernetes.container_name,kubernetes.pod_name",
    "message_field": "@rawstring",
    "timestamp_field": "@timestamp"
}
```

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
## NOI Connection from AI Manager (Ops Integration)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Create integration
Kafka
Noi





------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
## Slack integration
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

More details are here https://pages.github.ibm.com/garage-tsa/AIOps-Up-And-Running/End_to_End_Demo_2.0/slack/slack_integration/

A copy of those instructions are here: ./4_integrations/slack


### Change the Slash Welcome Message

```bash
oc set env deployment/$(oc get deploy -l app.kubernetes.io/component=chatops-slack-integrator -o jsonpath='{.items[*].metadata.name }') SLACK_WELCOME_COMMAND_NAME=/aiops-help
```





------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
## Some Polishing
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

### Create USER

```bash
kubectl create serviceaccount -n zen demo-admin

oc create clusterrolebinding test-admin --clusterrole=cluster-admin --serviceaccount=zen:demo-admin
```

Get the login Token from secret demo-admin-token-xyz in Namespace zen

You can then login with:

```bash
oc login --server=https://<REPLACE>.containers.cloud.ibm.com:<REPLACE> --token=<TOKEN> 

```


### Change admin password AI Manager

Modify the `admin-user-details`secret in zen

Replace 

initial_admin_password: cGFzc3dvcmQ=

with 

initial_admin_password: UDRzc3cwcmQh

Restart Pod: 


# Demo Assets

Make sure you have updated the config file ./demo/01_config.sh







------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
## Install Secure Gateway (not on ROKS)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

### Create the secure gateway in cloud.ibm.com



### Get info

Get the Gateway Token
Get the Gateway ID



### Install in Cluster

```bash
oc create secret generic ibm-secure-gateway --from-literal='GATEWAY_TOKEN=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJjb25maWd1cmF0aW9uX2lkIjoiZWo2cnJjbVlvcUJfcHJvZF9ldS1nYiIsInJlZ2lvbiI6ImV1LWdiIiwiaWF0IjoxNjA3MDA2MjcxfQ.MfO2nCiqPg6hmzKTcmprjKhjSdV38KkYwhoFVMcgjDs' --from-literal='GATEWAY_ID=ej6rrcmYoqB_prod_eu-gb' -n default


kubectl apply -n default -f ./tools/8_secure-gateway/secure-gateway.yaml
```



### Create the URL


Get the Slack callback URL from AI Manager.
Should look something like this:
https://zen-cpd-zen.apps.ocp45.tec.uk.ibm.com/aiops/demo-aimanager/instances/1612252227557038/api/slack/events


Get the Destination URL (Cloud Host : Port)
Should look something like this:
cap-sg-prd-3.securegateway.appdomain.cloud:20151


Consruct the final URL
https://cap-sg-prd-3.securegateway.appdomain.cloud:20151/aiops/demo-aimanager/instances/1612252227557038/api/slack/events

Use this in the Slack App:
- Event Subscription
- Slash Commands
- Interactivity & Shortcuts

