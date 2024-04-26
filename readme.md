# Project: Basic Infrastructure Deployment with Terraform on AWS using AWS ECS
# Dependencies
Tools required:
- git
- terraform
- a working internet connection

# Prework (Setting up the AWS account)
First, we need to create an aws account if we havent already, and enable MFA for the root user of the account.
Then we need to create a seperate user for Terraform to use, and attach an IAM policy to allow TF to create resources.
For the policy, I will simply use AdministratorAccess. Also for some level of safety, let's disable console access for this user.

# Setting up Terraform on a workstation
Now that we have a user in AWS for terraform to leverage, we need to setup the client side. To do this, we need
to create access keys to allow programmatic access to AWS.
