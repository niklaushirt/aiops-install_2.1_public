# Deployments
curl -X "POST" "https://demo-noi-topology.noi.$CLUSTER_NAME/1.0/rest-observer/rest/resources" --insecure -H 'Content-Type: application/json' -u $NOI_REST_USR':'$NOI_REST_PWD -H 'JobId: listenJob' -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' -d $'{"app": "sockshop","availableReplicas": 1,"createdReplicas": 1,"dataCenter": "demo","desiredReplicas": 1,"entityTypes": ["deployment"],"matchTokens": ["front-end"],"name": "front-end","namespace": "sock-shop","readyReplicas": 1,"tags": ["app:sockshop","namespace:sock-shop"],"vertexType": "resource","uniqueId": "front-end-id"}'
curl -X "POST" "https://demo-noi-topology.noi.$CLUSTER_NAME/1.0/rest-observer/rest/resources" --insecure -H 'Content-Type: application/json' -u $NOI_REST_USR':'$NOI_REST_PWD -H 'JobId: listenJob' -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' -d $'{"app": "sockshop","availableReplicas": 1,"createdReplicas": 1,"dataCenter": "demo","desiredReplicas": 1,"entityTypes": ["deployment"],"matchTokens": ["order"],"name": "order","namespace": "sock-shop","readyReplicas": 1,"tags": ["app:sockshop","namespace:sock-shop"],"vertexType": "resource","uniqueId": "order-id"}'
curl -X "POST" "https://demo-noi-topology.noi.$CLUSTER_NAME/1.0/rest-observer/rest/resources" --insecure -H 'Content-Type: application/json' -u $NOI_REST_USR':'$NOI_REST_PWD -H 'JobId: listenJob' -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' -d $'{"app": "sockshop","availableReplicas": 1,"createdReplicas": 1,"dataCenter": "demo","desiredReplicas": 1,"entityTypes": ["deployment"],"matchTokens": ["payment"],"name": "payment","namespace": "sock-shop","readyReplicas": 1,"tags": ["app:sockshop","namespace:sock-shop"],"vertexType": "resource","uniqueId": "payment-id"}'
curl -X "POST" "https://demo-noi-topology.noi.$CLUSTER_NAME/1.0/rest-observer/rest/resources" --insecure -H 'Content-Type: application/json' -u $NOI_REST_USR':'$NOI_REST_PWD -H 'JobId: listenJob' -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' -d $'{"app": "sockshop","availableReplicas": 1,"createdReplicas": 1,"dataCenter": "demo","desiredReplicas": 1,"entityTypes": ["deployment"],"matchTokens": ["user"],"name": "user","namespace": "sock-shop","readyReplicas": 1,"tags": ["app:sockshop","namespace:sock-shop"],"vertexType": "resource","uniqueId": "user-id"}'
curl -X "POST" "https://demo-noi-topology.noi.$CLUSTER_NAME/1.0/rest-observer/rest/resources" --insecure -H 'Content-Type: application/json' -u $NOI_REST_USR':'$NOI_REST_PWD -H 'JobId: listenJob' -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' -d $'{"app": "sockshop","availableReplicas": 1,"createdReplicas": 1,"dataCenter": "demo","desiredReplicas": 1,"entityTypes": ["deployment"],"matchTokens": ["catalogue"],"name": "catalogue","namespace": "sock-shop","readyReplicas": 1,"tags": ["app:sockshop","namespace:sock-shop"],"vertexType": "resource","uniqueId": "catalogue-id"}'
curl -X "POST" "https://demo-noi-topology.noi.$CLUSTER_NAME/1.0/rest-observer/rest/resources" --insecure -H 'Content-Type: application/json' -u $NOI_REST_USR':'$NOI_REST_PWD -H 'JobId: listenJob' -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' -d $'{"app": "sockshop","availableReplicas": 1,"createdReplicas": 1,"dataCenter": "demo","desiredReplicas": 1,"entityTypes": ["deployment"],"matchTokens": ["cart"],"name": "cart","namespace": "sock-shop","readyReplicas": 1,"tags": ["app:sockshop","namespace:sock-shop"],"vertexType": "resource","uniqueId": "cart-id"}'
curl -X "POST" "https://demo-noi-topology.noi.$CLUSTER_NAME/1.0/rest-observer/rest/resources" --insecure -H 'Content-Type: application/json' -u $NOI_REST_USR':'$NOI_REST_PWD -H 'JobId: listenJob' -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' -d $'{"app": "sockshop","availableReplicas": 1,"createdReplicas": 1,"dataCenter": "demo","desiredReplicas": 1,"entityTypes": ["deployment"],"matchTokens": ["shipping"],"name": "shipping","namespace": "sock-shop","readyReplicas": 1,"tags": ["app:sockshop","namespace:sock-shop"],"vertexType": "resource","uniqueId": "shipping-id"}'



curl -X "POST" "https://demo-noi-topology.noi.$CLUSTER_NAME/1.0/rest-observer/rest/references" --insecure -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' -H 'JobId: listenJob' -H 'Content-Type: application/json; charset=utf-8' -u $NOI_REST_USR':'$NOI_REST_PWD -d $'{"_edgeType": "connectedTo","_fromUniqueId": "front-end-id","_toUniqueId": "order-id"}'
curl -X "POST" "https://demo-noi-topology.noi.$CLUSTER_NAME/1.0/rest-observer/rest/references" --insecure -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' -H 'JobId: listenJob' -H 'Content-Type: application/json; charset=utf-8' -u $NOI_REST_USR':'$NOI_REST_PWD -d $'{"_edgeType": "connectedTo","_fromUniqueId": "front-end-id","_toUniqueId": "payment-id"}'
curl -X "POST" "https://demo-noi-topology.noi.$CLUSTER_NAME/1.0/rest-observer/rest/references" --insecure -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' -H 'JobId: listenJob' -H 'Content-Type: application/json; charset=utf-8' -u $NOI_REST_USR':'$NOI_REST_PWD -d $'{"_edgeType": "connectedTo","_fromUniqueId": "front-end-id","_toUniqueId": "user-id"}'
curl -X "POST" "https://demo-noi-topology.noi.$CLUSTER_NAME/1.0/rest-observer/rest/references" --insecure -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' -H 'JobId: listenJob' -H 'Content-Type: application/json; charset=utf-8' -u $NOI_REST_USR':'$NOI_REST_PWD -d $'{"_edgeType": "connectedTo","_fromUniqueId": "front-end-id","_toUniqueId": "catalogue-id"}'
curl -X "POST" "https://demo-noi-topology.noi.$CLUSTER_NAME/1.0/rest-observer/rest/references" --insecure -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' -H 'JobId: listenJob' -H 'Content-Type: application/json; charset=utf-8' -u $NOI_REST_USR':'$NOI_REST_PWD -d $'{"_edgeType": "connectedTo","_fromUniqueId": "front-end-id","_toUniqueId": "cart-id"}'
curl -X "POST" "https://demo-noi-topology.noi.$CLUSTER_NAME/1.0/rest-observer/rest/references" --insecure -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' -H 'JobId: listenJob' -H 'Content-Type: application/json; charset=utf-8' -u $NOI_REST_USR':'$NOI_REST_PWD -d $'{"_edgeType": "connectedTo","_fromUniqueId": "order-id","_toUniqueId": "shipping-id"}'




# Pods
curl -X "POST" "https://demo-noi-topology.noi.$CLUSTER_NAME/1.0/rest-observer/rest/resources" --insecure -H 'Content-Type: application/json' -u $NOI_REST_USR':'$NOI_REST_PWD -H 'JobId: listenJob' -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' -d $'{"app": "sockshop","dataCenter": "demo","entityTypes": ["pod"],"matchTokens": ["front-end-pod"],"name": "front-end-pod","namespace": "sock-shop","readyReplicas": 1,"tags": ["app:sockshop","namespace:sock-shop"],"vertexType": "resource","uniqueId": "front-end-pod-id"}'
curl -X "POST" "https://demo-noi-topology.noi.$CLUSTER_NAME/1.0/rest-observer/rest/resources" --insecure -H 'Content-Type: application/json' -u $NOI_REST_USR':'$NOI_REST_PWD -H 'JobId: listenJob' -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' -d $'{"app": "sockshop","dataCenter": "demo","entityTypes": ["pod"],"matchTokens": ["order-pod"],"name": "order-pod","namespace": "sock-shop","readyReplicas": 1,"tags": ["app:sockshop","namespace:sock-shop"],"vertexType": "resource","uniqueId": "order-pod-id"}'
curl -X "POST" "https://demo-noi-topology.noi.$CLUSTER_NAME/1.0/rest-observer/rest/resources" --insecure -H 'Content-Type: application/json' -u $NOI_REST_USR':'$NOI_REST_PWD -H 'JobId: listenJob' -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' -d $'{"app": "sockshop","dataCenter": "demo","entityTypes": ["pod"],"matchTokens": ["payment-pod"],"name": "payment-pod","namespace": "sock-shop","readyReplicas": 1,"tags": ["app:sockshop","namespace:sock-shop"],"vertexType": "resource","uniqueId": "payment-pod-id"}'
curl -X "POST" "https://demo-noi-topology.noi.$CLUSTER_NAME/1.0/rest-observer/rest/resources" --insecure -H 'Content-Type: application/json' -u $NOI_REST_USR':'$NOI_REST_PWD -H 'JobId: listenJob' -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' -d $'{"app": "sockshop","dataCenter": "demo","entityTypes": ["pod"],"matchTokens": ["user-pod"],"name": "user-pod","namespace": "sock-shop","readyReplicas": 1,"tags": ["app:sockshop","namespace:sock-shop"],"vertexType": "resource","uniqueId": "user-pod-id"}'
curl -X "POST" "https://demo-noi-topology.noi.$CLUSTER_NAME/1.0/rest-observer/rest/resources" --insecure -H 'Content-Type: application/json' -u $NOI_REST_USR':'$NOI_REST_PWD -H 'JobId: listenJob' -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' -d $'{"app": "sockshop","dataCenter": "demo","entityTypes": ["pod"],"matchTokens": ["catalogue-pod"],"name": "catalogue-pod","namespace": "sock-shop","readyReplicas": 1,"tags": ["app:sockshop","namespace:sock-shop"],"vertexType": "resource","uniqueId": "catalogue-pod-id"}'
curl -X "POST" "https://demo-noi-topology.noi.$CLUSTER_NAME/1.0/rest-observer/rest/resources" --insecure -H 'Content-Type: application/json' -u $NOI_REST_USR':'$NOI_REST_PWD -H 'JobId: listenJob' -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' -d $'{"app": "sockshop","dataCenter": "demo","entityTypes": ["pod"],"matchTokens": ["cart-pod"],"name": "cart-pod","namespace": "sock-shop","readyReplicas": 1,"tags": ["app:sockshop","namespace:sock-shop"],"vertexType": "resource","uniqueId": "cart-pod-id"}'
curl -X "POST" "https://demo-noi-topology.noi.$CLUSTER_NAME/1.0/rest-observer/rest/resources" --insecure -H 'Content-Type: application/json' -u $NOI_REST_USR':'$NOI_REST_PWD -H 'JobId: listenJob' -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' -d $'{"app": "sockshop","dataCenter": "demo","entityTypes": ["pod"],"matchTokens": ["shipping-pod"],"name": "shipping-pod","namespace": "sock-shop","readyReplicas": 1,"tags": ["app:sockshop","namespace:sock-shop"],"vertexType": "resource","uniqueId": "shipping-pod-id"}'



curl -X "POST" "https://demo-noi-topology.noi.$CLUSTER_NAME/1.0/rest-observer/rest/references" --insecure -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' -H 'JobId: listenJob' -H 'Content-Type: application/json; charset=utf-8' -u $NOI_REST_USR':'$NOI_REST_PWD -d $'{"_edgeType": "connectedTo","_fromUniqueId": "front-end-id","_toUniqueId": "front-end-pod-id"}'
curl -X "POST" "https://demo-noi-topology.noi.$CLUSTER_NAME/1.0/rest-observer/rest/references" --insecure -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' -H 'JobId: listenJob' -H 'Content-Type: application/json; charset=utf-8' -u $NOI_REST_USR':'$NOI_REST_PWD -d $'{"_edgeType": "connectedTo","_fromUniqueId": "order-id","_toUniqueId": "order-pod-id"}'
curl -X "POST" "https://demo-noi-topology.noi.$CLUSTER_NAME/1.0/rest-observer/rest/references" --insecure -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' -H 'JobId: listenJob' -H 'Content-Type: application/json; charset=utf-8' -u $NOI_REST_USR':'$NOI_REST_PWD -d $'{"_edgeType": "connectedTo","_fromUniqueId": "payment-id","_toUniqueId": "payment-pod-id"}'
curl -X "POST" "https://demo-noi-topology.noi.$CLUSTER_NAME/1.0/rest-observer/rest/references" --insecure -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' -H 'JobId: listenJob' -H 'Content-Type: application/json; charset=utf-8' -u $NOI_REST_USR':'$NOI_REST_PWD -d $'{"_edgeType": "connectedTo","_fromUniqueId": "user-id","_toUniqueId": "user-pod-id"}'
curl -X "POST" "https://demo-noi-topology.noi.$CLUSTER_NAME/1.0/rest-observer/rest/references" --insecure -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' -H 'JobId: listenJob' -H 'Content-Type: application/json; charset=utf-8' -u $NOI_REST_USR':'$NOI_REST_PWD -d $'{"_edgeType": "connectedTo","_fromUniqueId": "catalogue-id","_toUniqueId": "catalogue-pod-id"}'
curl -X "POST" "https://demo-noi-topology.noi.$CLUSTER_NAME/1.0/rest-observer/rest/references" --insecure -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' -H 'JobId: listenJob' -H 'Content-Type: application/json; charset=utf-8' -u $NOI_REST_USR':'$NOI_REST_PWD -d $'{"_edgeType": "connectedTo","_fromUniqueId": "cart-id","_toUniqueId": "cart-pod-id"}'
curl -X "POST" "https://demo-noi-topology.noi.$CLUSTER_NAME/1.0/rest-observer/rest/references" --insecure -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' -H 'JobId: listenJob' -H 'Content-Type: application/json; charset=utf-8' -u $NOI_REST_USR':'$NOI_REST_PWD -d $'{"_edgeType": "connectedTo","_fromUniqueId": "shipping-id","_toUniqueId": "shipping-pod-id"}'




# Services
curl -X "POST" "https://demo-noi-topology.noi.$CLUSTER_NAME/1.0/rest-observer/rest/resources" --insecure -H 'Content-Type: application/json' -u $NOI_REST_USR':'$NOI_REST_PWD -H 'JobId: listenJob' -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' -d $'{"app": "sockshop","dataCenter": "demo","entityTypes": ["pod"],"matchTokens": ["front-end-svc"],"name": "front-end-svc","namespace": "sock-shop","readyReplicas": 1,"tags": ["app:sockshop","namespace:sock-shop"],"vertexType": "resource","uniqueId": "front-end-svc-id"}'
curl -X "POST" "https://demo-noi-topology.noi.$CLUSTER_NAME/1.0/rest-observer/rest/resources" --insecure -H 'Content-Type: application/json' -u $NOI_REST_USR':'$NOI_REST_PWD -H 'JobId: listenJob' -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' -d $'{"app": "sockshop","dataCenter": "demo","entityTypes": ["pod"],"matchTokens": ["order-svc"],"name": "order-svc","namespace": "sock-shop","readyReplicas": 1,"tags": ["app:sockshop","namespace:sock-shop"],"vertexType": "resource","uniqueId": "order-svc-id"}'
curl -X "POST" "https://demo-noi-topology.noi.$CLUSTER_NAME/1.0/rest-observer/rest/resources" --insecure -H 'Content-Type: application/json' -u $NOI_REST_USR':'$NOI_REST_PWD -H 'JobId: listenJob' -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' -d $'{"app": "sockshop","dataCenter": "demo","entityTypes": ["pod"],"matchTokens": ["payment-svc"],"name": "payment-svc","namespace": "sock-shop","readyReplicas": 1,"tags": ["app:sockshop","namespace:sock-shop"],"vertexType": "resource","uniqueId": "payment-svc-id"}'
curl -X "POST" "https://demo-noi-topology.noi.$CLUSTER_NAME/1.0/rest-observer/rest/resources" --insecure -H 'Content-Type: application/json' -u $NOI_REST_USR':'$NOI_REST_PWD -H 'JobId: listenJob' -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' -d $'{"app": "sockshop","dataCenter": "demo","entityTypes": ["pod"],"matchTokens": ["user-svc"],"name": "user-svc","namespace": "sock-shop","readyReplicas": 1,"tags": ["app:sockshop","namespace:sock-shop"],"vertexType": "resource","uniqueId": "user-svc-id"}'
curl -X "POST" "https://demo-noi-topology.noi.$CLUSTER_NAME/1.0/rest-observer/rest/resources" --insecure -H 'Content-Type: application/json' -u $NOI_REST_USR':'$NOI_REST_PWD -H 'JobId: listenJob' -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' -d $'{"app": "sockshop","dataCenter": "demo","entityTypes": ["pod"],"matchTokens": ["catalogue-svc"],"name": "catalogue-svc","namespace": "sock-shop","readyReplicas": 1,"tags": ["app:sockshop","namespace:sock-shop"],"vertexType": "resource","uniqueId": "catalogue-svc-id"}'
curl -X "POST" "https://demo-noi-topology.noi.$CLUSTER_NAME/1.0/rest-observer/rest/resources" --insecure -H 'Content-Type: application/json' -u $NOI_REST_USR':'$NOI_REST_PWD -H 'JobId: listenJob' -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' -d $'{"app": "sockshop","dataCenter": "demo","entityTypes": ["pod"],"matchTokens": ["cart-svc"],"name": "cart-svc","namespace": "sock-shop","readyReplicas": 1,"tags": ["app:sockshop","namespace:sock-shop"],"vertexType": "resource","uniqueId": "cart-svc-id"}'
curl -X "POST" "https://demo-noi-topology.noi.$CLUSTER_NAME/1.0/rest-observer/rest/resources" --insecure -H 'Content-Type: application/json' -u $NOI_REST_USR':'$NOI_REST_PWD -H 'JobId: listenJob' -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' -d $'{"app": "sockshop","dataCenter": "demo","entityTypes": ["pod"],"matchTokens": ["shipping-svc"],"name": "shipping-svc","namespace": "sock-shop","readyReplicas": 1,"tags": ["app:sockshop","namespace:sock-shop"],"vertexType": "resource","uniqueId": "shipping-svc-id"}'



curl -X "POST" "https://demo-noi-topology.noi.$CLUSTER_NAME/1.0/rest-observer/rest/references" --insecure -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' -H 'JobId: listenJob' -H 'Content-Type: application/json; charset=utf-8' -u $NOI_REST_USR':'$NOI_REST_PWD -d $'{"_edgeType": "connectedTo","_fromUniqueId": "front-end-pod-id","_toUniqueId": "front-end-svc-id"}'
curl -X "POST" "https://demo-noi-topology.noi.$CLUSTER_NAME/1.0/rest-observer/rest/references" --insecure -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' -H 'JobId: listenJob' -H 'Content-Type: application/json; charset=utf-8' -u $NOI_REST_USR':'$NOI_REST_PWD -d $'{"_edgeType": "connectedTo","_fromUniqueId": "order-pod-id","_toUniqueId": "order-svc-id"}'
curl -X "POST" "https://demo-noi-topology.noi.$CLUSTER_NAME/1.0/rest-observer/rest/references" --insecure -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' -H 'JobId: listenJob' -H 'Content-Type: application/json; charset=utf-8' -u $NOI_REST_USR':'$NOI_REST_PWD -d $'{"_edgeType": "connectedTo","_fromUniqueId": "payment-pod-id","_toUniqueId": "payment-svc-id"}'
curl -X "POST" "https://demo-noi-topology.noi.$CLUSTER_NAME/1.0/rest-observer/rest/references" --insecure -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' -H 'JobId: listenJob' -H 'Content-Type: application/json; charset=utf-8' -u $NOI_REST_USR':'$NOI_REST_PWD -d $'{"_edgeType": "connectedTo","_fromUniqueId": "user-pod-id","_toUniqueId": "user-svc-id"}'
curl -X "POST" "https://demo-noi-topology.noi.$CLUSTER_NAME/1.0/rest-observer/rest/references" --insecure -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' -H 'JobId: listenJob' -H 'Content-Type: application/json; charset=utf-8' -u $NOI_REST_USR':'$NOI_REST_PWD -d $'{"_edgeType": "connectedTo","_fromUniqueId": "catalogue-pod-id","_toUniqueId": "catalogue-svc-id"}'
curl -X "POST" "https://demo-noi-topology.noi.$CLUSTER_NAME/1.0/rest-observer/rest/references" --insecure -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' -H 'JobId: listenJob' -H 'Content-Type: application/json; charset=utf-8' -u $NOI_REST_USR':'$NOI_REST_PWD -d $'{"_edgeType": "connectedTo","_fromUniqueId": "cart-pod-id","_toUniqueId": "cart-svc-id"}'
curl -X "POST" "https://demo-noi-topology.noi.$CLUSTER_NAME/1.0/rest-observer/rest/references" --insecure -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' -H 'JobId: listenJob' -H 'Content-Type: application/json; charset=utf-8' -u $NOI_REST_USR':'$NOI_REST_PWD -d $'{"_edgeType": "connectedTo","_fromUniqueId": "shipping-pod-id","_toUniqueId": "shipping-svc-id"}'