
wget https://sgmanager.eu-de.bluemix.net/installers/ibm-securegateway-client-1.8.6fp1+client_x86_64.rpm

sudo su -

rpm -ivhf ibm-securegateway-client-1.8.6fp1+client_x86_64.rpm




rpm -q ibm-securegateway-client
cat /var/log/securegateway/client_console_2020_11_20.log
rpm -qa | grep ibm-securegateway-client
yum remove ibm-securegateway-client


