#!/usr/bin/env bash

OSSL=`whereis openssl`
SIZE="2048"
KEYNAME="server"
COUNTRY="HU"
STATE="FEJER"
CITY="SZEKEFEHERVAR"
ORG="LOCAL"
ORGU=""
COMMONNAME="horus.rm.local"
DAYS="365"
CAKEY="ca.key"
CAPEM="ca.pem"

#Generate Certificate authority
function gen_ca {
	$OSSL genrsa -des3 -out $CAKEY $SIZE
}
#Generate root certificate
function gen_root {
	gen_ca
	$OSSL req -x509 -new -nodes -key $CAKEY -sha256 -days 1825 -out $CAPEM \
		-subj "/C="$COUNTRY"/ST="$STATE"/L="$CITY"/O="$ORG"/OU="$ORGU"/CN="$COMMONNAME
}
#Generate private key and certificate request for a self-signed certificate
function gen_key_csr {
	echo -n "Generating private key and CSR request..."
	$OSSL req -newkey rsa:$SIZE -nodes -keyout $KEYNAME".key" -out $KEYNAME".csr" \
		-subj "/C="$COUNTRY"/ST="$STATE"/L="$CITY"/O="$ORG"/OU="$ORGU"/CN="$COMMONNAME
}
#Generate a certificate request from an existing private key
function new_cert_req {
	if [[ $ARG2 == "" ]]; then
		echo "Keyname must be specified!"
		exit 1
	fi
	if test -f $KEYNAME".csr" ;then
		echo ""
		echo $KEYNAME".csr file exists. Do you want to override it? y/n"
		read ANSWER
		if [[ $ANSWER == "y" ]];then
			$OSSL req -key $ARG2 -new -out $KEYNAME".csr" \
				-subj "/C="$COUNTRY"/ST="$STATE"/L="$CITY"/O="$ORG"/OU="$ORGU"/CN="$COMMONNAME
		elif [[ $ANSWER == "n" ]];then
			echo "Type the new filename [certificate_req.csr]: "
			read ANSWER2
			$OSSL req -key $ARG2 -new -out $ANSWER2 \
				-subj "/C="$COUNTRY"/ST="$STATE"/L="$CITY"/O="$ORG"/OU="$ORGU"/CN="$COMMONNAME
		else
			echo "Quit."
			exit 1
		fi
	fi
}
#Generate a self-signed certificate
function gen_cert {
	if [[ $ARG2 == "" ]]; then
		echo "Filename must be specified!"
		exit 1
	fi
	if test -f $KEYNAME".key" ;then
		echo $KEYNAME".key file exists. Do yo want to override it? y/n"
		read ANSWER
		if [[ $ANSWER == "y" ]];then
			$OSSL req -newkey rsa:$SIZE -nodes -keyout $KEYNAME".key" -x509 -days $DAYS -out $ARG2 \
				-subj "/C="$COUNTRY"/ST="$STATE"/L="$CITY"/O="$ORG"/OU="$ORGU"/CN="$COMMONNAME
		elif [[ $ANSWER == "n" ]];then
			echo "Type the new filename [server.key]: "
			read ANSWER2
			$OSSL req -newkey rsa:$SIZE -nodes -keyout $ANSWER2 -x509 -days $DAYS -out $ARG2 \
				-subj "/C="$COUNTRY"/ST="$STATE"/L="$CITY"/O="$ORG"/OU="$ORGU"/CN="$COMMONNAME
		else
			echo "Quit."
			exit 1
		fi
	fi
}
#Generate certificate using existing key
function cert_from_key {
	if [[ $ARG2 == "" || $ARG3 == "" ]]; then
		echo "Filname must be specified!"
		exit 1
	fi
	$OSSL req -key $ARG2 -new -x509 -days $DAYS -out $ARG3 \
		-subj "/C="$COUNTRY"/ST="$STATE"/L="$CITY"/O="$ORG"/OU="$ORGU"/CN="$COMMONNAME
}
#Generate certificate signed by CA
function certificate_with_ca {
	$OSSL x509 -req -in $ARG2 -CA $CAPEM -CAkey $CAKEY -CAcreateserial -out $ARG3 -days $DAYS -sha256
}
#Verify CSR
function verify_req {
	$OSSL req -text -noout -verify -in $ARG2
}
#Verify certificate
function verify_cert {
	$OSSL x509 -text -noout -in $ARG2
}
#Verify certificate signed by ca
function verify_cert_ca {
	$OSSL verify -verbose -CAFile $ARG2 $ARG3
}
ARG2=$2
ARG3=$3

case "$1" in
	"--generate-root-certificate")
		gen_root
	;;
	"--new-request")
		gen_key_csr
	;;
	"--request-from-key")
		new_cert_req
	;;
	"--self-signed")
		gen_cert
	;;
	"--certificate-from-key")
		cert_from_key
	;;
	"--certificate-with-ca")
		certificate_with_ca
	;;
	"--verify-request")
		verify_req
	;;
	"--verify-certificate")
		verify_cert
	;;
	"--verify-certificate-with-ca")
		verify_cert_ca
	;;
	*)
	echo "Available options:"
	echo $0" [--generate-root-certificate | 
		  --new-request  | 
		  --request-from-key <keyname.key> | 
		  --self-signed | 
		  --certificate-from-key <keyname.key> <certificate.crt> |
		  --certificate-with-ca <request.csr> <certificate.crt>] |
		  --verify-request <request.csr> |
	  	  --verify-certificate <certificate.crt> |
		  --verify-certificate-with-ca <ca.crt> <certificate.crt>	  
	       "
esac

