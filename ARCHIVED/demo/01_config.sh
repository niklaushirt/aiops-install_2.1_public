#!/bin/bash

#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# ADAPT VALUES
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


# Webhooks for Event injection
export NETCOOL_WEBHOOK_HUMIO=https://netcool.demo-noi.aiops-a376efc1170b9b8ace6422196c51e491-0000.eu-de.containers.appdomain.cloud/norml/webhook/humio/cfd95b7e-3bc7-4006-a4a8-a73a79c71255/b772dd26-50e2-4f7e-9190-806aa6205e28/njlLpozGhjWIBobyXogHf5ICFaPgd4K5m_5EcZW5Y4s

export NETCOOL_WEBHOOK_GIT=https://netcool.demo-noi.aiops-a376efc1170b9b8ace6422196c51e491-0000.eu-de.containers.appdomain.cloud/norml/webhook/webhookincomming/cfd95b7e-3bc7-4006-a4a8-a73a79c71255/df319ce1-84e7-4d21-8e09-c823a5e581a5/42jfMVelk1NwsmAcUX3m4uoIKPZOpLdqve0XQ1muR6o

export NETCOOL_WEBHOOK_METRICS=https://netcool.demo-noi.aiops-a376efc1170b9b8ace6422196c51e491-0000.eu-de.containers.appdomain.cloud/norml/webhook/webhookincomming/cfd95b7e-3bc7-4006-a4a8-a73a79c71255/973ffa0c-febe-41cf-bbe0-7c087d51972f/D2fovHgbLkoXqzXiredb0jVsZngb6NkJ4yoyps2jo40

export NETCOOL_WEBHOOK_FALCO=https://netcool.demo-noi.aiops-a376efc1170b9b8ace6422196c51e491-0000.eu-de.containers.appdomain.cloud/norml/webhook/webhookincomming/cfd95b7e-3bc7-4006-a4a8-a73a79c71255/82bc04bc-9dca-4fd9-aab7-2673f4923e80/bz1o9AYIIp1rhaLji3RtY3BOCETeeT1UOF88UmgUg7Y

export NETCOOL_WEBHOOK_INSTANA=https://netcool.demo-noi.aiops-a376efc1170b9b8ace6422196c51e491-0000.eu-de.containers.appdomain.cloud/norml/webhook/webhookincomming/cfd95b7e-3bc7-4006-a4a8-a73a79c71255/371480f7-c9f1-422b-acf1-db48d43ccae7/QHhJmKf1StqhPkxQ8yXknwKRTl0arRncrQtZhcjXzWQ


# Bookinfo
export appgroupid1=zjecaqq2
export appid1=nir5ix68
# Kubetoy
export appgroupid2=p8agtlvy
export appid2=wvaw2akr
# Sockshop
export appgroupid3=3xjv76wf
export appid3=dbga061x

# Only for Topology Load
export NOI_REST_USR=demo-noi-topology-noi-user
export NOI_REST_PWD=BBLjKYCSUjn5kBduk5RN6G6zX0ywdgwzOO+/ilCseBo=

#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# DO NOT EDIT BELOW
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


















































createTopics() {
cat <<EOF | kubectl apply -f -
apiVersion: kafka.strimzi.io/v1beta1
kind: KafkaTopic
metadata:
  name: normalized-alerts-$appgroupid-$appid 
  namespace: zen
  labels:
    strimzi.io/cluster: strimzi-cluster
spec:
  config:
    max.message.bytes: '1048588'
    retention.ms: '1800000'
    segment.bytes: '1073741824'
  partitions: 1
  replicas: 1
  topicName: normalized-alerts-$appgroupid-$appid 
---
apiVersion: kafka.strimzi.io/v1beta1
kind: KafkaTopic
metadata:
  name: windowed-logs-$appgroupid-$appid 
  namespace: zen
  labels:
    strimzi.io/cluster: strimzi-cluster
spec:
  config:
    max.message.bytes: '1048588'
    retention.ms: '1800000'
    segment.bytes: '1073741824'
  partitions: 1
  replicas: 1
  topicName: windowed-logs-$appgroupid-$appid 
EOF
}


createDerivedStoriesTopics() {
cat <<EOF | kubectl apply -f -
apiVersion: kafka.strimzi.io/v1beta1
kind: KafkaTopic
metadata:
  name: derived-stories
  namespace: zen
  labels:
    strimzi.io/cluster: strimzi-cluster
spec:
  config:
    max.message.bytes: '1048588'
    retention.ms: '1800000'
    segment.bytes: '1073741824'
  partitions: 1
  replicas: 1
  topicName: derived-stories 
EOF
}


press_enter() {
  echo ""
  echo "	Press Enter to continue "
  read
  clear
}


checkK8sConnection () {
  CLUSTER_ROUTE=$(kubectl get routes console -n openshift-console | tail -n 1 2>&1 ) 

  if [[ $CLUSTER_ROUTE =~ "reencrypt/Redirect" ]];
  then
      CLUSTER_FQDN=$( echo $CLUSTER_ROUTE | awk '{print $2}')
      export OCP_CONSOLE_PREFIX=console-openshift-console
      export CLUSTER_NAME=$(echo $CLUSTER_FQDN | ${SED} "s/$OCP_CONSOLE_PREFIX.//")
      echo "      ✅ OK"
      echo "  🔭  Cluster URL: $CLUSTER_NAME"
  else 
      echo "      ❗ ERROR: Please log in via the OpenShift web console"
      echo "           ❌ Aborting."
      exit 1
  fi
}

incorrect_selection() {
  echo "Incorrect selection! Try again."
}

get_sed(){
  # fix sed issue on mac
  OS=$(uname -s | tr '[:upper:]' '[:lower:]')
  SED="sed"
  if [ "${OS}" == "darwin" ]; then
      SED="gsed"
      if [ ! -x "$(command -v ${SED})"  ]; then
      __output "This script requires $SED, but it was not found.  Perform \"brew install gnu-sed\" and try again."
      exit
      fi
  fi
}



function banner() {


echo "   __________  __ ___       _____    ________            "
echo "  / ____/ __ \/ // / |     / /   |  /  _/ __ \____  _____"
echo " / /   / /_/ / // /| | /| / / /| |  / // / / / __ \/ ___/"
echo "/ /___/ ____/__  __/ |/ |/ / ___ |_/ // /_/ / /_/ (__  ) "
echo "\____/_/      /_/  |__/|__/_/  |_/___/\____/ .___/____/  "
echo "                                          /_/            "
echo ""

}                               
