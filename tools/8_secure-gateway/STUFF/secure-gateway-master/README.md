# secure-gateway helm chart 

### Enable Hyprid integration between IBM Public Cloudfoundry <-> IBM Cloud private 

In order for Cloudfoundry application to be able to on prem service, e.g on-prem DB as below IBM Secure Gateway service can be used to achieve the secure communication

This project is helm chart to deploy secure-gateway client on IBM Cloud private or any local kuberentes services
![alt secure-gateway](https://raw.githubusercontent.com/ahmadsayed/secure-gateway/master/docs/secure-gateway.png)

### In order to make the helm chart work you need to update the values.yaml 

#### Provision IBM Cloud Secure gateway services 

https://console.bluemix.net/catalog/services/secure-gateway

![alt secure-gateway-id](https://raw.githubusercontent.com/ahmadsayed/secure-gateway/master/docs/securegatewayid.png)

update values.yaml for helm chart, with the values extracted from secure gateway services

```
gatewayID: <gateway id>
token: <jwt toke>
```
#### Connecting to the destination

On my ICP instance I have Mongodb installed exposed only as clusterIP and listen on the standard mongodb port 27017

```
kubectl get svc 

NAME                          TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)          AGE
kubernetes                    ClusterIP   10.0.0.1     <none>        443/TCP          3d
mongo-local-ibm-mongodb-dev   ClusterIP   10.0.0.173   <none>        27017/TCP        2d
```


On the secure gateway for destination will use the service name **mongo-local-ibm-mongodb-dev** and port **27017**

![alt secure-gateway-add-destination](https://raw.githubusercontent.com/ahmadsayed/secure-gateway/master/docs/adding-destination.png)

Now the connection should be established 

Extract the destination Host and Port from secure gateway service

![alt get host and port](https://raw.githubusercontent.com/ahmadsayed/secure-gateway/master/docs/gethostandport.png)

The connection on the attached sheet used in Node-red Cloudfoundry app to update the mongodb on local ICP installation not accessible for internet 

![alt Quick Demo](https://github.com/ahmadsayed/secure-gateway/blob/master/docs/full-demo.gif)
