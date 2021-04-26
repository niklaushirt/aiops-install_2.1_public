# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# Installing Script for all AI OPS components
#
# V2.0 
#
# ©2020 nikh@ch.ibm.com
# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# ---------------------------------------------------------------------------------------------------------------------------------------------------"

export TEMP_PATH=~/aiops-install

# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# Do Not Edit Below
# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# ---------------------------------------------------------------------------------------------------------------------------------------------------"


source ./99_config-global.sh

export SCRIPT_PATH=$(pwd)
export LOG_PATH=""
__getClusterFQDN
__getInstallPath


__output "***************************************************************************************************************************************************"
__output "***************************************************************************************************************************************************"
__output "***************************************************************************************************************************************************"
__output "***************************************************************************************************************************************************"
__output "  "
__output "  AI OPS - Post Install"
__output "  "
__output "***************************************************************************************************************************************************"
__output "***************************************************************************************************************************************************"
__output "***************************************************************************************************************************************************"
__output "  "
__output "  "


# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# Initialization
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
header1Begin "Initializing"




# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# GET PARAMETERS
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
header2Begin "Input Parameters" "magnifying"

        export STORAGE_CLASS_FILE=$WAIOPS_AI_MGR_STORAGE_CLASS_FILE

header2End






# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# Install Checks
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
header2Begin "Install Checks"

        getClusterFQDN
        
        #getHosts

        check_and_install_jq
        check_and_install_cloudctl
        check_and_install_kubectl
        check_and_install_oc
        check_and_install_helm
        checkHelmExecutable
        #check_and_install_yq
        #dockerRunning
        checkOpenshiftReachable
        checkKubeconfigIsSet
        checkStorageClassExists
        checkDefaultStorageDefined
        #checkRegistryCredentials
        

header2End




header2Begin "Watson AI OPS  2.1 (WAIOPS) will be installed in Cluster '$CLUSTER_NAME'"

# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# CONFIG SUMMARY
# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# ---------------------------------------------------------------------------------------------------------------------------------------------------"
__output "    ---------------------------------------------------------------------------------------------------------------------"
__output "  🔎 Your configuration"
__output "    ---------------------------------------------------------------------------------------------------------------------"
__output "    CLUSTER :                  $CLUSTER_NAME"
__output "    REGISTRY TOKEN:            $ENTITLED_REGISTRY_KEY"
__output "    AI Manager NAMESPACE:      $WAIOPS_AI_MGR_NAMESPACE"
__output "    Event Manager NAMESPACE:   $WAIOPS_EVENT_MGR_NAMESPACE"
__output "    ---------------------------------------------------------------------------------------------------------------------"
__output "    STORAGE CLASS:             $WAIOPS_AI_MGR_STORAGE_CLASS_FILE"
__output "    ---------------------------------------------------------------------------------------------------------------------"
__output "    INSTALL PATH:              $INSTALL_PATH"
__output "    ---------------------------------------------------------------------------------------------------------------------------"
__output "  "
header2End



header1End "Initializing"



# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# Install Demo Apps
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    
header1Begin "Install Demo Apps"

    header2Begin "Install Bookinfo"
        oc create ns bookinfo

        oc apply -n bookinfo -f ./demo_install/bookinfo/bookinfo.yaml

        oc apply -n default -f ./demo_install/bookinfo/bookinfo-create-load.yaml
    header2End

    header2Begin "Install Kubetoy"
        kubectl create ns kubetoy
        kubectl apply -n kubetoy -f ./demo_install/kubetoy/kubetoy_all_in_one.yaml
    header2End

    header2Begin "Install RobotShop"
        oc create ns robot-shop

        oc adm policy add-scc-to-user privileged -n robot-shop -z robot-shop
        oc create clusterrolebinding default-robotinfo1-admin --clusterrole=cluster-admin --serviceaccount=robot-shop:robot-shop


        kubectl apply -f ./demo_install/robotshop/robot-all-in-one.yaml -n robot-shop
        kubectl apply -n robot-shop -f ./demo_install/robotshop/load-deployment.yaml
    header2End

header1End "Install Demo Apps"



# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# Install Humio
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
header1Begin "Install Humio"
    if [[ $INSTALL_HUMIO == "true" ]]; 
    then
        header2Begin "Install Humio"
            helm repo add humio https://humio.github.io/humio-helm-charts
            helm repo update

            oc create ns humio-logging

            helm install humio-instance humio/humio-helm-charts \
            --namespace humio-logging \
            --values ./tools/4_integrations/humio/humio-install.yaml

            oc adm policy add-scc-to-user privileged -n humio-logging -z humio-instance
            oc adm policy add-scc-to-user privileged -n humio-logging -z default

            kubectl apply -n humio-logging -f ./tools/4_integrations/humio/humio-route.yaml

            kubectl delete -n humio-logging secret developer-user-password
            kubectl apply -n humio-logging -f ./tools/4_integrations/humio/change-humio-dev-pwd.yaml
            kubectl delete -n humio-logging pod humio-instance-humio-core-0

            __output " ✅ HUMIO Installed"
            __output "  ⚠️ Please check the documentation in order to create the Fluentbit agents!"


        header2End
      

    else
        __output "     ❌ Humio not activated... Skipping"
    fi

header1End "Housekeeping"




# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# Patch Ingress 
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
header1Begin "Patch Ingress"

            endpointPublishingStrategy=$(oc get ingresscontroller default -n openshift-ingress-operator -o yaml | grep HostNetwork || true) 

            if [[ $endpointPublishingStrategy =~ "HostNetwork" ]]; 
            then
                header2Begin "Patch Ingress"
                    oc patch namespace default --type=json -p '[{"op":"add","path":"/metadata/labels","value":{"network.openshift.io/policy-group":"ingress"}}]'
                    __output "     ✅ Ingress successfully patched"
                header2End
            else
                __output "     ⭕ Not needed... Skipping"
            fi
header1End "Patch Ingress"




# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# Create Strimzi Route
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
header1Begin "Create Strimzi Route"

    header2Begin "Create Strimzi Route"
           kubectl patch Kafka strimzi-cluster -n zen -p '{"spec": {"kafka": {"listeners": {"external": {"type": "route"}}}}}' --type=merge
    header2End

header1End "Create Strimzi Route"



header1Begin "Create Topology Routes"

    header2Begin "Create Topology Merge Route"
            oc create route passthrough topology-merge -n $WAIOPS_NAMESPACE --service=evtmanager-topology-merge --port=merge-api
            ACT_ROUTE=$(oc get route topology-merge -o jsonpath='{ .spec.host}')

           __output "$ACT_ROUTE/1.0/merge/swagger"
    header2End

header1End "Create Strimzi Route"





# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# Housekeeping
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------    
header1Begin "Housekeeping"


        header2Begin "Adapt ROKS S3 Training"
            oc project zen 
            oc exec $(oc get pods -l app.kubernetes.io/component=model-train-console -o jsonpath='{ .items[*].metadata.name }') -- sed -i 's/type: mount_cos/type: s3_datastore/g' /home/zeno/train/manifests/s3fs-pvc/event_group.yaml
            oc exec $(oc get pods -l app.kubernetes.io/component=model-train-console -o jsonpath='{ .items[*].metadata.name }') -- sed -i 's/type: mount_cos/type: s3_datastore/g' /home/zeno/train/manifests/s3fs-pvc/event_group_eval.yaml
            oc exec $(oc get pods -l app.kubernetes.io/component=model-train-console -o jsonpath='{ .items[*].metadata.name }') -- sed -i 's/type: mount_cos/type: s3_datastore/g' /home/zeno/train/manifests/s3fs-pvc/event_ingest.yaml
            oc exec $(oc get pods -l app.kubernetes.io/component=model-train-console -o jsonpath='{ .items[*].metadata.name }') -- sed -i 's/type: mount_cos/type: s3_datastore/g' /home/zeno/train/manifests/s3fs-pvc/log_anomaly.yaml
            oc exec $(oc get pods -l app.kubernetes.io/component=model-train-console -o jsonpath='{ .items[*].metadata.name }') -- sed -i 's/type: mount_cos/type: s3_datastore/g' /home/zeno/train/manifests/s3fs-pvc/log_anomaly_eval.yaml
            oc exec $(oc get pods -l app.kubernetes.io/component=model-train-console -o jsonpath='{ .items[*].metadata.name }') -- sed -i 's/type: mount_cos/type: s3_datastore/g' /home/zeno/train/manifests/s3fs-pvc/log_ingest.yaml
            oc exec $(oc get pods -l app.kubernetes.io/component=model-train-console -o jsonpath='{ .items[*].metadata.name }') -- sed -i 's/type: mount_cos/type: s3_datastore/g' /home/zeno/train/manifests/s3fs-pvc/log_ingest_eval.yaml
        header2End


        header2Begin "Creaete Flink Job Manager Route"
            oc create route passthrough job-manager --service=demo-aimanager-ibm-flink-job-manager --port=8000
        header2End


        header2Begin "Adapt Nginx Certs"

            PODS_PENDING=""

            while  [[ $PODS_PENDING == "" ]]; do 
                PODS_PENDING=$(oc get pods -l component=ibm-nginx | grep -v "No resources" || true)
                 __output "🕦   Still checking..."
                sleep 5
            done

            oc get secrets -n openshift-ingress | grep tls | grep -v router-metrics-certs-default | awk '{print $1}' | xargs oc get secret -n openshift-ingress -o yaml > tmpcert.yaml
            cat tmpcert.yaml | grep " tls.crt" | awk '{print $2}' |base64 -d > cert.crt
            cat tmpcert.yaml | grep " tls.key" | awk '{print $2}' |base64 -d > cert.key
            ibm_nginx_pod=$(oc get pods -l component=ibm-nginx -o jsonpath='{ .items[0].metadata.name }')
            oc exec ${ibm_nginx_pod} -- mkdir -p "/user-home/_global_/customer-certs"
            oc cp cert.crt ${ibm_nginx_pod}:/user-home/_global_/customer-certs/
            oc cp cert.key ${ibm_nginx_pod}:/user-home/_global_/customer-certs/
            for i in `oc get pods -l component=ibm-nginx -o jsonpath='{ .items[*].metadata.name }' `; do oc exec ${i} -- /scripts/reload.sh; done
            rm tmpcert.yaml cert.crt cert.key
        header2End

        header2Begin "Creaete OCP User"
            kubectl create serviceaccount -n default demo-admin
            oc create clusterrolebinding test-admin --clusterrole=cluster-admin --serviceaccount=default:demo-admin


            DEMO_TOKEN=$(oc -n default get secret $(oc get secret -n default |grep -m1 demo-admin-token|awk '{print$1}') -o jsonpath='{.data.token}'|base64 -d)
            DEMO_URL=$(oc status|grep -m1 "In project"|awk '{print$6}')
            echo  "oc login --token=$DEMO_TOKEN --server=$DEMO_URL"

            __output "oc login --token=$DEMO_TOKEN --server=$DEMO_URL"

        header2End








__output "----------------------------------------------------------------------------------------------------------------------------------------------------"
__output "----------------------------------------------------------------------------------------------------------------------------------------------------"
__output " ✅ AI OPS Installed"
__output "----------------------------------------------------------------------------------------------------------------------------------------------------"
__output "----------------------------------------------------------------------------------------------------------------------------------------------------"
__output "----------------------------------------------------------------------------------------------------------------------------------------------------"
__output "----------------------------------------------------------------------------------------------------------------------------------------------------"
__output "----------------------------------------------------------------------------------------------------------------------------------------------------"
__output "----------------------------------------------------------------------------------------------------------------------------------------------------"
__output "***************************************************************************************************************************************************"
__output "***************************************************************************************************************************************************"


