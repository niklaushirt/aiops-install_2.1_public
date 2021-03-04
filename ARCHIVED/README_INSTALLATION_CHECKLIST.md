# Watson AIOps Demo Environment Installation - Checklist


## Prerequisites
 🔲 Install Tooling
 
 🔲 Get the scripts and code from GitHub


## AI and Event Manager Base Install
 🔲 Adapt install configuration
 
 🔲 Start installation
 
 🔲 Create NOI User that can see Topology

## Demo Apps in AI Manager
 🔲 Create Dummy Slack integration
 
 🔲 Create Apps

## Demo Apps
 🔲 Install Bookinfo
 
   ⬜ Install Bookinfo genereate load
   
 🔲 Install Kubetoy
 
 🔲 Install SockShop
 
   ⬜ Install SockShop genereate load
   


## HUMIO
 🔲 Install HUMIO
 
   ⬜ Change developer password
   
 🔲 Configure Humio

 🔲 Humio Fluentbit
 
   ⬜ Install DaemonSet
   
   ⬜ Modify DaemonSet

 🔲 Configure Humio Notifier
 
 🔲 Create Alerts
 
   ⬜ BookinfoProblem
   
   ⬜ BookinfoRatingsDown
   
   ⬜ BookinfoReviewsProblem
   
   ⬜ KubetoyLivenessProbe
   
   ⬜ KubetoyAvailabilityProblem
   
   ⬜ SockShopAvailability
   
   ⬜ SockShopCatalogue

## Train the Models
 🔲 Prerequisite - adapt for ROKS S3 Storage
 
 🔲 Training - Bookinfo 
 
 🔲 Training - Sockshop 
 
 🔲 Training - Kubetoy 


## Humio Connection from AI Manager (Ops Integration)
 🔲 Create Ops Integration on Bookinfo App

 🔲 Create Ops Integration on Sockshop App
 
## NOI Connection from AI Manager (Ops Integration)
 🔲 Create NOI Ops Integration
 
 🔲 Create Log Ops Integration

## NOI Webhooks
 🔲 Humio Webhook
 
 🔲 Falco Webhook
 
 🔲 Git Webhook
 
 🔲 Metrics Webhook
 
 🔲 Instana Webhook
 
 🔲 Copy the Webhook URLS into 01_config.sh
 
 🔲 Create NOI Menu item


## Configure Event Manager / ASM Topology
 🔲 Load Topologies for Sockshop and Bookinfo
 
 🔲 Create Templates
 
 🔲 Create grouping Policy


## Configure Runbooks
 🔲 Create Bastion Server
 
 🔲 Create the NOI Integration
 
   ⬜ In NOI
   
   ⬜ Adapt SSL Certificate in Bastion Host Deployment.
   
 🔲 Create Automation
 
 🔲 Create Runbooks
 
 🔲 Add Runbook Triggers
 


## Install Event Manager Gateway
 🔲 Create Strimzi route
 
 🔲 Copy secret strimzi-cluster-cluster-ca-cert
 
 🔲 Get needed info
 
 🔲 Modify Template
 
 🔲 Apply Manifest


## Create ASM Integration in AI Manager
 🔲 Create the Operations integration for the AppGroup
 
   ⬜ Get certificate
   
   ⬜ Input values
   
 🔲 Check ASM connection


## Slack integration
 🔲 Refresh ingress certificates (otherwise Slack will not validate link)
 
 🔲 Intefration
 
 🔲 Change the Slash Welcome Message


## Some Polishing
 🔲 Make Flink Console accessible
 
 🔲 Check if data is flowing
 
 🔲 Create USER
 
 🔲 Change admin password AI Manager
