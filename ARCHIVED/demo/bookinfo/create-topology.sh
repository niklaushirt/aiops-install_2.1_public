#export CLUSTER_NAME=tec-cp4aiops-3c14aa1ff2da1901bfc7ad8b495c85d9-0000.eu-de.containers.appdomain.cloud

echo "export CLUSTER_NAME="$CLUSTER_NAME
echo "export NOI_REST_USR="$NOI_REST_USR
echo "export NOI_REST_PWD="$NOI_REST_PWD



# Deployments
curl -X "POST" "https://demo-noi-topology.noi.$CLUSTER_NAME/1.0/rest-observer/rest/resources" --insecure -H 'Content-Type: application/json' -u $NOI_REST_USR':'$NOI_REST_PWD -H 'JobId: listenJob' -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' -d $'{"app": "bookinfo","availableReplicas": 1,"createdReplicas": 1,"dataCenter": "demo","desiredReplicas": 1,"entityTypes": ["deployment"],"matchTokens": ["productpage-v1"],"name": "productpage-v1","namespace": "bookinfo","readyReplicas": 1,"tags": ["app:productpage","namespace:bookinfo"],"vertexType": "resource","uniqueId": "productpage-v1-id"}'
curl -X "POST" "https://demo-noi-topology.noi.$CLUSTER_NAME/1.0/rest-observer/rest/resources" --insecure -H 'Content-Type: application/json' -u $NOI_REST_USR':'$NOI_REST_PWD -H 'JobId: listenJob' -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' -d $'{"app": "bookinfo","availableReplicas": 1,"createdReplicas": 1,"dataCenter": "demo","desiredReplicas": 1,"entityTypes": ["deployment"],"matchTokens": ["reviews-v2"],"name": "reviews-v2","namespace": "bookinfo","readyReplicas": 1,"tags": ["app:productpage","namespace:bookinfo"],"vertexType": "resource","uniqueId": "reviews-v2-id"}'
curl -X "POST" "https://demo-noi-topology.noi.$CLUSTER_NAME/1.0/rest-observer/rest/resources" --insecure -H 'Content-Type: application/json' -u $NOI_REST_USR':'$NOI_REST_PWD -H 'JobId: listenJob' -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' -d $'{"app": "bookinfo","availableReplicas": 1,"createdReplicas": 1,"dataCenter": "demo","desiredReplicas": 1,"entityTypes": ["deployment"],"matchTokens": ["details-v1"],"name": "details-v1","namespace": "bookinfo","readyReplicas": 1,"tags": ["app:productpage","namespace:bookinfo"],"vertexType": "resource","uniqueId": "details-v1-id"}'
curl -X "POST" "https://demo-noi-topology.noi.$CLUSTER_NAME/1.0/rest-observer/rest/resources" --insecure -H 'Content-Type: application/json' -u $NOI_REST_USR':'$NOI_REST_PWD -H 'JobId: listenJob' -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' -d $'{"app": "bookinfo","availableReplicas": 1,"createdReplicas": 1,"dataCenter": "demo","desiredReplicas": 1,"entityTypes": ["deployment"],"matchTokens": ["ratings-v1"],"name": "ratings-v1","namespace": "bookinfo","readyReplicas": 1,"tags": ["app:productpage","namespace:bookinfo"],"vertexType": "resource","uniqueId": "ratings-v1-id"}'

curl -X "POST" "https://demo-noi-topology.noi.$CLUSTER_NAME/1.0/rest-observer/rest/references" --insecure -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' -H 'JobId: listenJob' -H 'Content-Type: application/json; charset=utf-8' -u $NOI_REST_USR':'$NOI_REST_PWD -d $'{"_edgeType": "connectedTo","_fromUniqueId": "productpage-v1-id","_toUniqueId": "details-v1-id"}'
curl -X "POST" "https://demo-noi-topology.noi.$CLUSTER_NAME/1.0/rest-observer/rest/references" --insecure -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' -H 'JobId: listenJob' -H 'Content-Type: application/json; charset=utf-8' -u $NOI_REST_USR':'$NOI_REST_PWD -d $'{"_edgeType": "connectedTo","_fromUniqueId": "productpage-v1-id","_toUniqueId": "reviews-v2-id"}'
curl -X "POST" "https://demo-noi-topology.noi.$CLUSTER_NAME/1.0/rest-observer/rest/references" --insecure -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' -H 'JobId: listenJob' -H 'Content-Type: application/json; charset=utf-8' -u $NOI_REST_USR':'$NOI_REST_PWD -d $'{"_edgeType": "connectedTo","_fromUniqueId": "reviews-v2-id","_toUniqueId": "ratings-v1-id"}'



# Pods
curl -X "POST" "https://demo-noi-topology.noi.$CLUSTER_NAME/1.0/rest-observer/rest/resources" --insecure -H 'Content-Type: application/json' -u $NOI_REST_USR':'$NOI_REST_PWD -H 'JobId: listenJob' -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' -d $'{"app": "bookinfo","dataCenter": "demo","entityTypes": ["pod"],"matchTokens": ["productpage-v1-pod"],"name": "productpage-v1-pod","namespace": "bookinfo","readyReplicas": 1,"tags": ["app:productpage","namespace:bookinfo"],"vertexType": "resource","uniqueId": "productpage-v1-pod"}'
curl -X "POST" "https://demo-noi-topology.noi.$CLUSTER_NAME/1.0/rest-observer/rest/resources" --insecure -H 'Content-Type: application/json' -u $NOI_REST_USR':'$NOI_REST_PWD -H 'JobId: listenJob' -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' -d $'{"app": "bookinfo","dataCenter": "demo","entityTypes": ["pod"],"matchTokens": ["reviews-v2-pod"],"name": "reviews-v2-pod","namespace": "bookinfo","readyReplicas": 1,"tags": ["app:productpage","namespace:bookinfo"],"vertexType": "resource","uniqueId": "reviews-v2-pod"}'
curl -X "POST" "https://demo-noi-topology.noi.$CLUSTER_NAME/1.0/rest-observer/rest/resources" --insecure -H 'Content-Type: application/json' -u $NOI_REST_USR':'$NOI_REST_PWD -H 'JobId: listenJob' -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' -d $'{"app": "bookinfo","dataCenter": "demo","entityTypes": ["pod"],"matchTokens": ["details-v1-pod"],"name": "details-v1-pod","namespace": "bookinfo","readyReplicas": 1,"tags": ["app:productpage","namespace:bookinfo"],"vertexType": "resource","uniqueId": "details-v1-pod"}'
curl -X "POST" "https://demo-noi-topology.noi.$CLUSTER_NAME/1.0/rest-observer/rest/resources" --insecure -H 'Content-Type: application/json' -u $NOI_REST_USR':'$NOI_REST_PWD -H 'JobId: listenJob' -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' -d $'{"app": "bookinfo","dataCenter": "demo","entityTypes": ["pod"],"matchTokens": ["ratings-v1-pod"],"name": "ratings-v1-pod","namespace": "bookinfo","readyReplicas": 1,"tags": ["app:productpage","namespace:bookinfo"],"vertexType": "resource","uniqueId": "ratings-v1-pod"}'


curl -X "POST" "https://demo-noi-topology.noi.$CLUSTER_NAME/1.0/rest-observer/rest/references" --insecure -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' -H 'JobId: listenJob' -H 'Content-Type: application/json; charset=utf-8' -u $NOI_REST_USR':'$NOI_REST_PWD -d $'{"_edgeType": "connectedTo","_fromUniqueId": "productpage-v1-id","_toUniqueId": "productpage-v1-pod"}'
curl -X "POST" "https://demo-noi-topology.noi.$CLUSTER_NAME/1.0/rest-observer/rest/references" --insecure -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' -H 'JobId: listenJob' -H 'Content-Type: application/json; charset=utf-8' -u $NOI_REST_USR':'$NOI_REST_PWD -d $'{"_edgeType": "connectedTo","_fromUniqueId": "reviews-v2-id","_toUniqueId": "reviews-v2-pod"}'
curl -X "POST" "https://demo-noi-topology.noi.$CLUSTER_NAME/1.0/rest-observer/rest/references" --insecure -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' -H 'JobId: listenJob' -H 'Content-Type: application/json; charset=utf-8' -u $NOI_REST_USR':'$NOI_REST_PWD -d $'{"_edgeType": "connectedTo","_fromUniqueId": "ratings-v1-id","_toUniqueId": "ratings-v1-pod"}'
curl -X "POST" "https://demo-noi-topology.noi.$CLUSTER_NAME/1.0/rest-observer/rest/references" --insecure -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' -H 'JobId: listenJob' -H 'Content-Type: application/json; charset=utf-8' -u $NOI_REST_USR':'$NOI_REST_PWD -d $'{"_edgeType": "connectedTo","_fromUniqueId": "details-v1-id","_toUniqueId": "details-v1-pod"}'



# Services
curl -X "POST" "https://demo-noi-topology.noi.$CLUSTER_NAME/1.0/rest-observer/rest/resources" --insecure -H 'Content-Type: application/json' -u $NOI_REST_USR':'$NOI_REST_PWD -H 'JobId: listenJob' -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' -d $'{"app": "bookinfo","dataCenter": "demo","entityTypes": ["service"],"matchTokens": ["productpage-v1-svc"],"name": "productpage-v1-svc","namespace": "bookinfo","readyReplicas": 1,"tags": ["app:productpage","namespace:bookinfo"],"vertexType": "resource","uniqueId": "productpage-v1-svc"}'
curl -X "POST" "https://demo-noi-topology.noi.$CLUSTER_NAME/1.0/rest-observer/rest/resources" --insecure -H 'Content-Type: application/json' -u $NOI_REST_USR':'$NOI_REST_PWD -H 'JobId: listenJob' -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' -d $'{"app": "bookinfo","dataCenter": "demo","entityTypes": ["service"],"matchTokens": ["reviews-v2-svc"],"name": "reviews-v2-svc","namespace": "bookinfo","readyReplicas": 1,"tags": ["app:productpage","namespace:bookinfo"],"vertexType": "resource","uniqueId": "reviews-v2-svc"}'
curl -X "POST" "https://demo-noi-topology.noi.$CLUSTER_NAME/1.0/rest-observer/rest/resources" --insecure -H 'Content-Type: application/json' -u $NOI_REST_USR':'$NOI_REST_PWD -H 'JobId: listenJob' -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' -d $'{"app": "bookinfo","dataCenter": "demo","entityTypes": ["service"],"matchTokens": ["details-v1-svc"],"name": "details-v1-svc","namespace": "bookinfo","readyReplicas": 1,"tags": ["app:productpage","namespace:bookinfo"],"vertexType": "resource","uniqueId": "details-v1-svc"}'
curl -X "POST" "https://demo-noi-topology.noi.$CLUSTER_NAME/1.0/rest-observer/rest/resources" --insecure -H 'Content-Type: application/json' -u $NOI_REST_USR':'$NOI_REST_PWD -H 'JobId: listenJob' -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' -d $'{"app": "bookinfo","dataCenter": "demo","entityTypes": ["service"],"matchTokens": ["ratings-v1-svc"],"name": "ratings-v1-svc","namespace": "bookinfo","readyReplicas": 1,"tags": ["app:productpage","namespace:bookinfo"],"vertexType": "resource","uniqueId": "ratings-v1-svc"}'



curl -X "POST" "https://demo-noi-topology.noi.$CLUSTER_NAME/1.0/rest-observer/rest/references" --insecure -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' -H 'JobId: listenJob' -H 'Content-Type: application/json; charset=utf-8' -u $NOI_REST_USR':'$NOI_REST_PWD -d $'{"_edgeType": "connectedTo","_fromUniqueId": "productpage-v1-pod","_toUniqueId": "productpage-v1-svc"}'
curl -X "POST" "https://demo-noi-topology.noi.$CLUSTER_NAME/1.0/rest-observer/rest/references" --insecure -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' -H 'JobId: listenJob' -H 'Content-Type: application/json; charset=utf-8' -u $NOI_REST_USR':'$NOI_REST_PWD -d $'{"_edgeType": "connectedTo","_fromUniqueId": "reviews-v2-pod","_toUniqueId": "reviews-v2-svc"}'
curl -X "POST" "https://demo-noi-topology.noi.$CLUSTER_NAME/1.0/rest-observer/rest/references" --insecure -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' -H 'JobId: listenJob' -H 'Content-Type: application/json; charset=utf-8' -u $NOI_REST_USR':'$NOI_REST_PWD -d $'{"_edgeType": "connectedTo","_fromUniqueId": "ratings-v1-pod","_toUniqueId": "ratings-v1-svc"}'
curl -X "POST" "https://demo-noi-topology.noi.$CLUSTER_NAME/1.0/rest-observer/rest/references" --insecure -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' -H 'JobId: listenJob' -H 'Content-Type: application/json; charset=utf-8' -u $NOI_REST_USR':'$NOI_REST_PWD -d $'{"_edgeType": "connectedTo","_fromUniqueId": "details-v1-pod","_toUniqueId": "details-v1-svc"}'


