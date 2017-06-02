#!/bin/bash

fileToUpload=$1

set -e

export AWS_PROFILE="default"
export AWS_CONFIG_FILE=$(pwd)/aws_config

aws s3 cp $fileToUpload s3://sedish-backup/

