#!/bin/bash

#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# ADAPT VALUES
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



export NETCOOL_WEBHOOK=https://netcool.demo-noi.aiopsch-a376efc1170b9b8ace6422196c51e491-0000.us-south.containers.appdomain.cloud/norml/webhook/humio/cfd95b7e-3bc7-4006-a4a8-a73a79c71255/98503f2e-b95d-4a13-a798-b4bb2f47e40c/Bvii7CKKBzTpLeeDBzru95KET6i6I_fU9zjO34zFTa8


# Bookinfo
export appgroupid1=zvqubqka
export appid1=yqyy711o
# Kubetoy
export appgroupid2=3bglxest
export appid2=3bglxest
# Sockshop
export appgroupid3=k8muiz8w
export appid3=emjei3wm

# Only for Topology Load
export NOI_REST_USR=demo-noi-topology-noi-user
export NOI_REST_PWD=NO+zKS6/MdeHthdGKki2cLIytUK6j43BApUKwYppJ3o=

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




press_enter() {
  echo ""
  echo "	${ORANGE}Press Enter to continue${NC} "
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
      echo "      OK"
      echo "  ${telescope}  Cluster URL: $CLUSTER_NAME"
  else 
      echo "      ERROR: Please log in via the OpenShift web console"
      echo "           ${RED}${cross} Aborting."
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



# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# Get some Color ;-)
# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# ---------------------------------------------------------------------------------------------------------------------------------------------------"
export GREEN='\033[0;32m'
export ORANGE='\033[0;33m'
export BLUE='\033[1;34m'
export RED='\033[0;31m'
export NC='\033[0m' # No Color
export PURPLE="\033[0;35m"       # Purple
export CYAN="\033[0;36m"         # Cyan
export WHITE="\033[0;37m"        # White

# https://apps.timwhitlock.info/emoji/tables/unicode#block-2-dingbats
export beer='\xF0\x9f\x8d\xba'
export delivery='\xF0\x9F\x9A\x9A'
export beers='\xF0\x9F\x8D\xBB'
export eyes='\xF0\x9F\x91\x80'
export cloud='\xE2\x98\x81'
export crossbones='\xE2\x98\xA0'
export litter='\xF0\x9F\x9A\xAE'
export fail='\xE2\x9B\x94'
export harpoons='\xE2\x87\x8C'
export tools='\xE2\x9A\x92'
export present='\xF0\x9F\x8E\x81'

export telescope='\xF0\x9F\x94\xAD'
export globe='\xF0\x9F\x8C\x90'
export clock='\xF0\x9F\x95\x93'
export wrench='\xF0\x9F\x94\xA7'
export key='\xF0\x9F\x94\x90'
export magnifying='\xF0\x9F\x94\x8D'
export package='\xF0\x9F\x93\xA6'
export memo='\xF0\x9F\x93\x9D'
export explosion='\xF0\x9F\x92\xA5'
export rocket='\xF0\x9F\x9A\x80'
export cross='\xE2\x9D\x8C'
export healthy='\xE2\x9C\x85'
export whitequestion='\xE2\x9D\x93'
export hand='\xE2\x9C\x8B'
export exclamation='\xE2\x9D\x97'
export aaaa='aaaa'
export aaaa='aaaa'
export aaaa='aaaa'
export aaaa='aaaa'
export aaaa='aaaa'
export aaaa='aaaa'



# https://gist.github.com/vratiu/9780109
# Reset
export Color_Off="\033[0m"       # Text Reset

# Regular Colors
export Black="\033[0;30m"        # Black
export Red="\033[0;31m"          # Red
export Green="\033[0;32m"        # Green
export Yellow="\033[0;33m"       # Yellow
export Blue="\033[0;34m"         # Blue
export Purple="\033[0;35m"       # Purple
export Cyan="\033[0;36m"         # Cyan
export White="\033[0;37m"        # White

# Bold
export BBlack="\033[1;30m"       # Black
export BRed="\033[1;31m"         # Red
export BGreen="\033[1;32m"       # Green
export BYellow="\033[1;33m"      # Yellow
export BBlue="\033[1;34m"        # Blue
export BPurple="\033[1;35m"      # Purple
export BCyan="\033[1;36m"        # Cyan
export BWhite="\033[1;37m"       # White

# Underline
export UBlack="\033[4;30m"       # Black
export URed="\033[4;31m"         # Red
export UGreen="\033[4;32m"       # Green
export UYellow="\033[4;33m"      # Yellow
export UBlue="\033[4;34m"        # Blue
export UPurple="\033[4;35m"      # Purple
export UCyan="\033[4;36m"        # Cyan
export UWhite="\033[4;37m"       # White

# Background
export On_Black="\033[40m"       # Black
export On_Red="\033[41m"         # Red
export On_Green="\033[42m"       # Green
export On_Yellow="\033[43m"      # Yellow
export On_Blue="\033[44m"        # Blue
export On_Purple="\033[45m"      # Purple
export On_Cyan="\033[46m"        # Cyan
export On_White="\033[47m"       # White

# High Intensty
export IBlack="\033[0;90m"       # Black
export IRed="\033[0;91m"         # Red
export IGreen="\033[0;92m"       # Green
export IYellow="\033[0;93m"      # Yellow
export IBlue="\033[0;94m"        # Blue
export IPurple="\033[0;95m"      # Purple
export ICyan="\033[0;96m"        # Cyan
export IWhite="\033[0;97m"       # White

# Bold High Intensty
export BIBlack="\033[1;90m"      # Black
export BIRed="\033[1;91m"        # Red
export BIGreen="\033[1;92m"      # Green
export BIYellow="\033[1;93m"     # Yellow
export BIBlue="\033[1;94m"       # Blue
export BIPurple="\033[1;95m"     # Purple
export BICyan="\033[1;96m"       # Cyan
export BIWhite="\033[1;97m"      # White

# High Intensty backgrounds
export On_IBlack="\033[0;100m"   # Black
export On_IRed="\033[0;101m"     # Red
export On_IGreen="\033[0;102m"   # Green
export On_IYellow="\033[0;103m"  # Yellow
export On_IBlue="\033[0;104m"    # Blue
export On_IPurple="\033[10;95m"  # Purple
export On_ICyan="\033[0;106m"    # Cyan
export On_IWhite="\033[0;107m"   # White


function banner() {
__output "${RED}${NC}"
__output "${RED}${NC}"
__output "${RED} .d8888b.  8888888b.     d8888  888b     d888  .d8888b.  888b     d888 {NC}"
__output "${RED}d88P  Y88b 888   Y88b   d8P888  8888b   d8888 d88P  Y88b 8888b   d8888 {NC}"
__output "${RED}888    888 888    888  d8P 888  88888b.d88888 888    888 88888b.d88888 {NC}"
__output "${RED}888        888   d88P d8P  888  888Y88888P888 888        888Y88888P888 {NC}"
__output "${RED}888        8888888P  d88   888  888 Y888P 888 888        888 Y888P 888 {NC}"
__output "${RED}888    888 888       8888888888 888  Y8P  888 888    888 888  Y8P  888 {NC}"
__output "${RED}Y88b  d88P 888             888  888   "   888 Y88b  d88P 888   "   888 {NC}"
__output "${RED} "Y8888P"  888             888  888       888  "Y8888P"  888       888 {NC}"
__output "${RED}                                                                  ${NC}"

}                               
