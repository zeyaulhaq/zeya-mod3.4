terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region
}

# -----------------------------
# 1. GitHub OIDC Identity Provider
# -----------------------------
#resource "aws_iam_openid_connect_provider" "github" {
# url = "https://token.actions.githubusercontent.com"

#client_id_list = [
# "sts.amazonaws.com"
#]

#thumbprint_list = [
# "6938fd4d98bab03faadb97b34396831e3780aea1"
#]
#}

data "aws_iam_openid_connect_provider" "github" {
  arn = "arn:aws:iam::255945442255:oidc-provider/token.actions.githubusercontent.com"
}


# -----------------------------
# 2. Trust Policy for GitHub Actions
# -----------------------------
data "aws_iam_policy_document" "github_oidc_trust" {
  statement {
    effect = "Allow"

    principals {
      type        = "Federated"
      identifiers = [data.aws_iam_openid_connect_provider.github.arn]

    }

    actions = ["sts:AssumeRoleWithWebIdentity"]

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:sub"
      values = [
        "repo:${var.github_username}/${var.github_repo}:ref:refs/heads/main"
      ]
    }
  }
}

# -----------------------------
# 3. IAM Role for GitHub Actions
# -----------------------------
resource "aws_iam_role" "github_oidc_role" {
  name               = var.role_name
  assume_role_policy = data.aws_iam_policy_document.github_oidc_trust.json
}

# -----------------------------
# 4. Attach ECR Permissions
# -----------------------------
resource "aws_iam_role_policy_attachment" "ecr_full_access" {
  role       = aws_iam_role.github_oidc_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
}

# -----------------------------
# 5. Output Role ARN
# -----------------------------
output "github_oidc_role_arn" {
  value = aws_iam_role.github_oidc_role.arn
}
