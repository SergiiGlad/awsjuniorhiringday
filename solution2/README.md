## Create automated web site release that deploy site files to group of EC2 with auto scaling group and email notification state pipeline.
___

### AWS Services
---
The following AWS services are used to create a Continuous Delivery pipeline:

  * CloudFormation
  * ElasticBeanstalk
  * CodePipeline
  * S3
  * AutoScaling
  * IAM
  * SNS



### Setup cli

Follow the first steps to install and configure the AWS command line tool [Installing the AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html)

### Setup instructions

Clone the repository of (download the ZIP file)[html://]

```
git clone https://github.com/SergiiGlad/awsjuniorhiringday.git

cd solution2

```



### Environment variable

Name | Defaults | Notes
--- | --- | ---
NAME_STACK | app-site | CloudFormation Stack Name
REGION | us-east-1 | AWS Region
APP_NAME | php-sample.zip | Source S3 Bucket
INSTANCE | t2.micro | EC2 type
KeyName | MyKeyPair| ssh key to access EC2 instance
MinSize | 1 | Autoscaling min MinSize
MaxSize | 3 | Autoscaling max MaxSize
EmailAddress | nobody@amazone.com | EmailAddress for notification Pipeline state
NamePipeline | demoPipeline | Code Pipeline
NAME_BUCKET | NAME_BUCKET | S3 ArtifactStore

[You should provide own key pair to connect Amazon EC2 using ssh](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html)

```
aws ec2 create-key-pair --key-name MyKeyPair --query 'KeyMaterial' --output text > ~/.ssh/MyKeyPair.pem

chmod 400 /Users/sgladc/.ssh/MyKeyPair.pem
```

Before running to check AWS CloudFormation template file for syntax errors

```
aws cloudformation validate-template --template-body file://site-cfn-template.json

```

Create pipeline stack with CloudFormation
Change EmailAddress value on your email address

```
aws cloudformation create-stack --stack-name app-site \
--template-body file://site-cfn-template.json \
--parameters \
ParameterKey=KeyName,ParameterValue=MyKeyPair \
ParameterKey=EmailAddress,ParameterValue=nobody@gmail.com \
--capabilities CAPABILITY_IAM

```

Wait until CloudFormation stack is created

```
aws cloudformation wait stack-create-complete --stack-name app-site

```

Information about created stacks
```
aws cloudformation describe-stacks --stack-name app-site

```


Information about the pipeline and status
```
aws codepipeline get-pipeline --name demoPipeline

aws codepipeline get-pipeline-state --name demoPipeline

```


List S3 bucket name for site ```aws s3 ls```

To get name of bucket
```
BUCKET_NAME=$(aws cloudformation describe-stacks --stack-name app-site --query "Stacks[0].Outputs[1].OutputValue" --output text)

```

Create zip file and copy file to S3 bucket
```
zip php-sample.zip -j site/*
aws s3 cp php-sample.zip s3://$BUCKET_NAME

```

Pipeline runs right now and wait until the first pipeline release site is finished
Confirm subscription on AWS Pipeline and check EmailAddress notification status

### Open new version of site to view

Visit the website to command ```open ``` for MAC OS or ```google-chrome``` for Linux or copy link to browser for other OS ( Link to reference Balancer DNS name)

```
open "http://$(aws cloudformation describe-stacks --stack-name app-site --query "Stacks[0].Outputs[0].OutputValue" --output text)"

```

### Repeat to copy new version of site

```
zip php-sample.zip -j site/*
aws s3 cp php-sample.zip s3://$NAME_BUCKET

```

## Clean up

You should empty the S3 Bucket and all versions

```
chmod +x delete-all-object-version.sh
./delete-all-object-version.sh $NAME_BUCKET

```

Then remove CloudFormation stack

```
aws cloudformation delete-stack --stack-name app-site

aws cloudformation wait stack-delete-complete --stack-name app-site

```
