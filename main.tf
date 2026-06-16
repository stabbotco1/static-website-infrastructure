terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    # Configuration loaded dynamically by deploy script
  }
}

provider "aws" {
  region = "us-east-1"
}

# Get current caller identity and region
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
data "aws_iam_account_alias" "current" {}

# Get git remote URL for project identification
data "external" "git_info" {
  program = ["bash", "-c", <<-EOT
    REMOTE_URL=$(git remote get-url origin 2>/dev/null || echo "")
    if [[ "$REMOTE_URL" =~ github\.com[:/]([^/]+)/([^/.]+) ]]; then
      PROJECT_NAME="$${BASH_REMATCH[2]}"
      REPO_URL="$REMOTE_URL"
      GITHUB_REPO="$${BASH_REMATCH[1]}/$${BASH_REMATCH[2]}"
    else
      PROJECT_NAME="unknown"
      REPO_URL="unknown"
      GITHUB_REPO="unknown/unknown"
    fi
    echo "{\"project_name\":\"$PROJECT_NAME\",\"repository\":\"$REPO_URL\",\"github_repository\":\"$GITHUB_REPO\"}"
  EOT
  ]
}

# Discover all domain directories
locals {
  # Find all domain/environment combinations
  domain_paths = fileset("${path.module}/projects", "**/*/domain.tf")
  
  # Parse domain structure: projects/{domain}/{environment}/domain.tf
  domains = {
    for file_path in local.domain_paths :
    "${split("/", file_path)[0]}-${split("/", file_path)[1]}" => {
      domain_safe  = split("/", file_path)[0]
      environment  = split("/", file_path)[1]
      config_path  = "${path.root}/projects/${file_path}"
    }
  }

  # Git information
  git_project_name    = data.external.git_info.result.project_name
  git_repository      = data.external.git_info.result.repository
  git_github_repo     = data.external.git_info.result.github_repository
}

# Standard tags for all resources
module "standard_tags" {
  for_each = local.domains

  source = "./modules/standard-tags"

  project       = local.git_project_name
  repository    = local.git_repository
  environment   = each.value.environment
  deployed_by   = data.aws_caller_identity.current.arn
  managed_by    = "OpenTofu"
  account_alias = data.aws_iam_account_alias.current.account_alias
}

# Deploy domain infrastructure for each domain/environment
module "domains" {
  for_each = local.domains

  source = "./modules/domain"

  domain_name         = replace(each.value.domain_safe, "-", ".")
  environment         = lower(each.value.environment)
  coming_soon_content = templatefile("${path.module}/templates/coming-soon.html", {
    domain_name = replace(each.value.domain_safe, "-", ".")
    title       = "Coming Soon"
    message     = "This website is under construction. Please check back soon!"
  })
  tags = module.standard_tags[each.key].tags
}

# Outputs
output "deployed_domains" {
  description = "Information about all deployed domains"
  value = {
    for key, domain in module.domains : key => {
      domain_name              = replace(local.domains[key].domain_safe, "-", ".")
      environment              = local.domains[key].environment
      bucket_name              = domain.bucket_name
      bucket_arn               = domain.bucket_arn
      cloudfront_distribution_id = domain.cloudfront_distribution_id
      cloudfront_domain_name   = domain.cloudfront_domain_name
      certificate_arn          = domain.certificate_arn
      hosted_zone_id           = domain.hosted_zone_id
    }
  }
}

output "git_info" {
  description = "Git repository information"
  value = {
    project_name    = local.git_project_name
    repository      = local.git_repository
    github_repo     = local.git_github_repo
  }
}
