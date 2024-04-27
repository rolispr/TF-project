// we could add a terraform block here to say what this version of tf we're compatible with

provider "aws" {
  region = "us-east-2"
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "all" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

resource "aws_ecs_cluster" "tf-ex-cluster" {
  name = "tf_hellow"
}

resource "aws_ecs_service" "tf-ex-service" {
  name            = "tf-ex-service"
  cluster         = aws_ecs_cluster.tf-ex-cluster.arn
  launch_type     = "FARGATE"
  // desired_count = 1

  network_configuration {
    subnets = data.aws_subnets.all.ids
    // assign_public_ip = true
  }
}

resource "aws_iam_role" "task-execution" {
  name               = "${aws_ecs_cluster.tf-ex-cluster.name}-ecs-execution"
  assume_role_policy = data.aws_iam_policy_document.assume-execution.json
}

resource "aws_iam_role_policy_attachment" "attach-execution" {
  role       = aws_iam_role.task-execution.id
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

data "aws_iam_policy_document" "assume-execution" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

