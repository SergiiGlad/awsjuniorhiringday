## AWS CloudFormation Sample Template to create load balanced and Auto Scaled Group sample web site running on an Nginx Web Server. The application is configured to span all EC2  and is Auto-Scaled based on the CPU utilization of the web servers. Notifications will be sent to the operator email address on scaling events. The instances are load balanced with a simple health check against the default web page. Automates the integration between AWS Lambda function health site in CodePipeline.

### AWS Services
---
The following AWS services are used to create a Continuous Delivery pipeline:

  * CloudFormation
  * CodeDeploy
  * CodePipeline
  * S3
  * AutoScaling
  * IAM
  * SNS
  * Lambda

## Solution with Lambda

git clone https://github.com/SergiiGlad/awsjuniorhiringday.git

cd solution3



### Setup cli

Follow the first steps to install and configure the AWS command line tool [Installing the AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html)



## Instructions to use the script files

  Use the ./setup.sh script to create a Continuous Deployment.


  Change html/index.html for new version site


  Use the ./update-site.sh to update site.


  Use the cleanup.sh to clean AWS resourses
  
## Description the steps

[Description](Description.md)
