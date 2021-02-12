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

set -o errexit
set -o pipefail
#set -o xtrace
source ./99_config-global.sh

export SCRIPT_PATH=$(pwd)
export LOG_PATH=""
__getClusterFQDN
__getInstallPath


__output "${GREEN}***************************************************************************************************************************************************${NC}"
__output "${GREEN}***************************************************************************************************************************************************${NC}"
__output "${GREEN}***************************************************************************************************************************************************${NC}"
__output "${GREEN}***************************************************************************************************************************************************${NC}"
__output "  "
__output " ${CYAN} AI OPS on OpenShift${NC}"
__output "  "
__output "${GREEN}***************************************************************************************************************************************************${NC}"
__output "${GREEN}***************************************************************************************************************************************************${NC}"
__output "${GREEN}***************************************************************************************************************************************************${NC}"
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



        while getopts "t:d:p:l:c:" opt
        do
          case "$opt" in
              t ) INPUT_TOKEN="$OPTARG" ;;
              d ) INPUT_PATH="$OPTARG" ;;
              p ) INPUT_PWD="$OPTARG" ;;
              l ) INPUT_LDAPPWD="$OPTARG";;
          esac
        done



        if [[ $INPUT_TOKEN == "" ]];
        then
            __output "       ${RED}ERROR${NC}: Please provide the Registry Token"
            __output "       USAGE: $0 -t <REGISTRY_TOKEN> [-s <STORAGE_CLASS> -l <LDAP_ADMIN_PASSWORD> -d <TEMP_DIRECTORY>]"
            exit 1
        else
            __output "       ${GREEN}Token    ${NC}                 Provided"
            export ENTITLED_REGISTRY_KEY=$INPUT_TOKEN
        fi


        if [[ $INPUT_PATH == "" ]];
        then
            __output "       ${ORANGE}No Path provided, using${NC}   $TEMP_PATH"
        else
            __output "       ${GREEN}Temp Path${NC}      $INPUT_PATH"
            export TEMP_PATH=$INPUT_PATH
        fi


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




header2Begin "Watson AI OPS  2.1 (WAIOPS) will be installed in Cluster ${ORANGE}'$CLUSTER_NAME'${NC}"

# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# CONFIG SUMMARY
# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# ---------------------------------------------------------------------------------------------------------------------------------------------------"
__output "    ---------------------------------------------------------------------------------------------------------------------"
__output " ${CYAN} ${magnifying} Your configuration${NC}"
__output "    ---------------------------------------------------------------------------------------------------------------------"
__output "    ${GREEN}CLUSTER :${NC}                  $CLUSTER_NAME"
__output "    ${GREEN}REGISTRY TOKEN:${NC}            $ENTITLED_REGISTRY_KEY"
__output "    ${GREEN}AI Manager NAMESPACE:${NC}      $WAIOPS_AI_MGR_NAMESPACE"
__output "    ${GREEN}Event Manager NAMESPACE:${NC}   $WAIOPS_EVENT_MGR_NAMESPACE"
__output "    ---------------------------------------------------------------------------------------------------------------------"
__output "    ${GREEN}STORAGE CLASS:${NC}             $WAIOPS_AI_MGR_STORAGE_CLASS_FILE"
__output "    ---------------------------------------------------------------------------------------------------------------------"
__output "    ${GREEN}INSTALL PATH:${NC}              $INSTALL_PATH"
__output "${GREEN}    ---------------------------------------------------------------------------------------------------------------------------${NC}"
__output "  "
header2End



header1End "Initializing"







# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# Installing Prerequisites
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------

header1Begin "Install Prerequisites"
  

    
        header2Begin "Patch OCP Registry"    
            oc patch configs.imageregistry.operator.openshift.io/cluster --patch '{"spec":{"defaultRoute":true}}' --type=merge
        header2End




        header2Begin "Create Namespace $WAIOPS_AI_MGR_NAMESPACE"    
            oc create ns $WAIOPS_AI_MGR_NAMESPACE || true
        header2End




        header2Begin "AI OPS - Install CatalogSource"

            CATALOG_INSTALLED=$(kubectl get -n openshift-marketplace CatalogSource ibm-watson-aiops-catalog -o yaml | grep "lastObservedState: READY" || true) 

            if [[ $CATALOG_INSTALLED =~ "READY" ]]; 
            then
                __output "     ${GREEN}${healthy} CatalogSource already installed... ${ORANGE}Skipping${NC}"
            else
                 kubectl apply -f ./yaml/waiops-base/waiops-catalogsource.yaml

                __output " ${wrench} Restart Marketplace (HACK)"
                    oc delete pod -n openshift-marketplace -l name=marketplace-operator 2>&1
                __output "    ${GREEN}  OK${NC}"
                __output "  "

                progressbar 60
            fi


        header2End




        header2Begin "AI OPS - Install Subscription"

            SUB_INSTALLED=$(kubectl get -n zen Subscription ibm-watson-aiops -o yaml | grep "state: AtLatestKnown" || true) 

            if [[ $SUB_INSTALLED =~ "AtLatestKnown" ]]; 
            then
                __output "     ${GREEN}${healthy} Subscription already installed... ${ORANGE}Skipping${NC}"
            else
                kubectl apply -n $WAIOPS_AI_MGR_NAMESPACE -f ./yaml/waiops-base/waiops-catalog-subscription.yaml || true
                progressbar 120

                SUCCESFUL_SUBS=$(kubectl get -n zen ClusterServiceVersion | grep Succeeded | wc -l || true)

                while  ([[ $SUCCESFUL_SUBS =~ "0" ]] || [[ $SUCCESFUL_SUBS =~ "1" ]] || [[ $SUCCESFUL_SUBS =~ "2" ]]); do 
                    SUCCESFUL_SUBS=$(kubectl get -n zen ClusterServiceVersion | grep Succeeded | wc -l || true)
                    __output "   ${clock} There are still Subscriptions that are not ready $SUCCESFUL_SUBS/3. Waiting for 10 seconds...." && sleep 10; 
                done
                
                __output "    ${GREEN}  OK${NC}"
            fi


           
        header2End



header1End "Install Prerequisites"



# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# Install AIOPS AI Manager
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------

header1Begin "Install AIOPS AI Manager"
  
        if [[ $INSTALL_WAIOPS_MGR == "true" ]]; 
        then
            AI_MANAGER_INSTALLED=$(kubectl get -n zen AIManager -o yaml | grep "phase: \"Complete" || true) 

            if [[ $AI_MANAGER_INSTALLED =~ "Complete" ]]; 
            then
                __output "     ${GREEN}${healthy} AIOPS AI Manager already installed... ${ORANGE}Skipping${NC}"
            else
                ./11_install_aiops_ai_manager.sh 
                echo ""
            fi
        else
            __output "     ${ORANGE}${cross} AIOPS Event Manager (NOI) not activated... Skipping${NC}"
        fi


header1End "Install AIOPS AI Manager"





# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# Install AIOPS Event Manager (NOI)
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------

header1Begin "Install AIOPS Event Manager (NOI)"
      
        if [[ $INSTALL_WAIOPS_EVENT == "true" ]]; 
        then

            EVENT_MANAGER_INSTALLED=$(kubectl get -n $WAIOPS_EVENT_MGR_NAMESPACE NOI -o yaml | grep "phase: OK" || true)

            if [[ $EVENT_MANAGER_INSTALLED =~ "OK" ]]; 
            then
                __output "     ${GREEN}${healthy} AIOPS Event Manager (NOI) already installed... ${ORANGE}Skipping${NC}"
            else
                ./12_install_aiops_event_manager.sh
            fi


                header2Begin "AIOPS Event Manager Connection Details"

                __output "${GREEN}----------------------------------------------------------------------------------------------------------------------------------------------------${NC}"
                __output "${GREEN}----------------------------------------------------------------------------------------------------------------------------------------------------${NC}"

                __output "    AIOPS:"
                __output "        https://netcool.demo-noi.$CLUSTER_NAME:443/"
                __output "        User:     icpadmin"
                __output "        Password: $(kubectl get secret demo-noi-icpadmin-secret -o json -n $WAIOPS_EVENT_MGR_NAMESPACE| grep ICP_ADMIN_PASSWORD  | cut -d : -f2 | cut -d '"' -f2 | base64 -d;)"



                __output "${GREEN}----------------------------------------------------------------------------------------------------------------------------------------------------${NC}"
                __output "    WebGUI:"
                __output "        https://netcool.demo-noi.$CLUSTER_NAME:443/ibm/console"
                __output "        User:     icpadmin"
                __output "        Password: $(kubectl get secret demo-noi-icpadmin-secret -o json -n $WAIOPS_EVENT_MGR_NAMESPACE| grep ICP_ADMIN_PASSWORD  | cut -d : -f2 | cut -d '"' -f2 | base64 -d;)"



                __output "${GREEN}----------------------------------------------------------------------------------------------------------------------------------------------------${NC}"
                __output "    WAS Console:"
                __output "        https://was.demo-noi.$CLUSTER_NAME:443/ibm/console"
                __output "        User:     smadmin"
                __output "        Password: $(kubectl get secret demo-noi-was-secret -o json -n $WAIOPS_EVENT_MGR_NAMESPACE| grep WAS_PASSWORD | cut -d : -f2 | cut -d '"' -f2 | base64 -d;)"



                __output "${GREEN}----------------------------------------------------------------------------------------------------------------------------------------------------${NC}"
                __output "    Impact GUI:"
                __output "        https://impact.demo-noi.$CLUSTER_NAME:443/ibm/console"
                __output "        User:     impactadmin"
                __output "        Password: $(kubectl get secret demo-noi-impact-secret -o json -n $WAIOPS_EVENT_MGR_NAMESPACE| grep IMPACT_ADMIN_PASSWORD | cut -d : -f2 | cut -d '"' -f2 | base64 -d;)"



                __output "${GREEN}----------------------------------------------------------------------------------------------------------------------------------------------------${NC}"
                __output "    Impact Servers:"
                __output "        https://nci-0.demo-noi.$CLUSTER_NAME:443/nameserver/services"
                __output "        User:     impactadmin"
                __output "        Password: $(kubectl get secret demo-noi-impact-secret -o json -n $WAIOPS_EVENT_MGR_NAMESPACE| grep IMPACT_ADMIN_PASSWORD | cut -d : -f2 | cut -d '"' -f2 | base64 -d;)"

                header2End




        else
            __output "     ${ORANGE}${cross} AIOPS Event Manager (NOI) not activated... Skipping${NC}"
        fi
        


        


header1End "Install AIOPS Event Manager (NOI)"







# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# Install AIOPS Event Manager (NOI)
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------

header1Begin "Install Common Services"
  

        header2Begin "Common Services - Install"
            if [[ $INSTALL_CS == "true" ]]; 
            then
                ./20_install_common_services.sh
            else
                __output "     ${ORANGE}${cross} Common Services not activated... Skipping${NC}"
            fi
            
        header2End


header1End "Install Common Services"












# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# Installing Add-Ons
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    
header1Begin "Install Add-Ons"
  
        header2Begin "LDAP - Install"

            INSTALL_LDAP=true
            checkComponentNotInstalled LDAP
            if [[ $MUST_INSTALL == "1" ]]; 
            then

                # --------------------------------------------------------------------------------------------------------------------------------
                #  INSTALL
                # --------------------------------------------------------------------------------------------------------------------------------
                ./41_addon_install_ldap.sh

                    # Check if installation went trough
            else
                __output "     ${RED}${cross} Skipping LDAP Installation${NC}"
            fi
        header2End

header1End "Install Add-Ons"







# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# Post Install
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    
header1Begin "Post Install"

        header2Begin "Enable admin user"
            #oc exec -it -n WAIOPS_AI_MGR_NAMESPACE \
            #$(oc get pod -n WAIOPS_AI_MGR_NAMESPACE -l component=usermgmt | tail -1 | cut -f1 -d\ ) \
            #-- bash -c "/usr/src/server-src/scripts/manage-user.sh --enable-user admin"
        header2End

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


  header3Begin "Adapt Nginx Certs"

            
            PODS_PENDING=""



            while  [[ $PODS_PENDING == "" ]]; do 
                PODS_PENDING=$(oc get pods -l component=ibm-nginx | grep -v "No resources" || true)
                 __output "${clock}   Still checking..."
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
        header3End


header1End "Post Install"









__output "${GREEN}----------------------------------------------------------------------------------------------------------------------------------------------------${NC}"
__output "${GREEN}----------------------------------------------------------------------------------------------------------------------------------------------------${NC}"
__output " ${GREEN}${healthy} AI OPS Installed${NC}"
__output "${GREEN}----------------------------------------------------------------------------------------------------------------------------------------------------${NC}"
__output "${GREEN}----------------------------------------------------------------------------------------------------------------------------------------------------${NC}"
__output "${GREEN}----------------------------------------------------------------------------------------------------------------------------------------------------${NC}"
__output "${GREEN}----------------------------------------------------------------------------------------------------------------------------------------------------${NC}"
__output "${GREEN}----------------------------------------------------------------------------------------------------------------------------------------------------${NC}"
__output "${GREEN}----------------------------------------------------------------------------------------------------------------------------------------------------${NC}"
__output "${GREEN}***************************************************************************************************************************************************${NC}"
__output "${GREEN}***************************************************************************************************************************************************${NC}"


