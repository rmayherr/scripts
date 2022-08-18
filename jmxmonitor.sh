#!/usr/bin/env bash

HOST=stutvs15.megacenter.de.ibm.com
PORT=14015
#JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk.x86_64
JMX_HOME=/home/rmayherr/Documents/JMX
CLASSPATH=$JAVA_HOME/lib/jconsole.jar
CLASSPATH=$JMX_HOME:com.ibm.ws.admin.client_8.5.0.jar
CLASSPATH=$JMX_HOME:com.ibm.ws.ejb.thinclient.zos_8.5.0.jar

#-Dcom.ibm.IPC.ConfigURL=file:$JMX_HOME/ipc.client.props \
CLIENTSAS=-Dcom.ibm.CORBA.ConfigURL=file:$JMX_HOME/sas.client.props \
#-Dcom.ibm.SOAP.ConfigURL=file:$JMX_HOME/soap.client.props \
CLIENTSSL=-Dcom.ibm.SSL.ConfigURL=file:$JMX_HOME/ssl.client.props \
#-Djavax.net.ssl.trustStore=$TRUSTSTORE \
#-Djavax.net.ssl.trustStore=$KEYSTORE \
#$JAVA_HOME/bin/jconsole -debug \
jconsole -debug \
-J-Djava.class.path=$CLASSPATH \
-J$CLIENTSAS \
-J$CLIENTSSL \
service:jmx:iiop://$HOST:$PORT/jndi/JMXConnector

