#!/bin/bash

# Usage: ./Create-Certificate.sh <key_to_create> <hostname. 

# 1. Create CSR
openssl req -new -sha256 -key $1 -subj "/CN=`$2`" -out `$2`.csr

# 2. Sign wth CA
