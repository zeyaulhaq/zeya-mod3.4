variable "region" {
  type        = string
  description = "AWS region"
}

variable "github_username" {
  type        = string
  description = "Your GitHub username"
}

variable "github_repo" {
  type        = string
  description = "Your GitHub repository name"
}

variable "role_name" {
  type        = string
  description = "Name of the IAM role for GitHub OIDC"
}
