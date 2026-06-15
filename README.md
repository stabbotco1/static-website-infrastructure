# Website Infrastructure

## Multi-domain Static Website Hosting

This project provides automated infrastructure deployment for multiple static websites using AWS managed services with automated SSL certificate management and global content distribution. Built with S3, CloudFront, Route53, and ACM, each domain receives dedicated infrastructure while sharing common patterns and operational procedures.

Repository: [website-infrastructure](https://github.com/stephenabbot/website-infrastructure)

## What Problem This Project Solves

Static websites require coordination between multiple AWS services for secure, performant hosting. Manual configuration creates inconsistency, security gaps, and operational overhead.

- Manual configuration creates inconsistency, security gaps, and operational overhead
- Managing SSL certificates, CloudFront distributions, and DNS records across multiple domains becomes complex and error-prone without automation

## What This Project Does

Provides automated infrastructure deployment for multiple static websites with complete SSL certificate management and global content distribution through AWS managed services.

- Discovers domain configurations dynamically through filesystem scanning
- Deploys complete static website infrastructure for each discovered domain
- Manages SSL certificate validation automatically through Route53 DNS
- Configures CloudFront distributions with security headers and compression
- Handles directory index rewriting for clean URLs using CloudFront Functions
- Implements canonical domain redirects for SEO optimization (www → non-www)
- Publishes infrastructure outputs to SSM Parameter Store for content projects
- Provides operational scripts for deployment, resource listing, and domain creation

## What This Project Changes

Enables secure static website hosting with global CDN distribution while establishing standardized infrastructure patterns and operational procedures across multiple domains.

### Resources Created

- S3 buckets with versioning, encryption, and public access blocks
- CloudFront distributions with Origin Access Control and security headers
- CloudFront Functions for directory index handling
- ACM certificates with DNS validation for apex and www subdomains
- Route53 hosted zones with A, AAAA, and CNAME records
- Route53 domain registrations with automatic nameserver updates
- S3 bucket policies restricting access to CloudFront only
- SSM parameters publishing resource identifiers for consuming projects

For detailed architecture information, see [architecture guide](https://github.com/stephenabbot/website-infrastructure/blob/main/docs/architecture.md). For SEO optimization details, see [SEO best practices](https://github.com/stephenabbot/website-infrastructure/blob/main/docs/seo-best-practices.md). For resource organization details, see [tagging guide](https://github.com/stephenabbot/website-infrastructure/blob/main/docs/tags.md).

### Functional Changes

- Enables secure static website hosting with global CDN distribution
- Provides automatic SSL certificate management and renewal
- Implements clean URL routing through CloudFront Functions
- Implements canonical domain strategy to consolidate SEO authority
- Establishes loose coupling between infrastructure and content projects
- Creates standardized tagging and naming conventions across domains

## Quick Start

Automated deployment and management through local scripts and GitHub Actions workflows.

1. **Bootstrap GitHub Integration**: Run `./scripts/bootstrap.sh` to configure GitHub repository variables for OIDC authentication
2. **Create Domain**: Use `./scripts/create-domain.sh <domain-name>` to add new domain configuration
3. **Deploy Infrastructure**: Run `./scripts/deploy.sh` locally or trigger GitHub Actions deploy workflow
4. **Verify Deployment**: Use `./scripts/list-deployed-resources.sh` to confirm infrastructure creation
5. **Monitor Workflows**: Use `./scripts/watch-workflow.sh [timeout] [run-id]` for GitHub Actions monitoring

For detailed prerequisites, see [prerequisites guide](https://github.com/stephenabbot/website-infrastructure/blob/main/docs/prerequisites.md). For content deployment procedures, see [content deployment guide](https://github.com/stephenabbot/website-infrastructure/blob/main/docs/content-deployment.md). For script usage details, see [usage guide](https://github.com/stephenabbot/website-infrastructure/blob/main/docs/usage.md). For troubleshooting, see [troubleshooting guide](https://github.com/stephenabbot/website-infrastructure/blob/main/docs/troubleshooting.md). For operational procedures, see [operations guide](https://github.com/stephenabbot/website-infrastructure/blob/main/docs/operations.md).

### Available Scripts

- `bootstrap.sh` - Configure GitHub repository variables for OIDC authentication
- `create-domain.sh` - Add new domain configuration to projects directory
- `deploy.sh` - Deploy all domain infrastructure using OpenTofu
- `destroy.sh` - Remove all infrastructure with confirmation prompts
- `list-deployed-resources.sh` - Display current infrastructure status and resources
- `watch-workflow.sh` - Monitor GitHub Actions workflows with configurable timeout
- `verify-prerequisites.sh` - Validate required tools and AWS configuration

### GitHub Actions Workflows

- **Deploy Infrastructure** - OIDC-authenticated deployment triggered manually via workflow dispatch
- **Destroy Infrastructure** - OIDC-authenticated destruction with confirmation requirement

Current deployed domains: denverbites.com, denverbytes.com, bittikens.com

## AWS Well-Architected Framework

This project demonstrates alignment with the [AWS Well-Architected Framework](https://aws.amazon.com/blogs/apn/the-6-pillars-of-the-aws-well-architected-framework/):

### Operational Excellence

- Infrastructure as Code using OpenTofu with version control
- Automated deployment through GitHub Actions and local scripts
- Comprehensive resource tagging for operational visibility
- SSM Parameter Store integration for service discovery
- Idempotent deployment operations supporting multiple executions

### Security

- S3 public access blocks preventing direct bucket access
- CloudFront Origin Access Control restricting S3 access
- SSL/TLS certificates with automatic DNS validation
- Encrypted S3 storage using AES256 server-side encryption
- IAM role-based deployment with least privilege principles

### Reliability

- Multi-AZ CloudFront distribution with global edge locations
- S3 versioning enabled for content recovery capabilities
- Route53 DNS with both IPv4 and IPv6 support
- Certificate validation with configurable timeouts
- Error page handling redirecting client errors to homepage

### Performance Efficiency

- CloudFront global CDN reducing latency worldwide
- Compression enabled for faster content delivery
- HTTP to HTTPS redirects ensuring secure connections
- Directory index CloudFront Function enabling clean URLs
- PriceClass_100 covering US and Europe regions

### Cost Optimization

- Serverless architecture with pay-per-use pricing model
- CloudFront PriceClass_100 optimizing costs for primary regions
- S3 lifecycle management through versioning capabilities
- Managed services reducing operational overhead costs

## Technologies Used

| Technology | Purpose | Implementation |
|------------|---------|----------------|
| Kiro CLI with Claude | AI-assisted development, design, and implementation | Project architecture design and infrastructure code generation |
| OpenTofu | Infrastructure as Code | Version 1.0+ with AWS provider ~5.0 for multi-service orchestration |
| AWS S3 | Static website storage | Versioned buckets with AES256 server-side encryption and public access blocks |
| AWS CloudFront | Global content distribution | Origin Access Control with CloudFront Functions for directory index handling |
| AWS Route53 | DNS management | Hosted zones with A/AAAA records and automatic domain registration |
| AWS ACM | SSL certificate management | DNS validation through Route53 with automatic certificate provisioning |
| AWS SSM | Parameter storage | Infrastructure outputs published for consuming project service discovery |
| Bash | Deployment automation | Scripts for domain creation, deployment orchestration, and resource management |
| GitHub Actions | CI/CD pipeline | OIDC-based deployment workflows with manual triggers and environment protection |
| Git | Version control | Repository metadata extraction for automated resource naming and tagging |
| jq | JSON processing | Infrastructure output parsing, parameter handling, and configuration processing |

## Copyright

© 2025 Stephen Abbot - MIT License
