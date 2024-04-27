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

Now we're ready to actually begin building cloud resources with terraform!

## Building ECS
Firstly, it's always a good idea to consult official docs from aws themselves
in case something new's happend.
See: https://docs.aws.amazon.com/AmazonECS/latest/developerguide
https://aws.amazon.com/getting-started/hands-on/deploy-docker-containers/
Is also a good ref for an overview of what we're building.
https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_vpc
Tell's us that the default VPC is adopted by terraform. And since we're using a version of TF
over v1.5.0, let's add an import block to pull in our default vpc to use later. We will need
to go to the console, or use the aws cli, to grab the id of this vpc. Since we're using the default
vpc, public subnets, routes, and an IGW is provided for us. Actually, let's not use default_vpc resource
and import. Let's use the data block to pull in data from an existing resource so we can refer to it
in other blocks. More on that here: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc

After we have this, let's run `tf plan`.

We see that terraform's able to read our default VPC. Great! Since time isnt on our side with 2 hours, let's
start adding the other networking components we need like the subnet. We should put these values we provide
to the attributes through a `variables.tf` file but we'll keep it super basic and just manually put in values.

Now let's run `tf plan` and see the results. Looks good. Now let's commit.

Let's now focus on the meat of ECS: it's service and task defintion, as well as creating a role for task
execution. Let's tf apply to see our plan, what terraform wants to do, and then apply what we have.

As we can see, we cant leave the task-definition attribute blank:
```
...
aws_ecs_cluster.tf-ex-cluster: Creating...
aws_ecs_cluster.tf-ex-cluster: Still creating... [10s elapsed]
aws_ecs_cluster.tf-ex-cluster: Creation complete after 11s [id=arn:aws:ecs:us-east-2:524066333174:cluster/tf_hellow]
aws_iam_role.task-execution: Creating...
aws_ecs_service.tf-ex-service: Creating...
aws_iam_role.task-execution: Creation complete after 1s [id=tf_hellow-ecs-execution]
aws_iam_role_policy_attachment.attach-execution: Creating...
aws_iam_role_policy_attachment.attach-execution: Creation complete after 0s [id=tf_hellow-ecs-execution-20240426235321253400000002]
╷
│ Error: creating ECS Service (tf-ex-service): InvalidParameterException: TaskDefinition can not be blank.
│
│   with aws_ecs_service.tf-ex-service,
│   on main.tf line 22, in resource "aws_ecs_service" "tf-ex-service":
│   22: resource "aws_ecs_service" "tf-ex-service" {
│
╵
```

So we need to create a dockerfile. Here, I'll use busybox. You could abs use Apache or Nginx but busybox it is!
