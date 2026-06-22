#GITHUB PARAMETERS
variable "repository" {
  type        = string
  description = "Repo of where the project"
  default     = "ecs-memos-fargate"
}

variable "organistaion_name" {
  type = string
  description = "Github username or organisation owning target repo"
  default = "Shahan15"
}
