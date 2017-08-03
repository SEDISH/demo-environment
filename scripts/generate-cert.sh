#!/bin/bash

openssl req  -nodes -new -x509  -keyout /etc/ssl/crt/server.key -out /etc/ssl/crt/server.cert
