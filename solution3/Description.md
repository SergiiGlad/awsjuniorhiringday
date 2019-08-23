## Description all step

[You should provide own key pair to connect Amazon EC2 using ssh](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html)

```
aws ec2 create-key-pair --key-name MyKeyPair \
--query 'KeyMaterial' \
--output text > ~/.ssh/MyKeyPair.pem

chmod 400 ~/.ssh/MyKeyPair.pem

```

Before running to check AWS CloudFormation template file for syntax errors

```
aws cloudformation validate-template --template-body file://template.json

```

Start the zero-downtime deployment

```
aws cloudformation update-stack --stack-name site \
--template-body file://template.json \
--parameters \
ParameterKey=KeyName,ParameterValue=MyKeyPair \
ParameterKey=OperatorEMail,ParameterValue=nobody@gmail.com \
--capabilities CAPABILITY_IAM

```

Wait until CloudFormation stack is created

```
aws cloudformation wait stack-create-complete --stack-name site

```

Information about created stacks
```
aws cloudformation describe-stacks --stack-name site

```

Information about the pipeline and status
```
aws codepipeline get-pipeline --name myCodePipeline

aws codepipeline get-pipeline-state --name myCodePipeline

```


List S3 bucket name for site ```aws s3 ls```

To get name of bucket

```
NAME_BUCKET=$(aws cloudformation describe-stacks \
--stack-name site \
--query "Stacks[0].Outputs[0].OutputValue" \
--output text)

echo $NAME_BUCKET

```

Create zip file and copy file to S3 bucket
```
zip app.zip html/* deploy/* lambda/* appspec.yml
aws s3 cp app.zip s3://$NAME_BUCKET

```

Pipeline runs right now and wait until the first pipeline release site is finished
Confirm subscription on AWS Pipeline and check EmailAddress notification status

### Open new version of site to view

Visit the website to command ```open ``` for MAC OS or ```google-chrome``` for Linux or copy link to browser for other OS ( Link to reference Balancer DNS name)

```
open "http://$(aws cloudformation describe-stacks \
  --stack-name site \
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
./delete-all-object-version.sh $NAME_BUCKET

```

Then remove CloudFormation stack

```
aws cloudformation delete-stack --stack-name site

aws cloudformation wait stack-delete-complete --stack-name site

```

Delete the Key pair and Key file
```
aws ec2 delete-key-pair --key-name MyKeyPair

rm -f /Users/sgladc/.ssh/MyKeyPair.pem

```
