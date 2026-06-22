output "execution_role_arn" {
  value = aws_iam_role.ecs_execution_role.arn
}

output "github_oidc_role_arn" {
  value = aws_iam_role.github_execution_role.arn
}