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
__output " ${CYAN} AI OPS Event Manager Passwords${NC}"
__output "  "
__output "${GREEN}***************************************************************************************************************************************************${NC}"
__output "${GREEN}***************************************************************************************************************************************************${NC}"
__output "${GREEN}***************************************************************************************************************************************************${NC}"
__output "  "
__output "  "

    header1Begin "HUMIO Connection Details"

        header2Begin "TEST"

            
                __output "${GREEN}---------------------------------------------------------------------------------------------${NC}"
                __output "${GREEN}---------------------------------------------------------------------------------------------${NC}"

                __output "    HUMIO:"
                __output "        http://humio-humio-logging.$CLUSTER_NAME/"
                __output "        User:     developer"
                __output "        Password: $(kubectl get secret developer-user-password -n humio-logging -o=template --template={{.data.password}} | base64 -D)"
        header2End
    header1End "HUMIO Connection Details"

    header1Begin "AIOPS Event Manager Connection Details"

        header2Begin "TEST"

            
                __output "${GREEN}---------------------------------------------------------------------------------------------${NC}"
                __output "${GREEN}---------------------------------------------------------------------------------------------${NC}"

                __output "    AIOPS:"
                __output "        https://netcool.demo-noi.$CLUSTER_NAME:443/"
                __output "        User:     icpadmin"
                __output "        Password: $(kubectl get secret demo-noi-icpadmin-secret -o json -n $WAIOPS_EVENT_MGR_NAMESPACE| grep ICP_ADMIN_PASSWORD  | cut -d : -f2 | cut -d '"' -f2 | base64 -d;)"



                __output "${GREEN}---------------------------------------------------------------------------------------------${NC}"
                __output "    WebGUI:"
                __output "        https://netcool.demo-noi.$CLUSTER_NAME:443/ibm/console"
                __output "        User:     icpadmin"
                __output "        Password: $(kubectl get secret demo-noi-icpadmin-secret -o json -n $WAIOPS_EVENT_MGR_NAMESPACE| grep ICP_ADMIN_PASSWORD  | cut -d : -f2 | cut -d '"' -f2 | base64 -d;)"



                __output "${GREEN}---------------------------------------------------------------------------------------------${NC}"
                __output "    WAS Console:"
                __output "        https://was.demo-noi.$CLUSTER_NAME:443/ibm/console"
                __output "        User:     smadmin"
                __output "        Password: $(kubectl get secret demo-noi-was-secret -o json -n $WAIOPS_EVENT_MGR_NAMESPACE| grep WAS_PASSWORD | cut -d : -f2 | cut -d '"' -f2 | base64 -d;)"



                __output "${GREEN}---------------------------------------------------------------------------------------------${NC}"
                __output "    Impact GUI:"
                __output "        https://impact.demo-noi.$CLUSTER_NAME:443/ibm/console"
                __output "        User:     impactadmin"
                __output "        Password: $(kubectl get secret demo-noi-impact-secret -o json -n $WAIOPS_EVENT_MGR_NAMESPACE| grep IMPACT_ADMIN_PASSWORD | cut -d : -f2 | cut -d '"' -f2 | base64 -d;)"



                __output "${GREEN}---------------------------------------------------------------------------------------------${NC}"
                __output "    Impact Servers:"
                __output "        https://nci-0.demo-noi.$CLUSTER_NAME:443/nameserver/services"
                __output "        User:     impactadmin"
                __output "        Password: $(kubectl get secret demo-noi-impact-secret -o json -n $WAIOPS_EVENT_MGR_NAMESPACE| grep IMPACT_ADMIN_PASSWORD | cut -d : -f2 | cut -d '"' -f2 | base64 -d;)"




                __output "${GREEN}---------------------------------------------------------------------------------------------${NC}"
                __output "    ASM TOPOLOGY USER:"
                __output "        https://nci-0.demo-noi.$CLUSTER_NAME:443/nameserver/services"
                __output "        User:     demo-noi-topology-noi-user"
                __output "        Password: $(kubectl get secret demo-noi-topology-asm-credentials -n noi -o=template --template={{.data.password}} | base64 -D)"





        header2End
    header1End "AIOPS Event Manager Connection Details"



