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
