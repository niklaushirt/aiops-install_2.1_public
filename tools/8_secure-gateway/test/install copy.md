
oc project default
oc delete secret -n default ibm-secure-gateway
oc create secret -n default generic ibm-secure-gateway --from-literal='GATEWAY_TOKEN=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJjb25maWd1cmF0aW9uX2lkIjoiUWNqV1p2MUo5dklfcHJvZF9uZyIsInJlZ2lvbiI6InVzLXNvdXRoIiwiaWF0IjoxNjEyMjU2ODk2LCJleHAiOjE2MjAwMzI4OTZ9.cYm-YPcPNQifaCyuUQ4dMs8sKQEWTd0EOTa3pATF54w' --from-literal='GATEWAY_ID=QcjWZv1J9vI_prod_ng'









curl -k -H "Authorization: Bearer c2010093f7c3c63a2ed445529118be517925ebc39cd255e36d2f89e1a0783fac9a9f111ddd750885b338149b1db10e96a9b377c5b8eb5b2d0808edc9e9a51f444b9adc73acc4548c682262a55bb05c8cd58a0e1e0d1696e8c4aef4f4b3bcefa9fb27995234d869fb7166cd2643a1f626c798da071bc0819eb4e5b02106b8a0f4f062b7262550fc895f1bd6964e4563adc01fb6a2412ac118ca8ce53bc01828ca74b0401960e42394adb218ab7df757f88e3c4b6efa4c3abacc9cfd8228c957b79f343edbda34c9ab4e1589af14c04b0df1ac85fab81645d021de5f99a9fad6d6bd4cb59f08b91cc5f59f1f9ed739daacd06d14d115e59ac8a345d8ec3f9d16bca4c32de8c71f8f87865eb2f9513998552c3f61c927077d151e9e6ba2995119d02eb31b707f216803e6ee88da27c922112aa3294b59d9d7d76839c3cc66e9aa89daf439049ad5026e9f6c6e8190ec037012a42db9ac4b36030f4e1f00a63adffe6d76dfb9050e584e7e480e94b9d82ac0ab43178597833cbc95ca8e5c8594c55ea479cf6c5ba6843b3d9f13e4c3dca306c5edb31646985d97a614a43574401c9db99f6f73f3a9ac98c34d74533ad37cbdbf6d07b18e998ffc78dc6366a7cb33a74c77e9049e6ad9477deb211ced127da3ac00d316e5fbbcd6fed1fb3d96d63a309072f881bc92f96a006a4ae3495306f83070442100ba4bbfa5fba41290d84320" https://caplonsgprd-4.securegateway.appdomain.cloud:16061:443/rcm/v1/clusters/sg/sg/import.yaml | kubectl apply -f -


## Create Gateway
## Create Destination

icp-management-ingress.ibm-common-services.svc.cluster.local
443
HTTPS:SERVER
TLS
Reject FALSE

## Token

https://cap-eu-de-prd-sg-bm-05.securegateway.appdomain.cloud:15203/

wcaiRntkfYZ_prod_eu-de

eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJjb25maWd1cmF0aW9uX2lkIjoid2NhaVJudGtmWVpfcHJvZF9ldS1kZSIsInJlZ2lvbiI6ImV1LWRlIiwiaWF0IjoxNjA1ODYzMTY1LCJleHAiOjE2MzczOTkxNjV9.ygk6eV90wyes89NhURye_Rds_i3-ZRJrUXnhd9L7aF8


# Install in Cluster


export GATEWAY_KEY=wcaiRntkfYZ_prod_eu-de

export GATEWAY_TOKEN=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJjb25maWd1cmF0aW9uX2lkIjoid2NhaVJudGtmWVpfcHJvZF9ldS1kZSIsInJlZ2lvbiI6ImV1LWRlIiwiaWF0IjoxNjA1ODYzMTY1LCJleHAiOjE2MzczOTkxNjV9.ygk6eV90wyes89NhURye_Rds_i3-ZRJrUXnhd9L7aF8


oc create secret generic ibm-secure-gateway --from-literal='GATEWAY_TOKEN=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJjb25maWd1cmF0aW9uX2lkIjoiZWo2cnJjbVlvcUJfcHJvZF9ldS1nYiIsInJlZ2lvbiI6ImV1LWdiIiwiaWF0IjoxNjA3MDA2MjcxfQ.MfO2nCiqPg6hmzKTcmprjKhjSdV38KkYwhoFVMcgjDs' --from-literal='GATEWAY_ID=ej6rrcmYoqB_prod_eu-gb' -n default



---
# Source: ibm-watson-aiops-dev-install/templates/00-secure-gateway-acl-configmap.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: aiops-aiopsdev-secure-gateway
  namespace: default
  labels:
    app.kubernetes.io/component: "secure-gateway"
data:
  gateway_acl.list: "acl allow :"
---
# Source: ibm-watson-aiops-dev-install/templates/70-secure-gateway-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: aiops-aiopsdev-secure-gateway
  namespace: default
  labels:
    app.kubernetes.io/component: "secure-gateway"
spec:
  replicas: 1
  revisionHistoryLimit: 25
  selector:
    matchLabels:
      app.kubernetes.io/component: "secure-gateway"
  template:
    metadata:
      labels:
        app.kubernetes.io/component: "secure-gateway"
    spec:
      hostIPC: false
      hostNetwork: false
      hostPID: false
      affinity:
        nodeAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
            nodeSelectorTerms:
            - matchExpressions:
              - key: beta.kubernetes.io/arch
                operator: In
                values:
                - amd64
      
      containers:
      - name: "secure-gateway"
        image: ibmcom/secure-gateway-client:latest
        securityContext:
          allowPrivilegeEscalation: false
          capabilities:
            drop:
            - ALL
          privileged: false
          readOnlyRootFilesystem: false
        envFrom:
        - secretRef:
            name: ibm-secure-gateway
        command:
        - node
        - lib/secgwclient.js
        args:
        - wcaiRntkfYZ_prod_eu-de
        - --gateway=https://sgmanager.us-south.securegateway.cloud.ibm.com
        - --sectoken=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJjb25maWd1cmF0aW9uX2lkIjoid2NhaVJudGtmWVpfcHJvZF9ldS1kZSIsInJlZ2lvbiI6ImV1LWRlIiwiaWF0IjoxNjA1ODYzMTY1LCJleHAiOjE2MzczOTkxNjV9.ygk6eV90wyes89NhURye_Rds_i3-ZRJrUXnhd9L7aF8
        - --aclfile=/acl/gateway_acl.list
        - --loglevel=DEBUG
        - --noUI
        volumeMounts:
        - mountPath: /acl
          name: acl
      volumes:
      - name: acl
        configMap:
          name: aiops-aiopsdev-secure-gateway



--------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------

export GATEWAY_KEY=wcaiRntkfYZ_prod_eu-de

export GATEWAY_TOKEN=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJjb25maWd1cmF0aW9uX2lkIjoid2NhaVJudGtmWVpfcHJvZF9ldS1kZSIsInJlZ2lvbiI6ImV1LWRlIiwiaWF0IjoxNjA1ODYzMTY1LCJleHAiOjE2MzczOTkxNjV9.ygk6eV90wyes89NhURye_Rds_i3-ZRJrUXnhd9L7aF8


oc create secret generic ibm-secure-gateway --from-literal='GATEWAY_TOKEN=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJjb25maWd1cmF0aW9uX2lkIjoid2NhaVJudGtmWVpfcHJvZF9ldS1kZSIsInJlZ2lvbiI6ImV1LWRlIiwiaWF0IjoxNjA1ODYzMTY1LCJleHAiOjE2MzczOTkxNjV9.ygk6eV90wyes89NhURye_Rds_i3-ZRJrUXnhd9L7aF8' --from-literal='GATEWAY_ID=wcaiRntkfYZ_prod_eu-de' -n default


















          export DESTINATION=$(curl -X POST \
            -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJjb25maWd1cmF0aW9uX2lkIjoid2NhaVJudGtmWVpfcHJvZF9ldS1kZSIsInJlZ2lvbiI6ImV1LWRlIiwiaWF0IjoxNjA1ODYzMTY1LCJleHAiOjE2MzczOTkxNjV9.ygk6eV90wyes89NhURye_Rds_i3-ZRJrUXnhd9L7aF8" \
            -H 'Content-Type: application/json' \
            -d '{ "desc": "Helm: aiops", "ip": "ibm-nginx-svc.default.svc.cluster.local", "port": "443", "protocol": "HTTPS", "enable_client_tls": true, "client_tls": "none", "tls": "serverside", "rejectUnauth": false }' \
            "https://sgmanager.eu-de.securegateway.cloud.ibm.com/v1/sgconfig/wcaiRntkfYZ_prod_eu-de/destinations")

          export DESTINATION_ID=$(echo $DESTINATION | jq ._id)

          kubectl delete -n default --ignore-not-found=true configmap aiops-securegateway-destination
          cat <<EOF | kubectl create -n default -f -
          apiVersion: v1
          kind: ConfigMap
          metadata:
            name: "aiops-securegateway-destination"
            labels:
              waiopsSecureGatewayDestination: "true"
              app.kubernetes.io/name: "aiopsDev"
              helm.sh/chart: "ibm-watson-aiops-dev-install"
              app.kubernetes.io/managed-by: "Helm"
              app.kubernetes.io/instance: "aiops"
              release: "aiops"
              app.kubernetes.io/component: "aiops-securegateway-destination"
          data:
            DESTINATION_ID: '$(echo -n $DESTINATION_ID)'
            DESTINATION_CONFIG: '$(echo -n $DESTINATION)'
          EOF









  - "/bin/bash"
        - -c
        - |
          set -e
          DESTINATION=$(curl -X POST \
            -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJjb25maWd1cmF0aW9uX2lkIjoid2NhaVJudGtmWVpfcHJvZF9ldS1kZSIsInJlZ2lvbiI6ImV1LWRlIiwiaWF0IjoxNjA1ODYzMTY1LCJleHAiOjE2MzczOTkxNjV9.ygk6eV90wyes89NhURye_Rds_i3-ZRJrUXnhd9L7aF8" \
            -H 'Content-Type: application/json' \
            -d '{ "desc": "Helm: aiops", "ip": "ibm-nginx-svc.default.svc.cluster.local", "port": "443", "protocol": "HTTPS", "enable_client_tls": true, "client_tls": "none", "tls": "serverside", "rejectUnauth": false }' \
            "https://sgmanager.eu-de.securegateway.cloud.ibm.com/v1/sgconfig/wcaiRntkfYZ_prod_eu-de/destinations")

          DESTINATION_ID=$(echo $DESTINATION | jq ._id)

          kubectl delete -n default --ignore-not-found=true configmap aiops-securegateway-destination
          cat <<EOF | kubectl create -n default -f -
          apiVersion: v1
          kind: ConfigMap
          metadata:
            name: "aiops-securegateway-destination"
            labels:
              waiopsSecureGatewayDestination: "true"
              app.kubernetes.io/name: "aiopsDev"
              helm.sh/chart: "ibm-watson-aiops-dev-install"
              app.kubernetes.io/managed-by: "Helm"
              app.kubernetes.io/instance: "aiops"
              release: "aiops"
              app.kubernetes.io/component: "aiops-securegateway-destination"
          data:
            DESTINATION_ID: '$(echo -n $DESTINATION_ID)'
            DESTINATION_CONFIG: '$(echo -n $DESTINATION)'
          EOF
