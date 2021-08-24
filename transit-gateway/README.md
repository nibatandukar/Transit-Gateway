# Create Transit gateway in one account and VPC in two different accounts using terragrunt

* There are 4 differnet modules used.
* The state file is in S3 bucket. You can edit its configuration from terragrunt.hcl
* One for vpc and subnets, another for transit gateway, other for security group and last for ec2 instance
* The variable are passed inside main.tg
* The account number are provided in accouns.json
* You can edit the region inside transit-gateway/ap-south-1/region.hcl
* When you add or rename the account name in accounts.json, make sure to rename the account name inside transit-gateway/account.hcl
* You can plan the infrastructure by using terragrunt run-all plan in transit-gateway directory or run plan.sh
* You can apply the infrastructure by using terragrunt run-all apply in transit-ga
teway directory or run apply.sh
* You can destroy the infrastructure by using terragrunt run-all destroy in transit-ga
teway directory or run destroy.sh
