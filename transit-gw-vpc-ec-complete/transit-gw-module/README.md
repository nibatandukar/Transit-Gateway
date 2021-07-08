#Create Transit Gateway Using Terraform

* There are four module used to create a transit gateway and 3 diffrent accoun.
* aws-ec2 module is used to create EC2 instance.
* aws-sg-tgw module  is used to create Security Group.
* vpc-module directory contains the module for the creation of the VPC.
* To create a transit gateway one can apply main.tf file.
* Automation account used for the creation of transit gateway only. Chris and Mark account is used to create VPC, EC2 instances and accept the transit gateway request.
* There are three role created which helps to switch the role during the terrform apply.
* Any account to be added need to create a role and add to the provider.

