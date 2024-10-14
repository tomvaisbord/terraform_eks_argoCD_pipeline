terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.67.0"  # Update this to the desired version
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.32.0"  # Update this to the desired version
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.15.0"  # Update this to the desired version
    }
  }
}

# AWS Provider to interact with AWS resources
provider "aws" {
  region = var.region
}

# Kubernetes provider to interact with the EKS cluster
provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.certificate_authority_data)
  token                  = data.aws_eks_cluster_auth.auth.token
}

# Data block to fetch EKS cluster authentication token
data "aws_eks_cluster_auth" "auth" {
  name = module.eks.cluster_name
}

# Helm provider for installing the AWS Load Balancer Controller
provider "helm" {
  kubernetes {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.certificate_authority_data)
    token                  = data.aws_eks_cluster_auth.auth.token
  }
}

# VPC Module
module "vpc" {
  source       = "./modules/vpc"
  cluster_name = var.cluster_name
}

# EKS Module
module "eks" {
  source             = "./modules/eks"
  cluster_name       = "my-eks-cluster"
  eks_version        = "1.25"
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  public_subnet_ids  = module.vpc.public_subnet_ids
  region             = "eu-north-1"
  desired_size       = 2
  min_size           = 1
  max_size           = 3
  node_instance_types = ["t3.medium"]

  # Optionally pass the policy ARN
  cluster_role_policy = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

# App Deployment Module - Defines Kubernetes resources like Deployment, Service, and Ingress
module "app_deployment" {
  source = "./modules/app_deployment"
}
