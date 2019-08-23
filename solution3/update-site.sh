#!/usr/bin/env bash -e

NAME_BUCKET=$(aws cloudformation describe-stacks \
--stack-name site \
--query "Stacks[0].Outputs[0].OutputValue" \
--output text)

zip app.zip html/* deploy/* appspec.yml
aws s3 cp app.zip s3://$NAME_BUCKET

echo "To check Pipeline and wait"
aws codepipeline get-pipeline-state --name myCodePipeline
