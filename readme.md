# Project: Basic Infrastructure Deployment with Terraform on AWS using AWS ECS
# Dependencies
Tools required:
- git
- terraform
- a working internet connection

# Prework (Setting up the AWS account)
First, we need to create an aws account if we havent already, and enable MFA
for the root user of the account. Then we need to create a seperate user for
Terraform to use, and attach an IAM policy to allow TF to create resources.
For the policy, I will simply use AdministratorAccess. Also for some level of
safety, let's disable console access for this user.

# Setting up Terraform on a workstation
Now that we have a user in AWS for terraform to leverage, we need to setup the
client side. To do this, we need to create access keys to allow programmatic
access to AWS. Once we have this keypair, we need to add it to ~/.aws/credentials.

## Making things happen with Terraform
Let's add a provider block. Normally, one would create seperate files and provide proper
structure to the directory, but for this, let's dump all terraform code into a main.tf.

Now that we have a provider, let's pull in our modules. But first, let's create a simple alias
for our shell: `alias tf='terraform'` just let's us more easily type the command.

Let's commit these changes after Terraform is successfully initialized. While we're here, let's
add a `.gitignore` since it will prevent git from storing files we dont necessarily need. We also
should add it to the commit's before we actually introduce the files we dont want.


