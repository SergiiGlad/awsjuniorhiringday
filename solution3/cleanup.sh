#!/bin/bash -e

echo "You should empty the S3 Bucket all versions"

NAME_BUCKET=$(aws cloudformation describe-stacks \
--stack-name site \
--query "Stacks[0].Outputs[0].OutputValue" \
--output text)

./delete-all-object-version.sh $NAME_BUCKET

echo "Remove CloudFormation stack"

aws cloudformation delete-stack --stack-name site
aws cloudformation wait stack-delete-complete --stack-name site

echo "Delete the Key pair and Key file"

aws ec2 delete-key-pair --key-name MyKeyPair
rm -f /Users/sgladc/.ssh/MyKeyPair.pem
