#!/bin/bash
  
DOMAIN=$1
PRIVATE_KEY_NAME=privkey1

# renewal cert by letsencrypt
/back/third-party/letsencrypt/letsencrypt-auto renew --quiet --no-self-upgrade

# create private key rsa format for jenkins
openssl rsa -inform pem -in /etc/letsencrypt/archive/$DOMAIN/$PRIVATE_KEY_NAME.pem -outform pem > /etc/letsencrypt/archive/$DOMAIN/$PRIVATE_KEY_NAME-rsa.pem
