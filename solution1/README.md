___
<p align=center>AWS Services</p>
___

## AWS CloudFormation Sample Template 
#### Create load balanced and Auto Scaled Group sample web site running on an Nginx Web Server. The application is configured to span all EC2  and is Auto-Scaled based on the CPU utilization of the web servers. Notifications will be sent to the operator email address on scaling events. The instances are load balanced with a simplehealth check against the default web page.

The following AWS services are used to create a Continuous Delivery pipeline:

  * CloudFormation
  * CodeDeploy
  * CodePipeline
  * S3
  * AutoScaling
  * IAM
  * SNS


### Setup cli

Follow the first steps to install and configure the AWS command line tool [Installing the AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html)

### Create instructions 
_( tested on us-west-2 region )_

Clone the repository of (download the ZIP file)[html://]

Before starting

[You should provide own key pair to connect Amazon EC2 using ssh](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html)

```
aws ec2 create-key-pair --key-name MyKeyPair \
--query 'KeyMaterial' \
--output text > ~/.ssh/MyKeyPair.pem

chmod 400 ~/.ssh/MyKeyPair.pem

```

Before running to check AWS CloudFormation template file for syntax errors

```
aws cloudformation validate-template --template-body file://site-deployment-template.json

```

Start the zero-downtime deployment
<p>Change OperatorEMail value on your email address

```
aws cloudformation create-stack --stack-name demo-site \
--template-body file://site-deployment-template.json \
--parameters \
ParameterKey=KeyName,ParameterValue=MyKeyPair \
ParameterKey=OperatorEMail,ParameterValue=nobody@gmail.com \
--capabilities CAPABILITY_IAM

```

Wait until CloudFormation stack is created

```
aws cloudformation wait stack-create-complete --stack-name demo-site

```

Information about created stacks and site name
```
aws cloudformation describe-stacks --stack-name demo-site

```

Information about the pipeline and status
```
aws codepipeline get-pipeline --name CodePipeline

aws codepipeline get-pipeline-state --name CodePipeline

```


List S3 bucket name for site ```aws s3 ls```

To get name of bucket
```
NAME_BUCKET=$(aws cloudformation describe-stacks \
--stack-name demo-site \
--query "Stacks[0].Outputs[0].OutputValue" \
--output text)

```

Create zip file and copy file to S3 bucket
```
zip app.zip html/* deploy/* appspec.yml
aws s3 cp app.zip s3://$NAME_BUCKET

```

Pipeline runs right now and wait until the first pipeline release site is finished
Confirm subscription on AWS Pipeline and check EmailAddress notification status

### Open new version of site to view

Visit the website to command ```open ``` for MAC OS or ```google-chrome``` for Linux or copy link to browser for other OS ( Link to reference Balancer DNS name)

```
open "http://$(aws cloudformation describe-stacks \
--stack-name demo-site \
--query "Stacks[0].Outputs[1].OutputValue" \
--output text)"

```

### Repeat to copy new version of site

```
zip app.zip html/* deploy/* appspec.yml
aws s3 cp app.zip s3://$NAME_BUCKET

```

## Clean Up

You should empty the S3 Bucket all versions
```
chmod +x delete-all-object-version.sh
./delete-all-object-version.sh $NAME_BUCKET

```

Then remove CloudFormation stack

```
aws cloudformation delete-stack --stack-name demo-site

aws cloudformation wait stack-delete-complete --stack-name demo-site

```

Delete the Key pair and Key file
```
aws ec2 delete-key-pair --key-name MyKeyPair

rm -f ~/.ssh/MyKeyPair.pem

```
