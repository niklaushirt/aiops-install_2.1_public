#!/bin/bash

# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# Variables for install scripts
#
#  AI OPS
#
# ©2020 nikh@ch.ibm.com
# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# ---------------------------------------------------------------------------------------------------------------------------------------------------"


    # ---------------------------------------------------------------------------------------------------------------------------------------------------"
    # Watson AIOps AI Manager
    # ---------------------------------------------------------------------------------------------------------------------------------------------------"

         # Install AIOPS AI Manager 
        export INSTALL_WAIOPS_MGR=true

        # WAIOPS Storage Class (ibmc-file-gold-gid, nfs-client, ...)
        export WAIOPS_AI_MGR_STORAGE_CLASS_FILE=ibmc-file-gold-gid
        #export WAIOPS_AI_MGR_STORAGE_CLASS_FILE=nfs-client


        # Size of the install (small: PoC/Demo, medium, tall)
        export WAIOPS_AI_MGR_SIZE=small

        # WAIOPS AI Manager install namespace (default is zen)
        export WAIOPS_AI_MGR_NAMESPACE=zen




    # ---------------------------------------------------------------------------------------------------------------------------------------------------"
    # Watson AIOps Event Manager
    # ---------------------------------------------------------------------------------------------------------------------------------------------------"

         # Install AIOPS Event Manager (NOI)
        export INSTALL_WAIOPS_EVENT=true

        # WAIOPS Event MAnager install namespace (default is noi)
        export WAIOPS_EVENT_MGR_NAMESPACE=noi



    # ---------------------------------------------------------------------------------------------------------------------------------------------------"
    # Add-ons
    # ---------------------------------------------------------------------------------------------------------------------------------------------------"

         # Install Separate LDAP service
        export INSTALL_SEPARATE_LDAP=false

        # Install Humio and Fluentbit (not implemented yet)
        export INSTALL_HUMIO=false



    # ---------------------------------------------------------------------------------------------------------------------------------------------------"
    # Common Services 
    # ---------------------------------------------------------------------------------------------------------------------------------------------------"

         # Install Common Services
        export INSTALL_CS=false
