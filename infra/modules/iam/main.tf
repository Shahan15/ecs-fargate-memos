#ECS Requires a service role to execute commands on your behalf
#This Creates the identity and defines who can use it
resource "aws_iam_role" "ecs_execution_role" {
  name = "memos-ecs-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

#Defines what the role is actually allowed to do
resource "aws_iam_role_policy_attachment" "ecs_execution_attach" {
  role       = aws_iam_role.ecs_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}


#OPEN ID 
resource "aws_iam_openid_connect_provider" "openid_provider" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = [
    "sts.amazonaws.com",
  ]
  #This is not used, but mandatory field.
  thumbprint_list = ["ffffffffffffffffffffffffffffffffffffffff"]
}


resource "aws_iam_role" "github_execution_role" {
  name = "github-actions-ecr-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity"
        Effect = "Allow"
        Principal = {
          Federated : aws_iam_openid_connect_provider.openid_provider.arn
        }
        "Condition" : {
          "StringEquals" : {
            "token.actions.githubusercontent.com:aud" : "sts.amazonaws.com"
          },
          "StringLike" : {
            "token.actions.githubusercontent.com:sub" : "repo:${var.organistaion_name}/*"
          }
        }
      }
    ]
  })
}


resource "aws_iam_role_policy_attachment" "github_oidc_role" {
  role       = aws_iam_role.github_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
}


# Policy defining access to Terraform state bucket
resource "aws_iam_policy" "github_s3_state_policy" {
  name        = "github-actions-s3-state-policy"
  description = "Allows GitHub Actions to read and write state files in the memos S3 bucket"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:ListBucket",
          "s3:GetBucketLocation"
        ]
        Resource = "arn:aws:s3:::shahan-memos-tf-state-bucket"
      },
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ]
        Resource = "arn:aws:s3:::shahan-memos-tf-state-bucket/*"
      }
    ]
  })
}

# Connects S3 state policy to GitHub execution role
resource "aws_iam_role_policy_attachment" "github_s3_state_attach" {
  role       = aws_iam_role.github_execution_role.name
  policy_arn = aws_iam_policy.github_s3_state_policy.arn
}


# Grouping the required managed policies for infrastructure
locals {
  github_policies = [
    "arn:aws:iam::aws:policy/AmazonVPCFullAccess",
    "arn:aws:iam::aws:policy/AmazonECS_FullAccess",
    "arn:aws:iam::aws:policy/AmazonRoute53FullAccess",
    "arn:aws:iam::aws:policy/AWSCertificateManagerFullAccess",
    "arn:aws:iam::aws:policy/IAMFullAccess",
    "arn:aws:iam::aws:policy/ElasticLoadBalancingFullAccess" #
  ]
}

resource "aws_iam_role_policy_attachment" "github_services_attach" {
  for_each   = toset(local.github_policies)
  role       = aws_iam_role.github_execution_role.name
  policy_arn = each.value
}
