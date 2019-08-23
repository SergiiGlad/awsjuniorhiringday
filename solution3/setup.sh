#!/bin/bash -e



FILE="~/.ssh/MyKeyPair.pem"

if [[ ! -f "$FILE" ]]; then

      echo "You should provide own key pair to connect Amazon EC2 using ssh"
      aws ec2 create-key-pair --key-name MyKeyPair \
      --query 'KeyMaterial' \
      --output text > ~/.ssh/MyKeyPair.pem

      chmod 400 ~/.ssh/MyKeyPair.pem
fi

echo "Key for ssh access : $FILE"

echo "Before running to check AWS CloudFormation template file for syntax errors"

aws cloudformation validate-template --template-body file://template.json

if [ $? -eq 0 ]; then
   echo "Template is OK"
else
    echo "template.json is bad"
    break
fi

echo "ENTER EMAIL for AWS Notification"

read EMAIL

echo "Start the zero-downtime deployment"

aws cloudformation create-stack --stack-name site \
--template-body file://template.json \
--parameters \
ParameterKey=KeyName,ParameterValue=MyKeyPair \
ParameterKey=OperatorEMail,ParameterValue=$EMAIL \
--capabilities CAPABILITY_IAM

echo "Wait until CloudFormation stack is created"

aws cloudformation wait stack-create-complete --stack-name site

echo "Done! Send an HTTP request to the following URL"

echo "http://$(aws cloudformation describe-stacks --stack-name site --query "Stacks[0].Outputs[1].OutputValue" --output text)"

echo "For deploing new version site you should change file /html/index.html"
echo "and run scritp update-site.sh"

NAME_BUCKET=$(aws cloudformation describe-stacks \
--stack-name site \
--query "Stacks[0].Outputs[0].OutputValue" \
--output text)

echo "Source Bucket for site AWS S3 $NAME_BUCKET"
