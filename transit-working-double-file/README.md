## Create VPC and transit gateway in multiple accounts

* This creates the transit gateway and vpc in multiplt accounts
* There are two differnet directories; one is for the source account i.e. account1 and another is for destination account i.e. account2
* You need to apply the changes in the account1 i.e. source account first and then to account2 i.e. destination account
* You need to export the AWS_PROFILE each time you apply to the respective account
* In the source account i.e. account1, you need to put the account number of the destination account in the RAM Principle. This sends the invitation to the destination account.
* In the destination you need to put the transit gateway id and arn number of the transit gateway manually

